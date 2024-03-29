import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:qcu/services/AuthService.dart';
import 'package:qcu/services/ChatService.dart';
import 'package:qcu/services/FilePickerService.dart';
import 'package:qcu/services/FirestoreService.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final _noScreenshot = NoScreenshot.instance;

  Future<void> disableScreenshot() async {
    await _noScreenshot.screenshotOff();
  }

  @override
  void initState() {
    disableScreenshot();
    super.initState();
  }

  void _handleSubmitted(String text, String name) {
    _textController.clear();
    ChatService().sendMessage(
      Message(id: AuthService().getID(), name: name, message: "TEKSTO~$text", time: DateTime.now()),
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
              icon: const Icon(Icons.image),
              onPressed: () async {
                var url = await FilePickerService().pickImage();
                if(url != null) {
                  ChatService().sendMessage(
                    Message(id: AuthService().getID(),
                        name: name,
                        message: "IMAHE~$url",
                        time: DateTime.now()),
                    widget.buyer,
                    widget.seller,
                  );
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.attach_file),
              onPressed: () async {
                var url = await FilePickerService().pickFile();
                if(url != null) {
                  ChatService().sendMessage(
                    Message(id: AuthService().getID(),
                        name: name,
                        message: "ANYTPE~$url",
                        time: DateTime.now()),
                    widget.buyer,
                    widget.seller,
                  );
                }
              },
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
    var refe = FirebaseFirestore.instance.collection("Users");
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 40, right: 40, top: 40),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage("assets/images/QCUlogo.jpg"),
                ),
                const SizedBox(width: 20,),
                StreamBuilder(
                  stream: refe.doc(widget.buyer == AuthService().getID() ? widget.seller : widget.buyer).snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return Text(
                        snapshot.data!["Name"],
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
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
                message.name[0],
              ),
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  message.name
                ),
                message.message.split("~")[0] == "TEKSTO" ?
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    message.message.split("~")[1],
                    softWrap: true,
                  ),
                ) : message.message.split("~")[0] == "IMAHE" ?
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Image.network(
                    message.message.split("~")[1],
                    width: 200,
                    height: 200,
                  ),
                ) : Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: InkWell(
                    onTap: (){
                      launchUrl(Uri.parse(message.message.split("~")[1]));
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.attach_file),
                        Text(
                          "Attachment",
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),)
                 /*
                  Image.network(
                    message.message.split("~")[1],
                    width: 200,
                    height: 200,
                  ),*/
              ],
            ),
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
                message.message.split("~")[0] == "TEKSTO" ?
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    message.message.split("~")[1],
                    softWrap: true,
                  ),
                ) : message.message.split("~")[0] == "IMAHE" ?
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Image.network(
                    message.message.split("~")[1],
                    width: 200,
                    height: 200,
                  ),
                ) : Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: InkWell(
                    onTap: (){
                      launchUrl(Uri.parse(message.message.split("~")[1]));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(Icons.attach_file),
                        Text(
                          "Attachment",
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 16.0),
            child: CircleAvatar(
              child: Text(
                  message.name[0],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

