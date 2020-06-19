import 'package:flutter/material.dart';
import 'LoginRegisterPage.dart';
import 'HomePage.dart';
import 'Authentication.dart';



class Mappingpage extends StatefulWidget {
  final AuthImplementaion auth;
  Mappingpage({this.auth});
  @override
   State createState() => _MappingpageState();
} 

enum AuthStatus
{
  notSignedIn,signedIn
}

class _MappingpageState extends State<Mappingpage> {

  AuthStatus authStatus = AuthStatus.notSignedIn;
  
  @override
  void initState() {
    
    super.initState(); 
    widget.auth.getCurrentuser().then((firebaseUserId)  {
      setState(() {
        authStatus = firebaseUserId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    }).catchError((onError)
    {
        authStatus = AuthStatus.notSignedIn;
    });
  }
  void _signedIn()
  {
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }
  void _signedOut()
  {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }
  @override
  Widget build(BuildContext context) {
    switch(authStatus)
    {
      case AuthStatus.notSignedIn :
      return LoginRegisterPage(
        auth: widget.auth,
        onSignedIn: _signedIn
      );
      case AuthStatus.signedIn :
      return HomePage(
        auth: widget.auth,
        onSignedOut: _signedOut,
      );
    }
    return null;
  }
}