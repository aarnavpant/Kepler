import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kepler/helper/constants.dart';
import 'package:kepler/services/database.dart';
import 'package:kepler/widgets/widget.dart';
class Chat extends StatefulWidget {
  final String chatRoomId;
  final String name;
  Chat(this.chatRoomId , this.name);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();
  Stream chatMessageStream;

  Widget ChatMessageList()
  {
    return StreamBuilder(
        stream: chatMessageStream,
        builder: (context , snapshot)
    {
      return snapshot.hasData? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context , index){
            return MessageTile(snapshot.data.docs[index]["message"],snapshot.data.docs[index]["sendBy"] == Constants.myName);
          }
      ) : Container();
    });
  }

  sendMessage()
  {
    if (messageController.text.isNotEmpty){
      Map<String , dynamic> messageMap = {
        "message" :messageController.text,
        "sendBy" : Constants.myName,
        "time" : DateTime.now().microsecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text = "";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    databaseMethods.getConversationMessages(widget.chatRoomId).then((val){
      setState(() {
        chatMessageStream  = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      body:Container(
          child: Stack(
            children: [
          ChatMessageList(),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                      controller : messageController,
                      decoration: InputDecoration(
                        hintText: "Type Your Text Here",
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
                Icon(
                  Icons.attach_file,
                  size: 30,
                  color: Color(0xff145C9E),
                ),
                SizedBox(width:8 ,),
                GestureDetector(
                  onTap: (){
                      sendMessage();
                  },
                  child: Icon(
                    Icons.send_rounded,
                    color: Color(0xff145C9E),
                    size: 30,
                  ),
                ),
              ],
            ),
        ),
          ),
            ],
          ),
        ),
    );
  }
}
class MessageTile extends StatelessWidget {

  final String msg;
  final bool isSendByMe;
  MessageTile(this.msg,this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal :24, vertical: 16),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: isSendByMe?
            BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30)
            ) :
          BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30)
          ),
          gradient: LinearGradient(
            colors: isSendByMe? [
              const Color(0xff007EF4),
              const Color(0xff2A75BC)
            ] : [
              const Color(0x1AFFFFFF),
              const Color(0x1AFFFFFF)
            ]
          )
        ),
        child: Text(
            msg,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17
          ),
        ),
      ),
    );
  }
}
