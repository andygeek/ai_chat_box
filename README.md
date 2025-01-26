# AI Chat Box

A customizable chat widget for Flutter applications that supports AI-like conversations via dynamic callbacks. Perfect for integrating with AI APIs, chatbots, or other dynamic chat systems.

## Features

- Customizable UI for user and bot messages.
- Supports streaming responses for real-time updates.
- Easy to integrate with any API or service.

## Getting Started

1. Add the dependency:

```
flutter pub add ai_chat_box
```

2. Import the package:

```dart
import 'package:ai_chat_box/ai_chat_box.dart';
```

3. Use the widget:

```dart
Stream<String> _mockChatCallback(List<Map<String, String>> messages) async* {
  await Future.delayed(const Duration(seconds: 1));
  final lastUserMessage = messages.last['user'] ?? '';
  yield "Response for: $lastUserMessage";
}

AiChatBox(
  initialMessages: [
    {"bot": "Hello! How can I assist you?"},
  ],
  onSend: _mockChatCallback,
  title: 'Chat Demo',
);
```

## Example App

Check the `example` directory for a complete example.
