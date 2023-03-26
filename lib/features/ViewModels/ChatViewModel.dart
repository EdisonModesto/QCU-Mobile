import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

AutoDisposeStreamProvider chatProvider = StreamProvider.autoDispose((ref){
  return FirebaseFirestore.instance.collection("Chats").snapshots();
});