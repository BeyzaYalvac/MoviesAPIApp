
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  List<types.Message> _messages = [];
  final _user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
  );

  final _gemini = const types.User(id: 'Gemini_id_1');

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }


  String prompt_input = '';
  String responseText = "";

  Future<void> _handleSendPressed(types.PartialText message) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: 'AIzaSyCcJx0CW5CEN5IViTB3nyI2Imbn_2cgX20',
    );
    final prompt =
        'lütfen bana ${message.text}\'e benzeyen filmleri veya dizileri liste şeklinde ver!';
    try {


      final response = await model.generateContent([Content.text(prompt)]);
      print(response.text);
      setState(() {
        responseText = response.text!;
      });

      final UserInputMessage = types.TextMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: DateTime.now().toString(),
        text: message.text,
      );

      _addMessage(UserInputMessage);

      final BotOutputMessage = types.TextMessage(
        author: _gemini,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: DateTime.now().toString(),
        text: response.text!,
      );

      _addMessage(BotOutputMessage);
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> showInfoMessage() async {
    final _infoMessage = const types.User(id: 'info_Message_id');
    final infoMessage = types.TextMessage(
      author: _infoMessage,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: DateTime.now().toString(),
      text:
      'Merhaba! 🎬 \n Sana film veya dizi önerilerinde bulunabilirim! Favori filmini ya da dizini benimle paylaş!'
          'ben de senin zevkine uygun benzer yapımları sana liste halinde sunayım.'
          '\nÖrneğin: Inception filmini yazarsan, ona benzer filmleri sana önereceğim. 😊'
          '\nHazırsan, sevdiğin bir film ya da dizi adıyla başlayabilirsin!'
          '\n----------------------------------------------'
          'Hello! 🎬  \n I can recommend movies or series for you! Just tell me your favorite movie or series,'
          'and I\'ll suggest similar titles in a list.'
          '\nFor example, if you type "Inception" I\'ll recommend movies that are similar to it. 😊'
          '\nWhenever you\'re ready, start by sharing the name of a movie or series you like!',
    );

    _addMessage(infoMessage);
  }

  @override
  void initState() {
    showInfoMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.red,
        appBar: AppBar(
          title: Text('Ask AI'),
          centerTitle: true,
          toolbarHeight: 80.0,
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(32.0)),
          backgroundColor: Colors.red,
        ),
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Chat(
    messages: _messages,
    onSendPressed: _handleSendPressed,
    user: _user,
    theme: DefaultChatTheme(backgroundColor: Colors.transparent),
    ),
        ),


    );
  }
}
