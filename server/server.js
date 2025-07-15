require('dotenv').config();
const WebSocket = require('ws');
const http = require('http');
const url = require('url');

const port = process.env.PORT || 8080;

// Create HTTP server
const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('WebSocket server is running\n');
});

// Create WebSocket server
const wss = new WebSocket.Server({ server });

// Store connected clients
const clients = new Map();

// Store active calls
const activeCalls = new Map();

class Client {
  constructor(ws, userId, callId) {
    this.ws = ws;
    this.userId = userId;
    this.callId = callId;
    this.isAlive = true;
  }
}

// Heartbeat to keep connections alive
function heartbeat() {
  this.isAlive = true;
}

// Handle WebSocket connections
wss.on('connection', (ws, req) => {
  // Parse connection URL parameters
  const parameters = url.parse(req.url, true).query;
  const { userId, callId } = parameters;

  if (!userId || !callId) {
    console.log('Connection rejected: Missing userId or callId');
    ws.close();
    return;
  }

  // Create new client
  const client = new Client(ws, userId, callId);
  clients.set(userId, client);

  // Add call to active calls
  if (!activeCalls.has(callId)) {
    activeCalls.set(callId, new Set());
  }
  activeCalls.get(callId).add(userId);

  console.log(`Client connected - UserId: ${userId}, CallId: ${callId}`);
  console.log(`Active calls: ${activeCalls.size}, Total clients: ${clients.size}`);

  // Set up heartbeat
  ws.isAlive = true;
  ws.on('pong', heartbeat);

  // Handle incoming messages
  ws.on('message', (message) => {
    try {
      const data = JSON.parse(message);
      const { type, receiverId, senderId } = data;

      // Validate message
      if (!type || !receiverId || !senderId) {
        console.log('Invalid message format:', data);
        return;
      }

      // Get target client
      const targetClient = clients.get(receiverId);
      
      if (targetClient && targetClient.callId === callId) {
        // Forward message to target client
        targetClient.ws.send(JSON.stringify(data));
        console.log(`Message forwarded: ${type} from ${senderId} to ${receiverId}`);
      } else {
        console.log(`Target client not found or not in same call: ${receiverId}`);
      }
    } catch (error) {
      console.error('Error handling message:', error);
    }
  });

  // Handle client disconnect
  ws.on('close', () => {
    // Remove client from active calls
    const callParticipants = activeCalls.get(callId);
    if (callParticipants) {
      callParticipants.delete(userId);
      if (callParticipants.size === 0) {
        activeCalls.delete(callId);
      }
    }

    // Remove client from clients map
    clients.delete(userId);

    // Notify other participants in the call
    callParticipants?.forEach((participantId) => {
      const participant = clients.get(participantId);
      if (participant) {
        participant.ws.send(JSON.stringify({
          type: 'hangup',
          senderId: userId,
          receiverId: participantId,
          data: null
        }));
      }
    });

    console.log(`Client disconnected - UserId: ${userId}, CallId: ${callId}`);
    console.log(`Active calls: ${activeCalls.size}, Total clients: ${clients.size}`);
  });

  // Send initial connection success message
  ws.send(JSON.stringify({
    type: 'connection_success',
    senderId: 'server',
    receiverId: userId,
    data: {
      message: 'Successfully connected to signaling server',
      timestamp: new Date().toISOString()
    }
  }));
});

// Connection cleanup interval
const interval = setInterval(() => {
  wss.clients.forEach((ws) => {
    if (ws.isAlive === false) {
      return ws.terminate();
    }
    ws.isAlive = false;
    ws.ping();
  });
}, 30000);

wss.on('close', () => {
  clearInterval(interval);
});

// Start server
server.listen(port, () => {
  console.log(`WebSocket server is running on port ${port}`);
});
