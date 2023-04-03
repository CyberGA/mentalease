import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class Message {
  final String? id;
  final String? msg;
  final String? type;
  final String? sender;
  final String? recipient;
  final bool? isDelivered;
  final bool? isSeen;
  final String? sentAt;
  final num? timestamp;

  Message({
    this.id,
    this.msg,
    this.type,
    this.sender,
    this.recipient,
    this.isDelivered,
    this.isSeen,
    this.sentAt,
    this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'msg': msg,
      'type': type,
      'sender': sender,
      'recipient': recipient,
      'isDelivered': isDelivered,
      'isSeen': isSeen,
      'sentAt': sentAt,
      'timestamp': timestamp,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] != null ? map['id'] as String : null,
      msg: map['msg'] != null ? map['msg'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      sender: map['sender'] != null ? map['sender'] as String : null,
      recipient: map['recipient'] != null ? map['recipient'] as String : null,
      isDelivered: map['isDelivered'] != null ? map['isDelivered'] as bool : null,
      isSeen: map['isSeen'] != null ? map['isSeen'] as bool : null,
      sentAt: map['sentAt'] != null ? map['sentAt'] as String : null,
      timestamp: map['timestamp'] != null ? map['timestamp'] as num : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) => Message.fromMap(json.decode(source) as Map<String, dynamic>);
}
