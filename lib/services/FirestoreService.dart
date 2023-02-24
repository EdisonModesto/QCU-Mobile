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

  Future<String> checkUserType(id) async {
    var doc = await instance.collection("Users").doc(id).get();
    if(doc["Type"] == "Buyer") {
      print("Buyer");
      return "Buyer";
    } else if(doc["Type"] == "Seller"){
      print("Seller");
      return "Seller";
    } else if(doc["Type"] == "Admin"){
      print("Admin");
      return "Admin";
    }
    return "Unknown";
  }


}