import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kepler/helper/constants.dart';
import 'package:kepler/services/database.dart';
import 'package:kepler/views/Chats.dart';
import 'package:kepler/widgets/widget.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController usernameTextEditingController = new TextEditingController();

  QuerySnapshot searchSnapshot ;

  initiateSearch()
  {
    databaseMethods.getUserByUsername(usernameTextEditingController.text)
        .then((val){
        setState(() {
          searchSnapshot = val;
        });
    });
  }


  Widget SearchList()
  {
    return searchSnapshot != null ?ListView.builder(
        itemCount: searchSnapshot.docs.length,
        shrinkWrap: true,
        itemBuilder: (context, index)
    {
      return SearchTile(
        userName: searchSnapshot.docs[index]['name'],
        userEmail: searchSnapshot.docs[index]['email'],
      );
    }): Container();
  }

  @override
  void initState() {

    super.initState();
  }

  getChatRoomID(String a, String b)
  {
    if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0))
      {
        return "$b\_$a";
      }
    else
      {
        return "$a\_$b";
      }
  }

  createChatRoomAndStartConversation(String username)
  {

    String ChatID = getChatRoomID(username, Constants.myName);
    List<String> users = [username, Constants.myName];
    Map<String, dynamic> chatRoomMap = {
      "users" : users,
      "chatroomId" : ChatID
    };
    databaseMethods.createChatRoom(ChatID, chatRoomMap);
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => Chat(ChatID , username)
    ));
  }

  Widget SearchTile({String userName , String userEmail})
  {
    return Container(
      margin: EdgeInsets.symmetric(vertical : 5),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white24,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              Text(
                userEmail,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              createChatRoomAndStartConversation(userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'Message',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kepler',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                            controller: usernameTextEditingController,
                            decoration: InputDecoration(
                              hintText: "Search a User",
                              hintStyle: TextStyle(
                                color: Colors.black54,
                              ),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          )
                      ),
                      GestureDetector(
                        onTap: (){
                          initiateSearch();
                        },
                        child: Icon(
                            Icons.search,
                            color: Color(0xff145C9E),
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              SearchList(),
            ],
          ),
        ),
      ),
    );
  }
}
