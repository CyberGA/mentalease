import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mentalease/colors.dart';
import 'package:mentalease/firebase.dart';
import 'package:mentalease/models/chat.dart';
import 'package:mentalease/models/message.dart';
import 'package:mentalease/repository/exceptions/remote_storage.dart';
import 'package:mentalease/shared/utils.dart';
import 'package:mentalease/views/dashboard/chats/widgets/chat_list.dart';
import 'package:mentalease/views/dashboard/controllers/chat.dart';

class Messages extends StatefulWidget {
  final ChatModel chat;
  const Messages({super.key, required this.chat});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final chatController = Get.put(ChatController());
  final ScrollController messageScrollController = ScrollController();
  bool showEmojis = false;
  FocusNode focusNode = FocusNode();
  final TextEditingController _messageController = TextEditingController();
  bool msgSendError = false;
  bool isResend = false;
  bool isSending = false;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    messageScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cMain,
        elevation: 0,
        leadingWidth: 100,
        leading: Row(
          children: [
            const BackButton(color: cWhite),
            ClipOval(
                child: Image.network(widget.chat.photo, loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(width: 40, height: 40, color: cMain.withOpacity(0.4), child: Icon(Icons.person, color: cWhite.withOpacity(0.8)));
            }, width: 40, height: 40, fit: BoxFit.cover)),
            const SizedBox(width: 10),
          ],
        ),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.chat.username, style: GoogleFonts.openSans(color: cWhite, fontSize: 20, fontWeight: FontWeight.bold)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.chat.isOnline ? "Online" : "Offline", style: GoogleFonts.openSans(color: cWhite, fontSize: 14)),
              ],
            ),
          ],
        ),
        // actions: [
        //   IconButton(
        //       onPressed: () {},
        //       icon: const Icon(
        //         Icons.call,
        //         color: cWhite,
        //       )),
        //   IconButton(
        //       onPressed: () {},
        //       icon: const Icon(
        //         Icons.calendar_month_outlined,
        //         color: cWhite,
        //       ))
        // ],
      ),
      body: SafeArea(
          child: WillPopScope(
        onWillPop: () {
          if (showEmojis) {
            setState(() {
              showEmojis = false;
            });
          } else {
            Navigator.pop(context);
          }
          return Future.value(false);
        },
        child: Stack(
          children: [
            Image.asset(
              "assets/images/message_bg.png",
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 60,
                child: ChatList(
                  chatID: widget.chat.id,
                  scrollController: messageScrollController,
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        color: cWhite,
                        border: Border(
                          top: BorderSide(width: 1, color: cBlack.withOpacity(0.1)),
                          bottom: BorderSide(width: 1, color: cBlack.withOpacity(0.1)),
                        )),
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - (isResend ? 90 : 70),
                          child: TextFormField(
                            focusNode: focusNode,
                            controller: _messageController,
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.multiline,
                            cursorColor: cBlack,
                            minLines: 1,
                            maxLines: 100,
                            decoration: InputDecoration(
                              hintText: "Type a message",
                              prefixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      focusNode.unfocus();
                                      showEmojis = !showEmojis;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.emoji_emotions_sharp,
                                    color: cMain.withOpacity(0.2),
                                  )),
                              hintStyle: GoogleFonts.openSans(color: cBlack.withOpacity(0.4), fontSize: 16),
                              border: const OutlineInputBorder(borderSide: BorderSide.none),
                              enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                              focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
                            ),
                            onTap: () {
                              setState(() {
                                showEmojis = false;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 4),
                        msgSendError ? const Icon(Icons.error, color: cError, size: 18) : const SizedBox.shrink(),
                        msgSendError ? const SizedBox(width: 2) : const SizedBox.shrink(),
                        isSending
                            ? Icon(
                                Icons.update,
                                color: cMain.withOpacity(0.2),
                              )
                            : GestureDetector(
                                onTap: onSendMessage,
                                child: CircleAvatar(
                                  backgroundColor: cMain,
                                  child: Icon(isResend ? Icons.refresh : Icons.send, color: cWhite, size: 16),
                                ),
                              )
                      ],
                    ),
                  ),
                  emojiSelect()
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

  onSendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    setState(() {
      isResend = false;
      msgSendError = false;
      isSending = true;
    });
    String msgID = Utils.idGenerator();
    final date = DateTime.now();

    final msg = Message(
      id: msgID,
      msg: _messageController.text,
      isSeen: false,
      isDelivered: true,
      recipient: widget.chat.id,
      sender: fAuth.currentUser?.uid,
      sentAt: date.toString(),
      timestamp: date.millisecondsSinceEpoch,
      type: "text",
    );

    chatController.sendMessage(msg, msg.sender.toString(), msg.recipient.toString(), msgID).then((res) {
      setState(() {
        isSending = false;
      });
      if (res is RemoteStorageFailure) {
        setState(() {
          isResend = true;
          msgSendError = true;
        });
      } else {
        _messageController.clear();
        setState(() {
          showEmojis = false;
          isResend = false;
          msgSendError = false;
        });
        focusNode.unfocus();
      }
    });
  }

  emojiSelect() => Offstage(
        offstage: !showEmojis,
        child: SizedBox(
          height: 250,
          child: EmojiPicker(
            onEmojiSelected: (category, emoji) {
              _messageController.text = _messageController.text + emoji.emoji;
            },
            onBackspacePressed: () {
              setState(() {
                showEmojis = false;
              });
            },
            // textEditingController: textEditionController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
            config: const Config(
              columns: 7,
              emojiSizeMax: 22,
              gridPadding: EdgeInsets.zero,
              indicatorColor: cMain,
              iconColorSelected: cMain,
              backspaceColor: cMain,
              verticalSpacing: 0,
              horizontalSpacing: 0,
            ),
          ),
        ),
      );
}
