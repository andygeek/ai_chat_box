import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_chat_box/ai_chat_box.dart';

void main() {
  Stream<String> mockOnSend(List<Map<String, String>> messages) async* {
    await Future.delayed(const Duration(milliseconds: 500));
    final lastMessage = messages.last['user'] ?? '';
    yield "Echo: $lastMessage";
  }

  testWidgets('GenericChatWidget hides initial context messages',
      (WidgetTester tester) async {
    final initialMessages = [
      {"bot": "Context: This is a hidden message."},
      {"bot": "Visible message for the user."},
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: AiChatBox(
          initialMessages: initialMessages,
          onSend: mockOnSend,
          hiddenMessagesCount: 1,
          title: 'Hidden Context Test',
        ),
      ),
    );

    expect(find.text('Context: This is a hidden message.'), findsNothing);

    expect(find.text('Visible message for the user.'), findsOneWidget);
  });
}
