import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var authStateProvider = StreamProvider((ref){
  return FirebaseAuth.instance.authStateChanges();
});