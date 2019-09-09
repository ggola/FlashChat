import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class Backend {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  // Check if there is a current user
  Future<FirebaseUser> getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        return user;
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting user's credentials: exception $e");
      return null;
    }
  }

  Future<QuerySnapshot> getUserMessages({String loggedInUserEmail}) async {
    var userMessages = await _firestore
        .collection('messages')
        .where('sender', isEqualTo: loggedInUserEmail)
        .getDocuments();
    return userMessages;
  }

  Future<QuerySnapshot> getAllMessages() async {
    var messages = await _firestore.collection('messages').getDocuments();
    return messages;
  }

  void addMessage({Map<String, dynamic> messageInstance}) {
    _firestore.collection('messages').add(messageInstance);
  }

  void signOut() {
    _auth.signOut();
  }
}
