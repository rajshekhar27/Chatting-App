import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat/Models/chat_user.dart';

import '../APIs/Apis.dart';
import '../Auth/LoginScreen.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final mq=MediaQuery.of(context).size;
    return Scaffold(
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: mq.width*0.05),
        child: Column(
          children:[
            SizedBox(
              width: mq.width,
              height: mq.height*0.03,
            ),
            //profile picture
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height*0.1),
                  child: CachedNetworkImage(
                    imageUrl: widget.user.image.toString(),
                    fit: BoxFit.fill,
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
                      onPressed: (){},
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
              decoration: InputDecoration(
                hintText:"eg. Shivam shing",
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
    );
  }
}
