import 'package:flutter/material.dart';
import 'package:flutter_blog_app/HomePage.dart';

import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class UploadPhotoPage extends StatefulWidget {
  @override
  State createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  String _myvalue;
  File sampleImage;
  String url;
  final  formKey = GlobalKey<FormState>();


Future getImage()
async
{
  // var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
  var tempImage = await ImagePicker().getImage(source: ImageSource.camera);


  setState(() {
    sampleImage = File(tempImage.path);
  });
}

bool validateAndSave()
{
  final form = formKey.currentState;
  if(form.validate())
  {
    form.save();
    return true;
  }
  else{
    return false;
  }
}


void uploadStatusImage()
async
{
  if (validateAndSave())
  {
     final StorageReference postImageRef = FirebaseStorage.instance.ref().child("Post Images");
     var timeKey = DateTime.now();
     final StorageUploadTask uploadTask = postImageRef.child(timeKey.toString() + ".jpg").putFile(sampleImage);
     
    var Imageurl =  await (await uploadTask.onComplete).ref.getDownloadURL();
    url = Imageurl.toString();
    print("Image url"+url);
    goToHomePage();
    saveToDatabase(url);
  }
  
}

void saveToDatabase(url)
{
   var dbtimeKey = DateTime.now();
   var formatDate = DateFormat('MMM d, yyyy');
   var formatTime = DateFormat('EEEE,hh:mm aaa');
   String date = formatDate.format(dbtimeKey);
   String time = formatTime.format(dbtimeKey);

   DatabaseReference ref = FirebaseDatabase.instance.reference();

   var data = {
     "image":url,
     "description":_myvalue,
     "date":date,
     "time":time,
   };
 ref.child("Posts").push().set(data);

}

 void goToHomePage()
 {
   Navigator.push(context,
    MaterialPageRoute(builder: (context)
    {
      return HomePage();
    })
    );
 }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Image"),
        centerTitle: true,
      ),
      body: Center(
        child: sampleImage == null ? Text("Select an image") : enableUpload(),
      ),
      floatingActionButton:  FloatingActionButton(
        onPressed: getImage,
        tooltip: "AddImage",
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget enableUpload()
  {
    return Container(
    child: Form(
      key: formKey,
      child: Column(
        children: <Widget>[
           Image.file(sampleImage,height: 330.0, width :660.0),
           SizedBox(height : 15.0),
           TextFormField(
             decoration: InputDecoration(labelText:"Description" ),
             validator: (value) {
               return value.isEmpty ? "Blod description is required" : null;
             },
             onSaved: (newValue) {
               _myvalue = newValue;
             },
           ),
           SizedBox(height : 15.0),// used for giving space

           RaisedButton(
             elevation: 10.0,
             child:  Text("Add a new Post"),
             textColor: Colors.white,
             color: Colors.pink,
             onPressed: uploadStatusImage,
             )

         
        ],
      )
    )
      );
  }
}