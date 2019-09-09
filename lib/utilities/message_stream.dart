import 'package:flutter/material.dart';
import 'package:flash_chat/utilities/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MessagesStream extends StatelessWidget {
  MessagesStream({@required this.loggedInUserEmail});
  final _firestore = Firestore.instance;
  final String loggedInUserEmail;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          _firestore.collection('messages').orderBy('timeStamp').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.documents.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data['text'];
          final messageSenderEmail = message.data['sender'];
          final messageUsername = message.data['username'];
          final messageColor = message.data['hexColor'];
          final messageTime = message.data['timeStamp'];
          // Get message time in readable format
          DateTime date = DateTime.fromMillisecondsSinceEpoch(messageTime);
          final format = DateFormat('HH:mm');
          final messTime = format.format(date);
          // Pass data to messageBubble
          final messageBubble = MessageBubble(
            sender: messageUsername,
            text: messageText,
            time: messTime,
            hexColor: messageColor,
            isMe: (loggedInUserEmail == messageSenderEmail),
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true, // makes listView stick to the bottom of the view
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}
