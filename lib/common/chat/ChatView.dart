import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qcu/services/AuthService.dart';
import 'package:qcu/services/ChatService.dart';
import 'package:qcu/services/FirestoreService.dart';

import '../../features/ViewModels/UserViewModel.dart';
import 'MessageModel.dart';

class ChatView extends ConsumerStatefulWidget {
  const ChatView({
    required this.buyer,
    required this.seller,
    Key? key,
  }) : super(key: key);

  final buyer, seller;

  @override
  ConsumerState createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  var key = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();
  final List<Message> _messages = [
  //  Message(id: "", name: "Edison", message: "test", time: DateTime.now()),
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


  void _handleSubmitted(String text, String name) {
    _textController.clear();
    ChatService().sendMessage(
      Message(id: AuthService().getID(), name: name, message: text, time: DateTime.now()),
      widget.buyer,
      widget.seller,
    );
    setState(() {
      /*_messages.insert(
        0,
        Message(id: AuthService().getID(), name: "Edison", message: text, time: DateTime.now()),
      );*/
    });
  }

  Widget _buildTextComposer(name) {
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
                //onFieldSubmitted: _handleSubmitted(_textController.text, name),
                decoration:
                const InputDecoration.collapsed(hintText: 'Send a message'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: (){
                if (key.currentState!.validate()) {
                  _handleSubmitted(_textController.text, name);
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

    var user = ref.watch(userProvider);

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
              child: StreamBuilder<QuerySnapshot>(
                stream: ChatService().chatStream(widget.buyer, widget.seller),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    _messages.clear();
                    for (var i = 0; i < snapshot.data!.docs.length; i++) {
                      _messages.add(Message(
                        id: snapshot.data!.docs[i].get("id"),
                        name: snapshot.data!.docs[i].get("name"),
                        message: snapshot.data!.docs[i].get("message"),
                        time: snapshot.data!.docs[i].get("time").toDate(),
                      ));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      reverse: true,
                      itemCount: _messages.length,
                      itemBuilder: (_, int index) => _buildMessage(_messages[index]),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              ),
            ),
            const Divider(height: 1.0),
            user.when(
              data: (data){
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                  ),
                  child: _buildTextComposer(
                      data.data()!["Name"]
                  ),
                );
              },
              error: (error, stack){
                return Center(
                  child: Text(error.toString()),
                );
              },
              loading: (){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(Message message) {
    print(message.id);
    print(AuthService().getID());
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: message.id != AuthService().getID() ? Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              child: Text(
                message.name[0]
              ),
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
            child: CircleAvatar(
              child: Text(
                  message.name[0]
              ),
            ),
          ),
        ],
      ),
    );
  }
}

