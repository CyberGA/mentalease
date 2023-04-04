// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChatModel {
  String id;
  String username;
  String photo;
  String lastMessage;
  String lastMessageTime;
  bool lastMessageRead;
  bool isOnline;
  bool isGroup;
  ChatModel({
    required this.id,
    required this.username,
    required this.photo,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.lastMessageRead,
    required this.isOnline,
    required this.isGroup,
  });
}
