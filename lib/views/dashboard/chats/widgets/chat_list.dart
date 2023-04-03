import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentalease/models/sent_message.dart';
import 'package:mentalease/views/dashboard/chats/widgets/message_bubble.dart';

import '../../../../colors.dart';
import '../../../../firebase.dart';

class ChatList extends StatefulWidget {
  final String chatID;

  const ChatList({super.key, required this.chatID});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List<SentMessage> listOfMessages = [];
  Map<String, dynamic>? lastIndex;
  final uid = fAuth.currentUser?.uid;

  // @override
  // void initState() {
  //   super.initState();
  //   userMessage(uid.toString(), widget.chatID).orderBy('timestamp', descending: true).limit(20).snapshots().listen((snapshot) {
  //     if (snapshot.docs.isEmpty) return;
  //     lastIndex = snapshot.docs.first.data();
  //     print(lastIndex);
  //     setState(() {
  //       listOfMessages = snapshot.docs.map((doc) => SentMessage.fromFirestore(doc)).toList().reversed.toList();
  //     });
  //   });

  //   widget.scrollController.addListener(() async {
  //     print("APP_INFO: ${widget.scrollController.position.pixels} ------- ${widget.scrollController.position.minScrollExtent}");

  //     if (widget.scrollController.position.pixels == widget.scrollController.position.minScrollExtent) {
  //       final moreMessages = await userMessage(uid.toString(), widget.chatID).orderBy('timestamp', descending: true).startAfter([lastIndex]).limit(20).get();

  //       print(moreMessages.size);

  //       lastIndex = moreMessages.docs.last.data();

  //       setState(() {
  //         listOfMessages = [...moreMessages.docs.map((doc) => SentMessage.fromFirestore(doc)).toList().reversed.toList(), ...listOfMessages];
  //       });
  //     }
  //   });
  // }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }


  @override
  Widget build(BuildContext context) {
    final uid = fAuth.currentUser?.uid;
    final Stream<QuerySnapshot> messages = userMessage(uid.toString(), widget.chatID).orderBy('timestamp').snapshots();

    return StreamBuilder(
        stream: messages,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Something went wrong", style: GoogleFonts.openSans(fontSize: 16, color: cBlack.withOpacity(0.8))));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Getting messages...", style: GoogleFonts.openSans(fontSize: 16, color: cBlack.withOpacity(0.8))));
          }

          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return Container();
          }

          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final res = snapshot.data?.docs[index];
              final data = SentMessage.fromFirestore(res!);

              return MessageBubble(data: data);
            },
          );
        });

  //   return SingleChildScrollView(
  //     controller: widget.scrollController,
  //     // physics: const BouncingScrollPhysics(),
  //     child: Column(
  //       children: [
  //         ShowMessages(
  //           messages: listOfMessages,
  //         )
  //       ],
  //     ),
  //   );
  }
}

class ShowMessages extends StatelessWidget {
  final List<SentMessage> messages;

  const ShowMessages({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: messages.map((data) {
        return MessageBubble(data: data);
      }).toList(),
    );
  }
}

/// To Be Shown When loading messages
class LoadingMessages extends StatelessWidget {
  const LoadingMessages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: cMain.withOpacity(0.6),
            ),
            const SizedBox(height: 10),
            Text("More messages loading..", style: GoogleFonts.openSans(fontSize: 16, color: cBlack.withOpacity(0.3)))
          ],
        ));
  }
}

/// To Be Shown When an error occurs loading messages
class ErrorLoadingMessages extends StatelessWidget {
  const ErrorLoadingMessages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Error Loading Messages"),
            SizedBox(
              height: 20,
            ),
            TextButton.icon(onPressed: () {}, icon: Icon(Icons.refresh), label: Text("Try Again .."))
          ],
        ));
  }
}
