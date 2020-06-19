import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthImplementaion
{
Future<String> SignIn(String email, String password);
Future<String> SignUp(String email, String password);
Future <void> signOut();
Future<String> getCurrentuser();
}

class Auth implements AuthImplementaion
{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<String> SignIn(String email, String password)
  async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
   FirebaseUser user = result.user;
    return user.uid;
  }


  Future<String> SignUp(String email, String password)
  async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
   FirebaseUser user = result.user;
   
    return user.uid;
  }



  Future <void> signOut()
  async 
  {
    _firebaseAuth.signOut();
  }

  Future<String> getCurrentuser()
  async
  {
     FirebaseUser  user = await _firebaseAuth.currentUser();
    return user != null ? user.uid: null;
  //  FirebaseUser user = result.user;
    }}
  
    
