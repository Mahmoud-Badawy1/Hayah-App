import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

enum SignalingMessageType { offer, answer, iceCandidate, hangup }

class SignalingMessage {
  final SignalingMessageType type;
  final String senderId;
  final String receiverId;
  final dynamic data;

  SignalingMessage({
    required this.type,
    required this.senderId,
    required this.receiverId,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'senderId': senderId,
      'receiverId': receiverId,
      'data': data,
    };
  }

  factory SignalingMessage.fromJson(Map<String, dynamic> json) {
    return SignalingMessage(
      type: SignalingMessageType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      data: json['data'],
    );
  }
}

class SignalingService {
  WebSocketChannel? _channel;
  Function(SignalingMessage)? onMessage;
  final String userId;
  final String callId;
  final String serverUrl;

  SignalingService({
    required this.userId,
    required this.callId,
    required this.serverUrl,
  });

  Future<void> connect() async {
    try {
      final uri = Uri.parse('$serverUrl?userId=$userId&callId=$callId');
      _channel = WebSocketChannel.connect(uri);

      _channel?.stream.listen(
        (message) {
          final data = jsonDecode(message);
          final signalingMessage = SignalingMessage.fromJson(data);
          onMessage?.call(signalingMessage);
        },
        onError: (error) {
          print('WebSocket error: $error');
        },
        onDone: () {
          print('WebSocket connection closed');
        },
      );
    } catch (e) {
      print('WebSocket connection failed: $e');
      rethrow;
    }
  }

  void sendOffer(String receiverId, RTCSessionDescription offer) {
    _sendMessage(
      SignalingMessage(
        type: SignalingMessageType.offer,
        senderId: userId,
        receiverId: receiverId,
        data: {'sdp': offer.sdp, 'type': offer.type},
      ),
    );
  }

  void sendAnswer(String receiverId, RTCSessionDescription answer) {
    _sendMessage(
      SignalingMessage(
        type: SignalingMessageType.answer,
        senderId: userId,
        receiverId: receiverId,
        data: {'sdp': answer.sdp, 'type': answer.type},
      ),
    );
  }

  void sendIceCandidate(String receiverId, RTCIceCandidate candidate) {
    _sendMessage(
      SignalingMessage(
        type: SignalingMessageType.iceCandidate,
        senderId: userId,
        receiverId: receiverId,
        data: {
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
        },
      ),
    );
  }

  void sendHangup(String receiverId) {
    _sendMessage(
      SignalingMessage(
        type: SignalingMessageType.hangup,
        senderId: userId,
        receiverId: receiverId,
        data: null,
      ),
    );
  }

  void _sendMessage(SignalingMessage message) {
    if (_channel != null) {
      _channel!.sink.add(jsonEncode(message.toJson()));
    }
  }

  void close() {
    _channel?.sink.close();
  }
}
