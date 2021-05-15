import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kepler/helper/authenticate.dart';
import 'package:kepler/helper/constants.dart';
import 'package:kepler/helper/helperFunctions.dart';
import 'package:kepler/services/auth.dart';
import 'package:kepler/services/database.dart';
import 'package:kepler/views/Chats.dart';
import 'package:kepler/views/Signin.dart';
import 'package:kepler/views/search.dart';
import 'package:kepler/widgets/widget.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  AuthMethod authMethod = new AuthMethod();
  Stream chatRoomStream;

  Widget ChatRoomList()
  {
    return StreamBuilder
      (
      stream: chatRoomStream,
      builder: (context , snapshot)
        {
          return snapshot.hasData? ListView.builder(
            itemCount: snapshot.data.docs.length,
              itemBuilder: (context , index)
          {
            return ChatRoomTile(
              snapshot.data.docs[index]["chatroomId"]
                  .toString().replaceAll("_", "")
                  .replaceAll(Constants.myName, ""),
              snapshot.data.docs[index]["chatroomId"]
            );
          }) : Container();
        }
    );
  }

  @override
  void initState() {
    // TODO: implement initState

    getUserInfo();
    super.initState();
  }

  getUserInfo()async
  {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((val){
      setState(() {
        chatRoomStream = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Chats',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: (){
              authMethod.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app_rounded),
            ),
          ),
        ],
      ),
      body: ChatRoomList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff145C9E),
        child: Icon(Icons.search,),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => Search()));
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String NameUser;
  final String ChatRoomId;
  ChatRoomTile(this.NameUser, this.ChatRoomId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => Chat(ChatRoomId, NameUser)));
        },
      child: Container(
        padding: EdgeInsets.only(top: 8),
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8 , vertical: 5),
            padding: EdgeInsets.symmetric(horizontal: 24 , vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(30)
            ),
            child: Row(
              children: [
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color(0xff145C9E)
                  ),
                  child: Center(
                    child: Text(
                      NameUser.substring(0,1).toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16,),
                Text(
                    NameUser,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black
                  ),
                )
              ],
            ),
        ),
      ),
    );
  }
}
