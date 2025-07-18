import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_chat/Models/chat_user.dart';
import 'package:we_chat/UiHelper/Dialogs.dart';

import '../APIs/Apis.dart';
import '../Auth/LoginScreen.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String? _image;

  final _formkey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final mq=MediaQuery.of(context).size;
    return GestureDetector(
      //to hide keyboard if tap any where
      onTap: (){
        FocusScope.of(context).unfocus();
      },

      child: Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          backgroundColor: Colors.cyan,
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              await Apis.auth1.signOut();
              await GoogleSignIn().signOut();
              // Navigate to login screen
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            icon: Icon(Icons.logout),
            label: Text("Logout"),
            backgroundColor: Colors.cyan.shade200,
        ),
        body: Form(
          key: _formkey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width*0.05),
            child: SingleChildScrollView(
              child: Column(
                children:[
                  SizedBox(
                    width: mq.width,
                    height: mq.height*0.03,
                  ),
                  //profile picture
                  Stack(
                    children: [

                      _image != null ?
                          //Local Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(mq.height*0.1),
                          child: Image.file(
                          File(_image!),
                          fit: BoxFit.cover,
                          width: mq.height*0.2,
                          height: mq.height*0.2,
                          ),
                        )
                      :
                          //image from server
                      ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height*0.1),
                        child: CachedNetworkImage(
                          imageUrl: widget.user.image.toString(),
                          fit: BoxFit.cover,
                          width: mq.height*0.2,
                          height: mq.height*0.2,
                          errorWidget: (context, url, error) => Icon(Icons.person, color: Colors.black,),
                        ),
                      ),
                      Positioned(
                        //
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          child: MaterialButton(
                            onPressed: (){
                              _bottomSheet();
                            },
                            color: Colors.white,
                            shape: CircleBorder(),
                            child: Icon(Icons.edit,color: Colors.grey,),
                          ),
                        ),
                      ),
                    ],
                  ),

                  //for adding space
                  SizedBox(
                    height: mq.height*0.03,
                  ),

                  Text(widget.user.email.toString(), style: TextStyle(color: Colors.black54, fontSize: 16)),

                  SizedBox(
                    height: mq.height*0.03,
                  ),

                  //for name
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val)=> Apis.me.name = val,
                    validator: (val)=> val != null && val.isNotEmpty ?null : "Required field",
                    decoration: InputDecoration(
                      hintText:"eg. Shivam singh",
                      label: Text("Name"),
                      prefixIcon: Icon(Icons.person),
                      focusedBorder:OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.cyan,
                        )
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  //for space
                  SizedBox(
                    height: mq.height*0.02,
                  ),

                  //for About
                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val)=> Apis.me.about = val,
                    validator: (val)=> val != null && val.isNotEmpty ?null : "Required field",
                    decoration: InputDecoration(
                      hintText:"eg. i am using We Chat",
                      label: Text("About"),
                      prefixIcon: Icon(Icons.person),
                      focusedBorder:OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.cyan,
                          )
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  //for space
                  SizedBox(
                    height: mq.height*0.02,
                  ),

                  //Update Button
                  ElevatedButton.icon(
                      onPressed: (){
                        if(_formkey.currentState!.validate()){
                          _formkey.currentState!.save();
                          Apis.updateSelfInfo().then((onValue){
                            Dialogs.showSnackbar(context, msg: "Profile Updated Succesfully", color: Colors.green.shade700);
                          });
                        }
                      },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan.shade200,

                    ),
                    icon: Icon(Icons.edit,size: mq.height*0.025,),
                    label: Text("Update", style: TextStyle(fontSize: 16),),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  //Show bottomsheet
  void _bottomSheet(){

    final Size mq= MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)
          ),
        ),
        builder: (_){
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top:mq.height *0.03, bottom: mq.height*0.08),
            children: [
              Text("Pick profile picture", textAlign: TextAlign.center,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              SizedBox(
                height: mq.height*0.02,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //accessing camera
                  SizedBox(
                      height: mq.height* 0.1,
                      width: mq.width* 0.3,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              backgroundColor: Colors.white,
                              fixedSize: Size(mq.height* 0.1, mq.height* 0.1)
                          ),
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            // Pick an image.
                            final XFile? image = await picker.pickImage(source: ImageSource.camera);
                            if (image !=null){
                              print(image.path);
                              setState(() {
                                _image=image.path;
                              });
                              Navigator.pop(context);
                            }
                          }, child: Image.asset("assets/images/photo.png"))),

                  //Accessing Gallery
                  SizedBox(
                    height: mq.height* 0.1,
                    width: mq.width* 0.3,
                    child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            backgroundColor: Colors.white,
                            fixedSize: Size(mq.height* 0.01, mq.width* 0.08)
                          ),
                            onPressed: () async {
                              final ImagePicker picker = ImagePicker();
                              // Pick an image.
                              final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                              if (image !=null){
                                print(image.path);
                                setState(() {
                                  _image=image.path;
                                });
                                Navigator.pop(context);
                              }

                            }, child: Image.asset("assets/images/gallery.png")),
                  ),
                ],
              ),
            ],
          );
    });
  }
}
