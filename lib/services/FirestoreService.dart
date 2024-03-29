import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qcu/services/CloudService.dart';

import 'AuthService.dart';

class FirestoreService{
  var instance = FirebaseFirestore.instance;

  void createUser(id, name, address){
    instance.collection("Users").doc(id).set({
      "Name" : name,
      "Image": "",
      "Contact" : "",
      "Address" : address,
      "Type" : "Buyer",
      "Orders" : [],
      "Cart": [],
    });
  }

  void updateUser(name, address, image, contact){
    FirebaseFirestore.instance.collection("Users").doc(AuthService().getID()).update({
      "Name": name,
      "Image": image,
      "Contact": contact,
      "Address": address,
    });
  }

  void convertToSeller(id){
    FirebaseFirestore.instance.collection("Users").doc(id).update({
      "Type": "Seller",
    });
  }

  void convertToBuyer(id){
    FirebaseFirestore.instance.collection("Users").doc(id).update({
      "Type": "Buyer",
    });
  }

  Future<void> addFeature(id) async {
    final DocumentReference docRef = FirebaseFirestore.instance.collection("Featured").doc(id);
    final DocumentSnapshot docSnap = await docRef.get();
    bool exist = docSnap.exists;

    if(!exist){
      FirebaseFirestore.instance.collection("Featured").doc(id).set({
        "ID": id,
      });
      Fluttertoast.showToast(msg: "Seller is now featured");
    } else {
      FirebaseFirestore.instance.collection("Featured").doc(id).delete();
      Fluttertoast.showToast(msg: "Seller removed from featured");
    }
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

  Future<void> updateItem(id, name, price, description, image, seller, category, stock) async {
    FirebaseFirestore.instance.collection("Items").doc(id).update({
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

  Future<void> addToCart(id, item, quantity, sellerID) async {
    var ref = await instance.collection("Users").doc(id).get();
    List<dynamic> cart = ref.data()!["Cart"] as List<dynamic>;
    if(cart.contains(item)){
      Fluttertoast.showToast(msg: "Item already in cart");
    }
    else{
      instance.collection("Users").doc(id).update({
        "Cart" : FieldValue.arrayUnion(["$item,$quantity,$sellerID"]),
      });
     Fluttertoast.showToast(msg: "Item added to cart");
    }
  }

  void updateCartQuantity(id, quantity, old){
    FirebaseFirestore.instance.collection("Users").doc(AuthService().getID()).update({
      "Cart": FieldValue.arrayRemove([old])
    });
    if(quantity == 0){

    } else {
      FirebaseFirestore.instance.collection("Users").doc(AuthService().getID()).update({
        "Cart": FieldValue.arrayUnion(["$id,$quantity"])
      });
    }
  }

  Future<void> createOrder(items, name, contact, address, delivery, mop, sellerID, shippingFee) async {

    FirebaseFirestore.instance.collection("Users").doc(AuthService().getID()).update({
      "Cart": [],
    });

    FirebaseFirestore.instance.collection("Orders").doc().set({
      "User": AuthService().getID(),
      "Seller": sellerID,
      "Items": items,
      "Status": "0",
      "Name": name,
      "Contact": contact,
      "Address": address,
      "Delivery": delivery,
      "MOP": mop,
      "DatePurchase": DateTime.now().toString(),
      "DateDelivered": "No Data",
      "ShippingFee": shippingFee,
    });

    for(var item in items){
      var itemInstance = FirebaseFirestore.instance.collection("Items").doc(item.toString().split(",")[0]);
      var itemData = await itemInstance.get();
      var itemStocks = itemData.data()!["Stocks"];
      FirebaseFirestore.instance.collection("Items").doc(item.toString().split(",")[0]).update({
        "Stocks" : (int.parse(itemStocks) - int.parse(item.toString().split(",")[1])).toString(),
      });
    }

    addNotification(AuthService().getID(), "Order has been placed", DateTime.now(), "Track your order at the Orders tab");

  }

  void updateOrderStatus(id, status, user){
    FirebaseFirestore.instance.collection("Orders").doc(id).update({
      "Status": status,
    });
    addNotification(user, "Order status has been updated", DateTime.now(), "Check your order at the Orders tab");
  }

  void cancelOrder(id, user){
    FirebaseFirestore.instance.collection("Orders").doc(id).delete();
    addNotification(user, "Order has been cancelled", DateTime.now(), "Check your order at the Orders tab");

  }

  void addNotification(id, name, date, message){
    FirebaseFirestore.instance.collection("Users").doc(id).collection("Notifications").doc().set({
      "Name" : name,
      "Date" : date,
      "Message" : message,
    });
  }

}