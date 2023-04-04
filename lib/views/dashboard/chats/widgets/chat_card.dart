import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mentalease/models/chat.dart';
import 'package:mentalease/views/dashboard/chats/messages.dart';

import '../../../../colors.dart';
import '../../../../firebase.dart';

class ChatCard extends StatelessWidget {
  final ChatModel chat;
  const ChatCard({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    final currentUserID = fAuth.currentUser?.uid;

    final Stream<DocumentSnapshot> message = lastMessage(currentUserID.toString(), chat.id).snapshots();

    return StreamBuilder(
        stream: message,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListTile(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Messages(chat: chat))),
              leading: SizedBox(
                width: 50,
                child: ClipOval(
                    child: Image.network(
                  chat.photo,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(width: 50, height: 50, color: cMain.withOpacity(0.3), child: Icon(Icons.person, color: cWhite.withOpacity(0.8)));
                  },
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )),
              ),
              shape: Border(bottom: BorderSide(color: cBlack.withOpacity(0.2), width: 0.5)),
              title: Text(
                chat.username,
                style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text(
                "loading...",
                style: GoogleFonts.openSans(fontSize: 16),
              ),
              trailing: Text(
                "....",
                style: GoogleFonts.openSans(fontSize: 14, color: cBlack.withOpacity(0.6), fontWeight: FontWeight.w600),
              ),
            );
          }

          final data = snapshot.data;

          return ListTile(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Messages(chat: chat))),
            leading: SizedBox(
              width: 50,
              child: ClipOval(
                  child: Image.network(
                chat.photo,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(width: 50, height: 50, color: cMain.withOpacity(0.3), child: Icon(Icons.person, color: cWhite.withOpacity(0.8)));
                },
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )),
            ),
            shape: Border(bottom: BorderSide(color: cBlack.withOpacity(0.2), width: 0.5)),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  chat.username,
                  style: GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            subtitle: data!.exists ?  Row(
              children: [
                Icon(
                  Icons.done_all,
                  size: 20,
                  color: cBlack.withOpacity(0.3),
                ),
                const SizedBox(width: 3),
                Text(
                data["lastMessage"],
                  style: GoogleFonts.openSans(fontSize: 16),
                )
              ],
            ) : const SizedBox.shrink(),
            trailing: Text(
              data.exists ? DateFormat.jm().format(DateTime.parse(data["lastMessageTime"])) : "",
              style: GoogleFonts.openSans(fontSize: 14, color: cBlack.withOpacity(0.6), fontWeight: FontWeight.w600),
            ),
          );
        });
  }
}
