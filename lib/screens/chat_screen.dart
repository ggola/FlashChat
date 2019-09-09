import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/utilities/message_stream.dart';
import 'package:flash_chat/utilities/backend.dart';
import 'package:flash_chat/utilities/color_check.dart';
import 'dart:core';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // messageTextController to take care of erasing messages text after send
  final messageTextController = TextEditingController();
  final backend = Backend();
  final colorCheck = ColorCheck();
  FirebaseUser loggedInUser;
  String messageText;
  int hexColor;
  Color color;

  // check if there is a current user
  void getCurrentUserData() async {
    loggedInUser = await backend.getCurrentUser();
    hexColor =
        await colorCheck.getMessageColor(loggedInUserEmail: loggedInUser.email);
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                backend.signOut();
                Navigator.popAndPushNamed(context, WelcomeScreen.id);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(loggedInUserEmail: loggedInUser.email),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      Map<String, dynamic> messageInstance = {
                        'text': messageText,
                        'sender': loggedInUser.email,
                        'username': loggedInUser.displayName,
                        'hexColor': hexColor,
                        'timeStamp': DateTime.now().millisecondsSinceEpoch,
                      };
                      backend.addMessage(messageInstance: messageInstance);
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
