import 'package:get/get.dart';
import 'package:mentalease/models/message.dart';
import 'package:mentalease/repository/exceptions/chat.dart';

import '../firebase.dart';

class ChatService extends GetxController {
  static ChatService get instance => Get.find();

  Future sendMessage(Message msg, String from, String to, String msgID) async {
    final batch = fDb.batch();
    try {
      batch.set(userMessageCollection(from, msgID, to), msg.toMap());
      batch.set(userMessageCollection(to, msgID, from), msg.toMap());
      batch.set(lastMessage(from, to), {
        "lastMessage": msg.msg,
        "lastMessageTime": msg.sentAt,
      });
      batch.set(lastMessage(to, from), {
        "lastMessage": msg.msg,
        "lastMessageTime": msg.sentAt,
      });

      await batch.commit();
    } catch (e) {
      const err = ChatFailure();
      return err;
    }
  }
}
