import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mentalease/colors.dart';
import 'package:mentalease/firebase.dart';
import 'package:mentalease/models/sent_message.dart';

enum BubbleType { sender, receiver }

class MessageBubble extends StatelessWidget {
  final SentMessage data;

  const MessageBubble({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final currentUserID = fAuth.currentUser?.uid;
    final type = data.sender == currentUserID ? BubbleType.sender : BubbleType.receiver;

    final bgColor = type == BubbleType.receiver ? cMute : cMain.withOpacity(0.8);
    final screenSize = MediaQuery.of(context).size;
    final alignment = type == BubbleType.receiver ? Alignment.centerLeft : Alignment.centerRight;
    final border = BorderRadius.circular(12);

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: screenSize.width - 80),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: border,
        ),
        padding: const EdgeInsets.all(8),
        child: Stack(
          children: [
            Padding(
                padding: const EdgeInsets.only(right: 60, top: 5, bottom: 20),
                child: Text(
                  data.msg,
                  style: GoogleFonts.openSans(fontSize: 16, color: cWhite),
                )),
            Positioned(
              bottom: 2,
              right: 5,
              child: Row(
                children: [
                  Text(
                    DateFormat.jm().format(DateTime.parse(data.sentAt)),
                    style: const TextStyle(fontSize: 12, color: cWhite),
                  ),
                  const SizedBox(width: 2),
                  Icon(Icons.done_all, color: data.sender == currentUserID ? msgRead : cWhite.withOpacity(0.5), size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
