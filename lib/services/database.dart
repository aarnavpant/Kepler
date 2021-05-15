import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods
{
  getUserByUsername(String username)async
  {
    return await FirebaseFirestore.instance.collection("users")
        .where("name" , isEqualTo: username)
        .get();
  }

  uploadUserInfo(Map<String, String>userInfoMap)
  {
    FirebaseFirestore.instance.collection("users")
        .add(userInfoMap);
  }
}