import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{
  var instance = FirebaseFirestore.instance;

  void createUser(id){
    instance.collection("Users").doc(id).set({
      "Name" : "No name",
      "Address" : "",
      "Type" : "Buyer",
      "Orders" : [],
    });
  }


}