import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qcu/services/AuthService.dart';

import 'MessageModel.dart';

class ChatView extends ConsumerStatefulWidget {
  const ChatView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  var key = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();
  final List<Message> _messages = [
    Message(id: "", name: "Edison", message: "test", time: DateTime.now()),
    Message(id: "", name: "Jack", message: "test1", time: DateTime.now()),
    Message(id: "", name: "Jack", message: "test2", time: DateTime.now()),
    Message(id: "", name: "Edison", message: "test3", time: DateTime.now()),
    Message(id: "", name: "Jack", message: "test4", time: DateTime.now()),
    Message(id: "", name: "Edison", message: "test", time: DateTime.now()),
    Message(id: "", name: "Jack", message: "test1", time: DateTime.now()),
    Message(id: "", name: "Jack", message: "test2", time: DateTime.now()),
    Message(id: "", name: "Edison", message: "test3", time: DateTime.now()),
    Message(id: "", name: "Jack", message: "test4", time: DateTime.now()),
    Message(id: "", name: "Edison", message: "test", time: DateTime.now()),
    Message(id: "", name: "Jack", message: "test1", time: DateTime.now()),
    Message(id: "", name: "Jack", message: "test2", time: DateTime.now()),
    Message(id: "", name: "Edison", message: "test3", time: DateTime.now()),
    Message(id: "", name: "Jack", message: "test4", time: DateTime.now()),
  ];

  List<String> bannedWords = [
    "Account",
    "Accounts",
    "Accnt",
    "Contact",
    "Number",
    "Mail",
    "Lipat",
    "Platform",
    "Facebook",
    "FB",
    "Messenger",
    "Instagram",
    "Insta",
    "Twitter",
    "Telegram",
    "Tg",
    "Viber",
    "Call",
    "Tawag",
    "Text",
  ];


  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _messages.insert(
        0,
        Message(id: "", name: "Edison", message: text, time: DateTime.now()),
      );
    });
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Form(
        key: key,
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextFormField(
                autovalidateMode: AutovalidateMode.always,
                validator: (value) {

                  for (var i = 0; i < bannedWords.length; i++) {
                    if (value!.toLowerCase().contains(bannedWords[i].toLowerCase())) {
                      return "You are using a banned word";
                    }
                  }
                  return null;
                },
                controller: _textController,
                onFieldSubmitted: _handleSubmitted,
                decoration:
                const InputDecoration.collapsed(hintText: 'Send a message'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: (){
                if (key.currentState!.validate()) {
                  _handleSubmitted(_textController.text);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 40, right: 40, top: 40),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage("assets/images/QCUlogo.jpg"),
                ),
                const SizedBox(width: 20,),
                Text(
                  "Jack Shop",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (_, int index) => _buildMessage(_messages[index]),
              ),
            ),
            const Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: _buildTextComposer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(Message message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: message.name != "Edison" ? Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: const CircleAvatar(
              child: Text('J'),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                message.name
              ),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: Text(message.message),
              ),
            ],
          ),
        ],
      ) : Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  message.name
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(message.message),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 16.0),
            child: const CircleAvatar(
              child: Text('E'),
            ),
          ),
        ],
      ),
    );
  }
}

