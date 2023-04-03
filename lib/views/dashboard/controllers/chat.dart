import 'package:get/get.dart';
import 'package:mentalease/models/message.dart';
import 'package:mentalease/repository/chat_service.dart';

class ChatController extends GetxController {
  static ChatController get instance => Get.find();

  Future sendMessage(Message msg, String from, String to, String msgID) async {
    final res = await ChatService.instance.sendMessage(msg, from, to, msgID);
    return res;
  }
}
