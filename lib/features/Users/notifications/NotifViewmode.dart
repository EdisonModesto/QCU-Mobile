

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qcu/services/AuthService.dart';

final notifProvider = StreamProvider((ref){
  return FirebaseFirestore.instance.collection("Users").doc(AuthService().getID()).collection("Notifications").orderBy("Date", descending: true).snapshots();
});