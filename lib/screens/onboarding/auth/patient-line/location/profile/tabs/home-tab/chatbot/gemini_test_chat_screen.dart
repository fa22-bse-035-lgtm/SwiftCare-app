import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:swiftcare/services/api_service.dart';

class GeminiTestChatScreen extends StatefulWidget {
  const GeminiTestChatScreen({super.key});

  @override
  State<GeminiTestChatScreen> createState() => _GeminiTestChatScreenState();
}

class _GeminiTestChatScreenState extends State<GeminiTestChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<_ChatMessage> _messages = [];
  bool _isLoading = false;

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text, true));
      _isLoading = true;
      _controller.clear();
    });

    try {
      final res = await ApiService().request(
        '/chatbot/chat',
        method: 'POST',
        body: {'message': text},
        requiresAuth: true,
      );

      if (res.statusCode == 200) {
        final reply = jsonDecode(res.body)['reply'];
        setState(() {
          _messages.add(_ChatMessage(reply, false));
        });
      } else {
        _addError('Server error: ${res.statusCode}');
      }
    } catch (e) {
      _addError('Connection failed');
    }

    setState(() => _isLoading = false);
  }

  void _addError(String msg) {
    setState(() {
      _messages.add(_ChatMessage(msg, false, isError: true));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gemini Chatbot Test'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _messages[i],
            ),
          ),

          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: CircularProgressIndicator(),
            ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: const InputDecoration(
                        hintText: 'Type a message…',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _isLoading ? null : _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  final bool isError;

  const _ChatMessage(
    this.text,
    this.isUser, {
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isError
        ? Colors.red.shade200
        : isUser
            ? Colors.blue.shade200
            : Colors.grey.shade300;

    final align =
        isUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: align,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(12),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(text),
      ),
    );
  }
}