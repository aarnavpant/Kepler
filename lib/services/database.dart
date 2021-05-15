import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods
{
  getUserByUsername(String username)async
  {
    return await FirebaseFirestore.instance.collection("users")
        .where("name" , isEqualTo: username)
        .get();
  }

  getUserByUserEmail(String email)async
  {
    return await FirebaseFirestore.instance.collection("users")
        .where("email" , isEqualTo: email)
        .get();
  }

  uploadUserInfo(Map<String, String>userInfoMap)
  {
    FirebaseFirestore.instance.collection("users")
        .add(userInfoMap);
  }

  createChatRoom(String chatRoomId , chatRoomMap)
  {
    FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatRoomId).set(chatRoomMap)
        .catchError((e){
          print(e.toString());
        });
  }

  addConversationMessages(String chatRoomId , messageMap)
  {
    FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatRoomId).collection("chats").add(messageMap);
  }

  getConversationMessages(String chatRoomId)async
  {
    return await FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatRoomId).collection("chats").orderBy("time").snapshots();
  }

  getChatRooms(String username)async
  {
    return await FirebaseFirestore.instance.collection("ChatRoom")
        .where("users", arrayContains: username)
        .snapshots();
  }
}