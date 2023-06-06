import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Auth with ChangeNotifier {
  bool hasSuperAdmin = false;
  bool isLoading = false;
  
 
  void setIsLoading(bool value){
     isLoading = value;
     notifyListeners();
  }

  Future<void> authenticate(
      String email, String password,bool isLogin,bool addedByAdmin) async {
    final _auth = FirebaseAuth.instance;
    UserCredential authResult;
    try {
      isLoading = true;
      if(isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email.toLowerCase(), password: password);
      var x = await FirebaseFirestore.instance.collection('users').doc(authResult.user!.uid).get();
      }else{
        authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      }
      isLoading = false;
    } on FirebaseAuthException catch (e) {
      String message = "error Occurred";

      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else if (e.code == 'user-not-found'&&!addedByAdmin) {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
      isLoading = false;
      throw message;
    } catch (e) {
      print(e);
      isLoading = false;
      rethrow;
    }
    //notifyListeners();
  }
}