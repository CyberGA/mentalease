import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentalease/models/sent_message.dart';
import 'package:mentalease/views/dashboard/chats/widgets/message_bubble.dart';

import '../../../../colors.dart';
import '../../../../firebase.dart';

class ChatList extends StatefulWidget {
  final String chatID;
  final ScrollController scrollController;

  const ChatList({super.key, required this.chatID, required this.scrollController});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List<SentMessage> listOfMessages = [];
  Map<String, dynamic>? lastIndex;
  final uid = fAuth.currentUser?.uid;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
        stream: userMessage(uid.toString(), widget.chatID).orderBy('timestamp').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Something went wrong", style: GoogleFonts.openSans(fontSize: 16, color: cError.withOpacity(0.5))));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Getting messages...", style: GoogleFonts.openSans(fontSize: 16, color: cBlack.withOpacity(0.8))));
          }

          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return Container();
          }

          SchedulerBinding.instance.addPostFrameCallback((_) {
            widget.scrollController.jumpTo(widget.scrollController.position.maxScrollExtent);
          });

          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            controller: widget.scrollController,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final res = snapshot.data?.docs[index];
              final data = SentMessage.fromFirestore(res!);

              return MessageBubble(data: data);
            },
          );
        });
  }
}
