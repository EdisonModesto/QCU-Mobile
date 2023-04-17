

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final AutoDisposeStreamProvider sellerProvider = StreamProvider.autoDispose((ref){
  return FirebaseFirestore.instance.collection("Users").where("Type", isEqualTo: "Seller").snapshots();
});