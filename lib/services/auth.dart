import 'package:firebase_auth/firebase_auth.dart';
import 'package:kepler/model/user.dart';



class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Users _userFromFirebaseUser(User user) {
    return user != Null ? Users(userId: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async
  {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      User fbuser = userCredential.user;
      return _userFromFirebaseUser(fbuser);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async
  {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      User firebaseUser = userCredential.user;
      return _userFromFirebaseUser(firebaseUser);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future resetPassword(String email) async
  {
    try{
        return await _auth.sendPasswordResetEmail(email: email);
    }catch(e)
    {
      print(e.toString());
    }
  }

  Future signOut()async
  {
    try{
        return await _auth.signOut();
    }catch(e)
    {
      print(e.toString());
    }
  }
}