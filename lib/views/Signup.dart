

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kepler/helper/helperFunctions.dart';
import 'package:kepler/services/auth.dart';
import 'package:kepler/services/database.dart';
import 'package:kepler/views/Chatroom.dart';
import 'package:kepler/widgets/widget.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {


  final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

final formKey = GlobalKey<FormState>();
class _SignUpState extends State<SignUp> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  bool isLoading = false;
  AuthMethod authMethods = new AuthMethod();

  TextEditingController userTextEditController = new TextEditingController();
  TextEditingController emailTextEditController = new TextEditingController();
  TextEditingController passTextEditController = new TextEditingController();

  signMeUp()
  {
    if(formKey.currentState.validate())
      {
        Map<String, String> userInfoMap = {
          "name" : userTextEditController.text,
          "email" : emailTextEditController.text
        };
        HelperFunctions.saveUserEmailSharedPreference(emailTextEditController.text);
        HelperFunctions.saveUserNameSharedPreference(userTextEditController.text);
        
        setState(() {
          isLoading = true;
        });

        authMethods.signUpWithEmailAndPassword(emailTextEditController.text, passTextEditController.text).then((val){
          //print("${val.uId}");
          databaseMethods.uploadUserInfo(userInfoMap);
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => ChatRoom()
          ));
        });
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading? Container(
        child: Center(child: CircularProgressIndicator()),
      ): SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.supervised_user_circle_rounded,
                  color: Colors.white,
                  size: 150,
                ),
                SizedBox(height: 10,),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val){
                          return val.isEmpty || val.length <4? "too short:)" : null;
                        },
                        controller: userTextEditController,
                        style: simpleTextStyle(),
                        decoration: inpdec('Username'),
                      ),
                      TextFormField(
                        validator: (val){
                          return RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
                          ).hasMatch(val)?null : "provide valid email :p";
                        },
                        controller: emailTextEditController,
                        style: simpleTextStyle(),
                        decoration: inpdec('Email'),
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (val){
                          return val.length <6? "password should be 6+ characters:)" : null;
                        },
                        controller: passTextEditController,
                        style: simpleTextStyle(),
                        decoration: inpdec('Password'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8,),
                SizedBox(height: 8,),
                GestureDetector(
                  onTap: (){
                      signMeUp();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xff007EF4),
                          const Color(0xff2A75BC)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8,),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'Sign Up With Google',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an Account?" , style: simpleTextStyle(),),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}