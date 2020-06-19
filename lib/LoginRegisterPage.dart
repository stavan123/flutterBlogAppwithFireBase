import 'package:flutter/material.dart';
import 'package:flutter_blog_app/Authentication.dart';
import 'package:flutter_blog_app/DialogBox.dart';


class LoginRegisterPage extends StatefulWidget {
  final AuthImplementaion auth;
   final VoidCallback onSignedIn;
   LoginRegisterPage({this.auth,this.onSignedIn});
  
  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();

   
}

enum FormType
{
  login,
  register
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
 DialogBox dialogBox = new DialogBox();

final formKey =  GlobalKey<FormState>();
FormType _formType = FormType.login;
String _email = '';
String _password = '';

  //methods
  
      bool validateAndSave() 
      {
         final form  = formKey.currentState;
         if (form.validate())
         {
           form.save();
           return true;
         }
         else
         {
           return false;
         }
      }
        
      void validateAndSubmit()
      async
      {
        if (validateAndSave())
        {
          try
          {
             if (_formType == FormType.login)
             {
                 String userId = await widget.auth.SignIn(_email, _password);
                //  dialogBox.information(context, "Congradulations", "Your are signed in");
                
                 print("Signed"+userId);
             }
             else
             {
                String userId = await widget.auth.SignUp(_email, _password);
                // dialogBox.information(context, "Congradulations", "Your Account has been created successfully");
                // commented the dialog code above because it is a bad practice to show in login and logout
                 print("Registerd"+userId);
             }
          widget.onSignedIn();
          }
          catch(e)
          {
            dialogBox.information(context, "Error =", e.toString());
            // print("Error"+e.toString());

          }
        }
      }
    
          void moveToRegister() 
          {
            formKey.currentState.reset();
            setState(() {
           _formType = FormType.register;
         });
         }

          void moveToLogin() {
            formKey.currentState.reset();
            setState(() {
           _formType = FormType.login;
         });
         }


  // The design of the gui
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Blog App"),
      ),

      body: Container(
        margin: EdgeInsets.all(15.0),
        child: Form(
          // CrossAxisAlignment.stretch,
            key : formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: 
            createInputs() + createButtons(), 
          )
        ),
      ),
    );
  }

  List <Widget> createInputs ()
  {
    return
    [
     SizedBox(height: 10.0,),
     logo(),
    SizedBox(height: 20.0,),
     TextFormField(
       decoration: InputDecoration(
         labelText: "Email"
       ),
       validator: (value) {
         return value.isEmpty ? "Email is required" : null;
       },
       onSaved: (newValue) {
         return _email = newValue;
       },
     ),
     SizedBox(height: 10.0,),
     TextFormField(
       validator: (value) {
         return value.isEmpty ? "Password is required" : null;
       },
        onSaved: (newValue) {
         return _password= newValue;
       },
       decoration: InputDecoration(
         
         labelText: "Password"
       ),
       obscureText: true,
     )

     ];  
  }

 Widget logo()
 {
   return Hero(
     tag: "tag",
    child: CircleAvatar(
      backgroundColor:  Colors.transparent,
      radius: 110.0,
      child: 
         Image.asset('images/app_logo.png'),        
    ));
 }

  List <Widget> createButtons ()
  {
    if (_formType == FormType.login)
    {
    return
    [
      RaisedButton(
        onPressed:  validateAndSubmit,
        child: Text("Login",style : TextStyle(fontSize: 20.0)),
        textColor: Colors.white,
        color: Colors.red,
        ),
        FlatButton(
        onPressed: moveToRegister,
                        child: Text("Not have an account ? Create Account",style : TextStyle(fontSize: 14.0)),
                        textColor: Colors.pink,
                        
                        )
                    ];
                    }
                    else
                    {
                      return[

        RaisedButton(
        onPressed:  validateAndSubmit,
        child: Text("Create Account",style : TextStyle(fontSize: 20.0)),
        textColor: Colors.white,
        color: Colors.red,
        ),
        FlatButton(
        onPressed: moveToLogin,
                        child: Text("Already have an account",style : TextStyle(fontSize: 14.0)),
                        textColor: Colors.pink,                       
                        )
                    ];
    
                    }
                  }
                  //The above is design               
}