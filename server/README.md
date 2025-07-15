# Video Call Signaling Server

This is a WebSocket server that handles signaling for WebRTC video calls in the Hayah Health App.

## Features

- WebSocket-based signaling
- Support for multiple simultaneous calls
- Heartbeat mechanism to maintain connections
- Automatic cleanup of disconnected clients
- Environment-based configuration

## Setup

1. Install dependencies:
   ```bash
   npm install
   ```

2. Configure environment variables:
   - Copy `.env.example` to `.env`
   - Update the values as needed

3. Start the server:
   ```bash
   # Development mode (with auto-reload)
   npm run dev

   # Production mode
   npm start
   ```

## WebSocket Protocol

### Connection

Connect to the WebSocket server with required query parameters:
```
ws://localhost:8080?userId=user123&callId=call123
```

### Message Format

All messages should follow this format:
```json
{
  "type": "offer|answer|iceCandidate|hangup",
  "senderId": "user123",
  "receiverId": "user456",
  "data": {
    // Message specific data
  }
}
