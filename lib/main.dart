import 'package:kepler/helper/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kepler/helper/helperFunctions.dart';
import 'package:kepler/views/Chatroom.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool userIsLoggedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    getLoggedInState();
    super.initState();
  }

  getLoggedInState()async
  {
    await HelperFunctions.getUserLoggedInSharedPreference()
    .then((value) {
        setState(() {
          userIsLoggedIn = value;
        });
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kepler',
      theme: ThemeData(
        primaryColor: Color(0xff145C9E),
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userIsLoggedIn ? ChatRoom(): Authenticate(),
    );
  }
}

