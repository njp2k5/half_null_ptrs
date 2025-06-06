import 'package:flutter/material.dart';
import '../utils/config.dart'; // Make sure this contains huggingFaceApiKey
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, String>> messages = [];
  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  Future<void> sendMessage(String text) async {
    setState(() {
      messages.add({"role": "user", "content": text});
      isLoading = true;
    });

    try {
      final prompt = buildPrompt();

      final response = await http.post(
        Uri.parse(
          'https://api-inference.huggingface.co/models/HuggingFaceH4/zephyr-7b-beta',
        ),
        headers: {
          'Authorization':
              'Bearer ${AppConfig.huggingFaceApiKey}', // <- use your Hugging Face key here
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "inputs": prompt + "\nAssistant:",
          "parameters": {
            "max_new_tokens": 200,
            "temperature": 0.7,
            "return_full_text": false,
          },
        }),
      );

      final statusCode = response.statusCode;
      final data = jsonDecode(response.body);

      print("Status code: $statusCode");
      print("Response body: ${response.body}");

      if (statusCode == 200 &&
          data is List &&
          data.isNotEmpty &&
          data[0]['generated_text'] != null) {
        final reply = data[0]['generated_text'].trim();
        setState(() {
          messages.add({"role": "assistant", "content": reply});
        });
      } else {
        setState(() {
          messages.add({
            "role": "assistant",
            "content":
                "Sorry, I didn't receive a valid response. Full response: ${response.body}",
          });
        });
      }
    } catch (e) {
      setState(() {
        messages.add({
          "role": "assistant",
          "content": "Error occurred: ${e.toString()}",
        });
      });
    }

    setState(() => isLoading = false);

    await Future.delayed(const Duration(milliseconds: 300));
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  String buildPrompt() {
    final buffer = StringBuffer();
    for (var msg in messages) {
      buffer.write(
        "${msg['role'] == 'user' ? 'User' : 'Assistant'}: ${msg['content']}\n",
      );
    }
    return buffer.toString();
  }

  @override
  void dispose() {
    controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Assistant')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUser = message['role'] == 'user';
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.teal.shade800 : Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Text(
                    message['content'] ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
          if (isLoading) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Ask something...",
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.grey.shade900,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.tealAccent),
                  onPressed: () {
                    final text = controller.text.trim();
                    if (text.isNotEmpty) {
                      sendMessage(text);
                      controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
