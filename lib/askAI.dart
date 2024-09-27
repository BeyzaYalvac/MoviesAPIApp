import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  TextEditingController _prompt = TextEditingController();
  String prompt_input = '';
  String responseText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ask AI'),
        centerTitle: true,
        toolbarHeight: 80.0,
          shape: ContinuousRectangleBorder(borderRadius:BorderRadius.circular(32.0)),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Expanded(child: SingleChildScrollView(child: Container(child: Text(responseText)))),
          TextField(
            controller: _prompt,
            onChanged: (String val) {
              setState(() {
                prompt_input = val;
              });
            },
          ),
          OutlinedButton(
              onPressed: () async {
                final model = GenerativeModel(
                  model: 'gemini-1.5-flash',
                  apiKey: 'AIzaSyCcJx0CW5CEN5IViTB3nyI2Imbn_2cgX20',
                );
                final prompt = _prompt.text;

                final response =
                    await model.generateContent([Content.text(prompt)]);
                print(response.text);
                setState(() {
                  responseText = response.text!;
                });
              },
              child: Text('create prompt')),

        ],
      ),
    );
  }
}
