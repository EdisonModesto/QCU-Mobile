import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qcu/common/chat/MessageModel.dart';

class ChatService{

  Stream<QuerySnapshot<Map<String, dynamic>>> chatStream (buyer, seller){
    return FirebaseFirestore.instance.collection("Chats").doc("$buyer-$seller").collection("messages").orderBy("time", descending: true).snapshots();
  }

  void sendMessage(Message message, buyer, seller){

    var doc = FirebaseFirestore.instance.collection("Chats").doc("$buyer-$seller");

    doc.set({
        "buyer": buyer,
        "seller": seller,
      });

    doc.collection("messages").add({
      "id": message.id,
      "name": message.name,
      "message": message.message,
      "time": message.time,
    });
  }

}