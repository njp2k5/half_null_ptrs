import 'package:flutter/material.dart';
import 'utils/config.dart';
import 'pages/home_page.dart';
import 'pages/task_page.dart';
import 'pages/music_page.dart';
import 'pages/chat_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.load(); // Loads env from assets/config.en
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focus App',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/tasks': (context) => const TaskPage(),
        '/music': (context) => const MusicPage(),
        '/chat': (context) => const ChatPage(),
      },
    );
  }
}
