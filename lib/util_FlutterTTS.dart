import 'package:flutter_tts/flutter_tts.dart';

class UtilFlutterTTS {
  static Future speak(
      FlutterTts flutterTTS, String name, String description) async {
    String newVoiceText = "";
    if (name.isNotEmpty) {
      newVoiceText = newVoiceText + name + ". ";
    }
    if (description.isNotEmpty) {
      newVoiceText = newVoiceText + description + ". ";
    }
    if (newVoiceText.isNotEmpty) {
      await flutterTTS.speak(newVoiceText);
    }
  }

  static Future<int> stop(FlutterTts flutterTTS) async {
    int result = await flutterTTS.stop();
    return result;
  }

  static Future<int> pause(FlutterTts flutterTTS) async {
    int result = await flutterTTS.pause();
    return result;
  }
}
