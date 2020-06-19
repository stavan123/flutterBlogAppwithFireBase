import 'package:flutter/material.dart';
import 'package:flutter_blog_app/Authentication.dart';
import 'package:flutter_blog_app/Mapping.dart';

void main() {
  runApp(BlogApp());
}

class BlogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Blog App",
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      // home: LoginRegisterPage(),
      home:Mappingpage(auth: Auth(),),

    );
  }
}