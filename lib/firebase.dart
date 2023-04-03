import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

const isDebug = true;

/// Firebase Auth
final fAuth = FirebaseAuth.instance;

// Firestore database
final fDb = FirebaseFirestore.instance;

// / Firebase Storage

final fStorage = firebase_storage.FirebaseStorage.instance;

// firestore collections
final usersCollection = fDb.collection("users");
final therapistsCollection = fDb.collection("therapists");

final chatsCollection = fDb.collection("chats");
final messagesCollection = fDb.collection("messages");

DocumentReference<Map<String, dynamic>> userMessageCollection(String uid, String msgID, String chatID) {
  return chatsCollection.doc(uid).collection("chat").doc(chatID).collection("messages").doc(msgID);
}

CollectionReference<Map<String, dynamic>> userMessage(String uid, String chatID) {
  return chatsCollection.doc(uid).collection("chat").doc(chatID).collection("messages");
}

DocumentReference<Map<String, dynamic>> lastMessage(String uid, String chatID) {
  return chatsCollection.doc(uid).collection("chat").doc(chatID);
}

// CollectionReference<Map<String, dynamic>> userChatMessageCollection(String uid, String chatId) {
//   return fDb.collection(userCollections).doc(uid).collection(chatCollectionsName).doc(chatId).collection(messageCollectionsName);
// }

// CollectionReference<Map<String, dynamic>> therapistChatMessageCollection(String uid, String chatId) {
//   return fDb.collection(userCollections).doc(uid).collection(therapistCollections).doc(chatId).collection(messageCollectionsName);
// }

// DocumentReference<Map<String, dynamic>> userChatDocument(String uid, String chatId) {
//   return usersCollection.doc(uid).collection(chatCollectionsName).doc(chatId);
// }

// DocumentReference<Map<String, dynamic>> userChatMessageDocument(String uid, String chatId, String messageId) {
//   return usersCollection.doc(uid).collection(chatCollectionsName).doc(chatId).collection(messageCollectionsName).doc(messageId);
// }
