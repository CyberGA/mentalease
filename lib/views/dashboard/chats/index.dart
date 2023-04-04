import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentalease/firebase.dart';
import 'package:mentalease/models/chat.dart';
import 'package:mentalease/models/role.dart';
import 'package:mentalease/views/dashboard/chats/widgets/chat_card.dart';

import '../../../module/localDB.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  late Role? role;

  @override
  void initState() {
    super.initState();
    role = LocalDB.getUserRole();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = fAuth.currentUser;
    final CollectionReference usersRef = role == Role.user ? therapistsCollection : usersCollection;
    final Stream<QuerySnapshot> users = usersRef.snapshots();

    return StreamBuilder<QuerySnapshot>(
        stream: users,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Text(
              "Loading chats...",
              style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.w600),
            ));
          }

          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text(
              "No ${role == Role.user ? "therapist" : "user"} found",
              style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.w600),
            ));
          }

          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final data = snapshot.data?.docs[index];

              if (data!["id"] == currentUser?.uid) {
                return const SizedBox.shrink();
              }

              final chatData = ChatModel(
                id: data["id"],
                username: data["username"],
                photo: data["photo"],
                lastMessage: "Latest message",
                lastMessageTime: DateTime.now().toString(),
                isGroup: false,
                isOnline: false,
                lastMessageRead: true,
              );

              return ChatCard(chat: chatData);
            },
          );
        });
  }
}
