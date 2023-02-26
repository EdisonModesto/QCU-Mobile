import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qcu/services/CloudService.dart';

class FirestoreService{
  var instance = FirebaseFirestore.instance;

  void createUser(id){
    instance.collection("Users").doc(id).set({
      "Name" : "No name",
      "Address" : "",
      "Type" : "Buyer",
      "Orders" : [],
      "Cart": [],
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

  Future<void> addItem(name, price, description, image, seller, category, stock) async {
    var ref = instance.collection("Items").doc();
    ref.set({
      "Name" : name,
      "Price" : price,
      "Description" : description,
      "Image" : image,
      "Seller" : seller,
      "Category" : category,
      "Stock" : stock,
    });
  }

  void deleteItem(id){
    instance.collection("Items").doc(id).delete();
  }

  Future<void> addToCart(id, item) async {
    var ref = await instance.collection("Users").doc(id).get();
    List<dynamic> cart = ref.data()!["Cart"] as List<dynamic>;
    if(cart.contains(item)){
      Fluttertoast.showToast(msg: "Item already in cart");
    }
    else{
      instance.collection("Users").doc(id).update({
        "Cart" : FieldValue.arrayUnion([item])
      });
     Fluttertoast.showToast(msg: "Item added to cart");
    }
  }

}