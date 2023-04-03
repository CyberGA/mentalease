// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class SentMessage {
  final String id;
  final bool isDelivered;
  final bool isSeen;
  final String msg;
  final String recipient;
  final String sender;
  final String sentAt;
  final int timestamp;
  final String type;

  SentMessage({
    required this.id,
    required this.isDelivered,
    required this.isSeen,
    required this.msg,
    required this.recipient,
    required this.sender,
    required this.sentAt,
    required this.timestamp,
    required this.type,
  });

  factory SentMessage.fromFirestore(
    QueryDocumentSnapshot<Object?> data,
  ) {
    return SentMessage(
      id: data['id'],
      isDelivered: data['isDelivered'],
      isSeen: data['isSeen'],
      msg: data['msg'],
      recipient: data['recipient'],
      sender: data['sender'],
      sentAt: data['sentAt'],
      timestamp: data['timestamp'],
      type: data['type'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "isDelivered": isDelivered,
      "isSeen": isSeen,
      "msg": msg,
      "recipient": recipient,
      "sender": sender,
      "sentAt": sentAt,
      "timestamp": timestamp,
      "type": type,
    };
  }
}
