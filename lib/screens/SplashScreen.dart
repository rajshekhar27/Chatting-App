import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/APIs/Apis.dart';
import 'package:we_chat/screens/HomeScreen.dart';
import '../Auth/LoginScreen.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Size mq;

  @override
  void initState() {
    //Navigating to loginScreen or HomeScreen
    Timer(Duration(seconds: 3),(){
      if(Apis.auth1.currentUser!=null){
        print("${Apis.auth1.currentUser}");
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomeScreen()));
      }else{
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoginScreen()));
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    mq=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            top: mq.height*0.20,
              left: mq.width*0.20,
              width: mq.width*0.6,
              child: Image.asset("assets/images/chat.png"),
          ),
          Positioned(
            bottom: mq.height*0.25,
              left: mq.width*0.3,
              width: mq.width*0.7,
              child: Text("India Made ❤️",style: TextStyle(fontSize: 20,color: Colors.white),))
        ]
      ),
    );
  }
}
