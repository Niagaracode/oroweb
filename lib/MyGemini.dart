import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_markdown/flutter_markdown.dart';



class MyGemini extends StatefulWidget {
  @override
  _MyGeminiState createState() => _MyGeminiState();
}

class _MyGeminiState extends State<MyGemini> {
  final _promptTextEditController = TextEditingController();
  final List<Map<String, String>> _messages = []; // 채팅 내역을 저장할 리스트

  @override
  void dispose() {
    _promptTextEditController.dispose();
    super.dispose();
  }
  Map<String, Object> generation_config = {
    "temperature": 0.15,
    "top_p": 0.95,
    "top_k": 64,
    "max_output_tokens": 8192,
    "response_mime_type": "text/plain",
  };

  // model = genai.GenerativeModel(
  // model_name="gemini-1.5-flash",
  // generation_config=generation_config,

  // model_name="gemini-1.5-flash",
  // generation_config=generation_config,
  void _sendPrompt() async {
    final model = GenerativeModel(
      generationConfig: GenerationConfig(
        temperature: 0.15,
        topP: 0.95,
        topK: 64,
        maxOutputTokens: 8192,
        responseMimeType: "text/plain",
      ),
      model: 'gemini-pro', apiKey: 'AIzaSyC9dGxg8HPz7xpYWr9_k_IMFXNc11PzYkg',
    ); // Model Settings

    String promptText = _promptTextEditController.text;
    if (promptText.isNotEmpty) {
      setState(() {
        _messages.add({'user': promptText});
      });
      final content = [Content.text(promptText)];
      try {
        final response = await model.generateContent(content);
        setState(() {
          _messages
              .add({'gemini': response.text.toString()}); // Gemini의 응답을 리스트에 추가
        });
      } catch (e) {
        print('Exception: $e');
        setState(() {
          _messages.add({'gemini': 'Error: $e'}); // 오류 메시지를 리스트에 추가
        });
      }
      _promptTextEditController.clear(); // 입력 필드를 초기화
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("ORO Gemini"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUser = message.containsKey('user');
                  return Align(
                    alignment:
                    isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue[100] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: isUser
                          ? Text(
                        message['user']!,
                        style: TextStyle(fontSize: 16),
                      )
                          : MarkdownBody(
                        data: message['gemini']!,
                        styleSheet: MarkdownStyleSheet.fromTheme(
                          Theme.of(context),
                        ).copyWith(
                          p: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promptTextEditController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      labelText: "Enter here ",
                    ),
                    onChanged: (text) {},
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _sendPrompt,
                  child: Text("Send"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
