

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qcu/services/AuthService.dart';

var userProvider = StreamProvider((ref){
  return FirebaseFirestore.instance.collection("Users").doc(AuthService().getID()).snapshots();
});