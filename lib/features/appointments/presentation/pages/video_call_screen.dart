import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../domain/models/appointment.dart';
import '../../domain/services/signaling_service.dart';

class VideoCallScreen extends StatefulWidget {
  final String callId;
  final Appointment appointment;

  const VideoCallScreen({
    super.key,
    required this.callId,
    required this.appointment,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  MediaStream? _localStream;
  RTCPeerConnection? _peerConnection;
  bool _isCameraOn = true;
  bool _isMicOn = true;
  late SignalingService _signaling;
  bool _isInitiator = false;

  bool _isCallInitialized = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeCallSetup();
  }

  Future<void> _initializeCallSetup() async {
    try {
      await _initializeCall();
      await _setupSignaling();
      setState(() {
        _isCallInitialized = true;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to initialize call: $e';
      });
      print('Call initialization error: $e');
    }
  }

  Future<void> _setupSignaling() async {
    _signaling = SignalingService(
      userId: 'patient_${widget.appointment.id}',
      callId: widget.callId,
      serverUrl: 'ws://localhost:8080', // Use local development server
    );

    _signaling.onMessage = _handleSignalingMessage;

    try {
      await _signaling.connect();
      setState(() {
        _isInitiator = true;
      });
      if (_peerConnection != null) {
        await _createOffer();
      } else {
        throw Exception('PeerConnection not initialized');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Connection failed: $e';
      });
      if (kDebugMode) {
        print('Signaling connection error: $e');
      }
      rethrow;
    }
  }

  Future<void> _initializeCall() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    await _getUserMedia();
    await _createPeerConnection();
  }

  Future<void> _getUserMedia() async {
    await Permission.camera.request();
    await Permission.microphone.request();

    final Map<String, dynamic> constraints = {
      'audio': true,
      'video': {'facingMode': 'user'},
    };

    try {
      final stream = await navigator.mediaDevices.getUserMedia(constraints);
      _localStream = stream;
      _localRenderer.srcObject = stream;
      setState(() {});
    } catch (e) {
      print('Error getting user media: $e');
    }
  }

  Future<void> _createPeerConnection() async {
    try {
      final configuration = <String, dynamic>{
        'iceServers': [
          {
            'urls': [
              'stun:stun1.l.google.com:19302',
              'stun:stun2.l.google.com:19302',
            ],
          },
        ],
        'sdpSemantics': 'unified-plan',
        'enableDtlsSrtp': true,
        'iceTransportPolicy': 'all',
      };

      final pc = await createPeerConnection(configuration);
      _peerConnection = pc;

      // Add local stream tracks to peer connection
      if (_localStream != null) {
        final tracks = _localStream!.getTracks();
        if (tracks.isEmpty) {
          throw Exception('No local tracks available');
        }
        for (final track in tracks) {
          await pc.addTrack(track, _localStream!);
        }
      } else {
        throw Exception('Local stream not initialized');
      }

      // Handle connection state changes
      pc.onConnectionState = (RTCPeerConnectionState state) {
        print('Connection state changed: $state');
        if (state == RTCPeerConnectionState.RTCPeerConnectionStateFailed) {
          setState(() {
            _errorMessage = 'Connection failed. Please try again.';
          });
        }
      };

      // Handle remote stream
      pc.onTrack = (RTCTrackEvent event) {
        if (event.streams.isNotEmpty) {
          print('Received remote stream');
          _remoteRenderer.srcObject = event.streams[0];
          setState(() {});
        }
      };

      // Handle ICE candidates
      pc.onIceCandidate = (RTCIceCandidate candidate) {
        print('Generated ICE candidate: ${candidate.candidate}');
        _signaling.sendIceCandidate(
          'doctor_${widget.appointment.id}',
          candidate,
        );
      };

      // Handle ICE connection state
      pc.onIceConnectionState = (RTCIceConnectionState state) {
        print('ICE connection state: $state');
        if (state == RTCIceConnectionState.RTCIceConnectionStateFailed) {
          setState(() {
            _errorMessage =
                'Network connection failed. Please check your internet connection.';
          });
        }
      };
    } catch (e) {
      print('Error creating peer connection: $e');
      setState(() {
        _errorMessage = 'Failed to setup video call: $e';
      });
      rethrow;
    }
  }

  Future<void> _createOffer() async {
    final pc = _peerConnection;
    if (pc == null) return;

    try {
      final offer = await pc.createOffer();
      await pc.setLocalDescription(offer);
      _signaling.sendOffer(
        'doctor_${widget.appointment.id}', // You should use actual doctor ID
        offer,
      );
    } catch (e) {
      print('Error creating offer: $e');
    }
  }

  Future<void> _handleSignalingMessage(SignalingMessage message) async {
    if (message.senderId == 'patient_${widget.appointment.id}') {
      return; // Ignore own messages
    }

    final pc = _peerConnection;
    if (pc == null) return;

    switch (message.type) {
      case SignalingMessageType.offer:
        try {
          await pc.setRemoteDescription(
            RTCSessionDescription(message.data['sdp'], message.data['type']),
          );
          final answer = await pc.createAnswer();
          await pc.setLocalDescription(answer);
          _signaling.sendAnswer(message.senderId, answer);
        } catch (e) {
          print('Error handling offer: $e');
        }
        break;

      case SignalingMessageType.answer:
        try {
          await pc.setRemoteDescription(
            RTCSessionDescription(message.data['sdp'], message.data['type']),
          );
        } catch (e) {
          print('Error handling answer: $e');
        }
        break;

      case SignalingMessageType.iceCandidate:
        try {
          await pc.addCandidate(
            RTCIceCandidate(
              message.data['candidate'],
              message.data['sdpMid'],
              message.data['sdpMLineIndex'],
            ),
          );
        } catch (e) {
          print('Error handling ICE candidate: $e');
        }
        break;

      case SignalingMessageType.hangup:
        _endCall();
        break;
    }
  }

  void _toggleCamera() {
    if (_localStream != null) {
      final videoTrack = _localStream!.getVideoTracks().firstWhere(
        (track) => track.kind == 'video',
      );
      setState(() {
        _isCameraOn = !_isCameraOn;
        videoTrack.enabled = _isCameraOn;
      });
    }
  }

  void _toggleMicrophone() {
    if (_localStream != null) {
      final audioTrack = _localStream!.getAudioTracks().firstWhere(
        (track) => track.kind == 'audio',
      );
      setState(() {
        _isMicOn = !_isMicOn;
        audioTrack.enabled = _isMicOn;
      });
    }
  }

  Future<void> _endCall() async {
    _signaling.sendHangup('doctor_${widget.appointment.id}');
    _signaling.close();
    await _localStream?.dispose();
    await _peerConnection?.close();
    await _localRenderer.dispose();
    await _remoteRenderer.dispose();
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _endCall();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const SizedBox(),
        title: Text(
          'Call with ${widget.appointment.doctorName}',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_end, color: Colors.red),
            onPressed: _endCall,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main content
          if (_errorMessage != null)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _errorMessage = null;
                      });
                      _initializeCallSetup();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          else if (!_isCallInitialized)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'Initializing call...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            )
          else if (_remoteRenderer.srcObject != null)
            RTCVideoView(
              _remoteRenderer,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            )
          else
            const Center(
              child: Text(
                'Waiting for doctor to join...',
                style: TextStyle(color: Colors.white),
              ),
            ),

          // Local video (picture in picture)
          Positioned(
            right: 16,
            top: 16,
            width: 100,
            height: 150,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _localRenderer.srcObject != null
                    ? RTCVideoView(
                        _localRenderer,
                        mirror: true,
                        objectFit:
                            RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),

          // Controls
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: 'mic',
                  onPressed: _toggleMicrophone,
                  backgroundColor: _isMicOn ? Colors.white : Colors.grey,
                  child: Icon(
                    _isMicOn ? Icons.mic : Icons.mic_off,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  heroTag: 'camera',
                  onPressed: _toggleCamera,
                  backgroundColor: _isCameraOn ? Colors.white : Colors.grey,
                  child: Icon(
                    _isCameraOn ? Icons.videocam : Icons.videocam_off,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  heroTag: 'end',
                  onPressed: _endCall,
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.call_end),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
