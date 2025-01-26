import 'package:flutter/material.dart';
import 'package:ai_chat_box/ai_chat_box.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Chat Box Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ExamplePage(),
    );
  }
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  Stream<String> _mockChatCallback(List<Map<String, String>> messages) async* {
    // Simula un retraso para obtener una respuesta
    await Future.delayed(const Duration(seconds: 1));
    final lastUserMessage = messages.last['user'] ?? '';
    yield "Respuesta para: $lastUserMessage";
  }

  @override
  Widget build(BuildContext context) {
    return AiChatBox(
      initialMessages: [
        {"bot": "¡Hola! Soy tu asistente de chat AI."},
      ],
      onSend: _mockChatCallback,
      title: 'Chat AI Demo',
    );
  }
}
