import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/APIs/Apis.dart';
import 'package:we_chat/screens/HomeScreen.dart';
import 'package:google_sign_in/google_sign_in.dart' as gsi;

import '../UiHelper/Dialogs.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate=false;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 500),(){
      setState(() {
        _isAnimate=true;
      });;
    });
  }

  //this function is to handle the functionality of GoogleButton of LoginScreen
  _handleGoogleButtonClick(){
    //showing progress bar
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async {
      //Hiding Progress bar
      Navigator.pop(context);
      if(user!=null){
        print("\nUser : ${user.user}");
        print("\nUserAdditionalInfo: ${user.additionalUserInfo}");
        if(await Apis.userExist()){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomeScreen()));
        }else{
          Apis.newUser().then((value){
            return Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomeScreen()));
          });
        }

      }
    });
  }

  //Google sign-in code
  Future<UserCredential?> _signInWithGoogle() async {
   try{
     //chacking internet connection
     await InternetAddress.lookup("google.com");

     // Trigger the authentication flow
     final gsi.GoogleSignInAccount? googleUser = await gsi.GoogleSignIn().signIn();

     // If the user cancels the sign-in
     if (googleUser == null) {
       throw Exception('Google sign-in was cancelled');
     }

     // Obtain the auth details from the request
     final gsi.GoogleSignInAuthentication googleAuth = await googleUser.authentication;

     // Create a new credential
     final credential = GoogleAuthProvider.credential(
       accessToken: googleAuth.accessToken,
       idToken: googleAuth.idToken,
     );

     // Once signed in, return the UserCredential
     return await FirebaseAuth.instance.signInWithCredential(credential);
   }catch(e){
     print("sign_in_with_google: $e");
     Dialogs.showSnackbar(context, msg: "Somthing Went Wrong(Check your internet!!!)", color: Colors.red);
     return null;
   }
  }


  //gloabal object to accessing device screen size
  late Size mq;

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome to We Chat"),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
              top: mq.height*0.15,
              right: _isAnimate? mq.width*0.15:-mq.width*0.7,
              width: mq.width * 0.7,
              duration: Duration(seconds: 1),
              child: Image.asset("assets/images/login_icon.png", )),
          Positioned(
              bottom: mq.height*0.15,
              left: mq.width*0.1,
              width: mq.width * 0.8,
              height: mq.height*0.055,
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan.shade50,
                    elevation: 1,
                  ),
                  onPressed: (){
                    _handleGoogleButtonClick();
                  },
                  icon: Image.asset("assets/images/google.png",height: mq.height*0.035,),
                  label: Text("Login With Google",style: TextStyle(fontSize: 18, color: Colors.black),),
              ),
          ),
        ],
      ),
    );
  }
}
