import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:we_chat/Models/chat_user.dart';

class Apis{
  //Firebase gloable instance
  static FirebaseAuth auth1= FirebaseAuth.instance;

  //Firestore cloude gloable instance
  static FirebaseFirestore firestore1=FirebaseFirestore.instance;

  //checking if the user exist or not
static Future<bool> userExist() async{
  return (await firestore1.collection('user').doc(auth1.currentUser!.uid).get()).exists;
}

//getting current user
  static User get user=>auth1.currentUser!;

//creating a new user
static Future<void> newUser() async{
  final time= DateTime.now().microsecondsSinceEpoch.toString();
  final chatuser=ChatUser(
      image: user.photoURL,
      name: user.displayName,
      about: "hey i am using, we chat",
      pushtoken: " ",
      id: user.uid,
      isOnline: false ,
      lastActive: time,
      email: user.email,
      createdAt: time
  );
  await firestore1.collection('user').doc(user.uid).set(chatuser.toJson());
}

//getting all user data
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser(){
    return firestore1.collection('user').where('id', isNotEqualTo: user.uid).snapshots();
  }
  
  //for storing selfinfo
  static late ChatUser me;
  
  //getting current user data
  static Future<void> selfInfo() async {
    await firestore1.collection('user').doc(user.uid).get().then((value) async {
      if(value.exists){
        me=ChatUser.fromJson(value.data());
      }else{
        await newUser().then((onValue)=>selfInfo());
      }
    });
  }
}