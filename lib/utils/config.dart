import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static Future<void> load() async {
    await dotenv.load(fileName: 'assets/.env');
  }

  static String get huggingFaceApiKey =>
      dotenv.env['HUGGINGFACE_API_KEY'] ?? '';
}
