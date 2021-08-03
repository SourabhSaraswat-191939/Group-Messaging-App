import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  // const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (ctx, AsyncSnapshot futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
              stream: Firestore.instance
                  .collection('chat')
                  .orderBy('sentAt', descending: true)
                  .snapshots(),
              builder: (ctx, AsyncSnapshot chatSnapshot) {
                if (chatSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final chatDocs = chatSnapshot.data.documents!;
                print(chatDocs[0]['url']);
                return ListView.builder(
                    reverse: true,
                    itemBuilder: (ctx, index) => MessageBubble(
                          chatDocs[index]['text'],
                          chatDocs[index]['userId'] == futureSnapshot.data.uid,
                          chatDocs[index]['username'],
                          chatDocs[index]['userImage'],
                          key: ValueKey(
                            chatDocs[index].documentID,
                          ),
                        ),
                    itemCount: chatDocs.length);
              });
        });
  }
}
