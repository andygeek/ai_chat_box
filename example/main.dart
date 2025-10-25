import 'package:flutter/material.dart';
import 'package:ai_chat_box/ai_chat_box.dart';

void main() {
  runApp(const MyApp());
}

Stream<String> _mockChatCallback(List<Map<String, String>> messages) async* {
  await Future.delayed(const Duration(seconds: 1));
  final lastUserMessage = messages.last['user'] ?? '';
  yield lastUserMessage;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Chat Box Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('AI Chat Box Example'),
        ),
        body: AiChatBox(
          initialMessages: [
            {"bot": "Hi! I'm a bot. Ask me anything!"},
          ],
          onSend: _mockChatCallback,
        ),
      ),
    );
  }
}
