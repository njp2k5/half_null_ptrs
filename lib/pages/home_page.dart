import 'package:flutter/material.dart';
import 'dart:math';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Map<String, String>> words = const [
    {
      "word": "Focus",
      "definition": "The act of concentrating on a single task.",
    },
    {
      "word": "Persistence",
      "definition": "Firm or obstinate continuance in a course of action.",
    },
    {
      "word": "Clarity",
      "definition": "The quality of being coherent and intelligible.",
    },
    {
      "word": "Discipline",
      "definition": "Training oneself to obey rules or a code of behavior.",
    },
    {
      "word": "Mindfulness",
      "definition":
          "Maintaining a moment-by-moment awareness of thoughts and feelings.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final randomWord = words[random.nextInt(words.length)];

    return Scaffold(
      appBar: AppBar(title: const Text('Focus App'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Word of the Day',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.tealAccent,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              randomWord['word']!,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              randomWord['definition']!,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/tasks'),
              child: const Text('Task Page'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/music'),
              child: const Text('Music Page'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/chat'),
              child: const Text('Chat Assistant'),
            ),
          ],
        ),
      ),
    );
  }
}
