
# Live Streaming App with BLoC & Agora

This repository contains a Flutter Live Streaming Application built with the [BLoC (Business Logic Component)](https://bloclibrary.dev/#/) state management pattern and integrated with [Agora](https://www.agora.io/en/) for real-time video and audio streaming.

## Features

- **Live Video Streaming:** Host and join live video streams using Agora.
- **State Management:** Clean and maintainable codebase using BLoC.
- **Authentication:** Simple login system (customize for auth provider of your choice).
- **Chat Support:** Real-time text chat (optional, extendable).
- **Join/Create Streams:** Easily create or join live sessions.
- **Role-based Streaming:** Separate broadcaster and audience roles.
- **Cross-platform:** Works on Android and iOS.

## Tech Stack

- **Flutter** (UI toolkit)
- **BLoC** (State management)
- **Agora RTC SDK** (Streaming engine)

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Agora.io Account](https://dashboard.agora.io/) and an App ID

### Installation

1. **Clone the repo:**
    ```sh
    git clone https://github.com/heinhtetsan136/live_streaming_app.git
    cd live_streaming_app
    ```

2. **Install dependencies:**
    ```sh
    flutter pub get
    ```

3. **Configure Agora:**
    - Navigate to [`lib/constants/agora_configs.dart`] (create if doesn't exist).
    - Add your Agora App ID:
      ```dart
      const String agoraAppId = "YOUR_AGORA_APP_ID";
      ```

4. **Run the app:**
    ```sh
    flutter run
    ```

## Project Structure

```
lib/
├── bloc/
│   └── ...        # BLoC event, state, and logic files
├── models/
│   └── ...        # Data models
├── screens/
│   └── ...        # UI screens
├── services/
│   └── ...        # Agora service integration, auth, etc.
├── main.dart
```

## Usage

- Enter a channel name to create/join a stream.
- Grant camera/microphone permissions.
- As a broadcaster, your camera will stream live to the channel.
- Audience can join to watch and interact.

## BLoC Example

```dart
// event
abstract class LiveStreamEvent {}
class JoinChannel extends LiveStreamEvent {
  final String channelName;
  JoinChannel(this.channelName);
}

// state
abstract class LiveStreamState {}
class JoinedChannelState extends LiveStreamState {}

// bloc
class LiveStreamBloc extends Bloc<LiveStreamEvent, LiveStreamState> {
  // Agora SDK integration logic goes here
}
```

## Agora Integration

- Uses [`agora_rtc_engine`](https://pub.dev/packages/agora_rtc_engine) Flutter package.
- Handles permission checks, token management, joining/leaving channels, switching roles.

## Contributions

We welcome contributions! Feel free to submit a Pull Request or open an Issue.



---

Made with ❤️ using Flutter, BLoC, and Agora.
