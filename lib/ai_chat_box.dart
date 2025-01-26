import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

/// Callback for handling message sending.
/// - [messages] is the complete list of accumulated messages so far.
///   Each message is a Map that contains "user" for user messages
///   and "bot" (or any other key) for bot responses.
/// - Returns a [Stream<String>] to emit partial responses
///   (if your API/service supports it). Otherwise, you can use
///   [Future<String>] for a single complete response.
typedef ChatResponseStreamCallback = Stream<String> Function(
  List<Map<String, String>> messages,
);

/// A generic chat widget designed for flexible use cases, such as integrating
/// with AI APIs, chatbots, or other dynamic conversation systems.
class AiChatBox extends StatefulWidget {
  /// Initial messages to prefill the chat.
  /// For example, you can use this to provide context at index [0]
  /// and hide it if needed using [hiddenMessagesCount].
  final List<Map<String, String>> initialMessages;

  /// Function to handle message sending and response retrieval.
  /// This function is called every time the user sends a message.
  final ChatResponseStreamCallback onSend;

  /// The number of initial messages to hide from the list view.
  /// Defaults to 0. If the first message is context, you can
  /// pass it in [initialMessages] and set this to 1.
  final int hiddenMessagesCount;

  /// Title to be displayed in the AppBar.
  final String title;

  const AiChatBox({
    super.key,
    required this.initialMessages,
    required this.onSend,
    this.hiddenMessagesCount = 0,
    this.title = 'Chat',
  });

  @override
  State<AiChatBox> createState() => _AiChatBoxState();
}

class _AiChatBoxState extends State<AiChatBox> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  /// List to hold both user and bot messages.
  late List<Map<String, String>> _messages;

  @override
  void initState() {
    super.initState();
    // Initialize the message list with the provided initial messages.
    _messages = List.from(widget.initialMessages);
  }

  /// Handles sending the user's message and listens for responses.
  void _sendMessage(String userMessage) {
    final trimmedMessage = userMessage.trim();
    if (trimmedMessage.isEmpty) return;

    // Add the user's message to the list.
    setState(() {
      _messages.add({"user": trimmedMessage});
    });
    _controller.clear();
    _scrollToBottom();

    // Add a placeholder for the bot's response.
    setState(() {
      _messages.add({"bot": ""});
    });
    final botIndex = _messages.length - 1; // Index of the bot's placeholder message

    // Listen to the callback to retrieve the bot's response.
    widget.onSend(_messages).listen(
      (partialResponse) {
        setState(() {
          _messages[botIndex]["bot"] = partialResponse;
        });
        _scrollToBottom();
      },
      onError: (error) {
        setState(() {
          _messages[botIndex]["bot"] =
              "An error occurred while fetching the response: $error";
        });
        _scrollToBottom();
      },
    );
  }

  /// Animates the scroll to the bottom of the message list
  /// so the user can see the most recent messages.
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          /// Message list view
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              // Adjust the item count to exclude hidden messages
              itemCount: _messages.length - widget.hiddenMessagesCount,
              itemBuilder: (context, index) {
                // Adjust the index to skip hidden messages
                final realIndex = index + widget.hiddenMessagesCount;
                final message = _messages[realIndex];

                // Determine if the message is from the user or bot
                final isUser = message.containsKey("user");
                final textToShow = isUser ? message["user"]! : message["bot"]!;

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GptMarkdown(
                      textToShow,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),

          /// Input box + send button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                /// Input field
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                /// Send button
                ElevatedButton(
                  onPressed: () => _sendMessage(_controller.text),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                    backgroundColor: Colors.black,
                  ),
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
