import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat/Auth/LoginScreen.dart';
import 'package:we_chat/screens/Profile_Screen.dart';
import 'package:we_chat/widgets/chat_user_card.dart';

import '../APIs/Apis.dart';
import '../Models/chat_user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //now it has all user
  late Stream<QuerySnapshot<Map<String, dynamic>>> AddedUser=Apis.getAllUser();


  late List<ChatUser> _list=[];

  //storing all user for search
  final List<ChatUser> _searchlist=[];

  //for storing search status
  bool _isSearching=false;

  @override
  void
  initState() {
    super.initState();
    Apis.selfInfo();
  }

  late Size mq;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    mq=MediaQuery.of(context).size;
    return GestureDetector(
      //hiding keyboard
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () {
          if(_isSearching){
            setState(() {
              _isSearching=!_isSearching;
            });
            return Future.value(false);
          }else{
            return Future.value(true);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey.shade300,
          key: _scaffoldKey,
          appBar: AppBar(
            //profile drawer
            leading: Padding(
              padding: const EdgeInsets.all(9.0),
              child: InkWell(
                onTap: (){
                  _scaffoldKey.currentState!.openDrawer();
                },
                child: CircleAvatar(
                  //radius: 18,
                  backgroundImage: NetworkImage("${FirebaseAuth.instance.currentUser?.photoURL}"),
                ),
              ),
            ),

            //App title and search textForm
            title: _isSearching? TextField(
              autofocus: true,
              cursorColor: Colors.black,
              style: TextStyle(fontSize: 16,letterSpacing: 0.4),
              decoration: InputDecoration(
                hintText: "Email, Name...",
                border: InputBorder.none,
              ),
              //tracing change
              onChanged: (val) {
                setState(() {
                  _searchlist.clear();
                  _searchlist.addAll(_list.where((user) =>
                  (user.name?.toLowerCase() ?? '').contains(val.toLowerCase()) ||
                      (user.email?.toLowerCase() ?? '').contains(val.toLowerCase())));
                });
              },
            ):Text("We Chat"),
            actions: [
              //search button
              IconButton(onPressed: (){
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) _searchlist.clear();
                });
              }, icon: Icon(_isSearching? Icons.close : Icons.search)),

              //three dot button
              IconButton(onPressed: (){}, icon: Icon(Icons.more_vert))
            ],
          ),

          //drawer elements
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.cyan),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage("${Apis.auth1.currentUser?.photoURL}"),
                      ),
                      Text("${Apis.auth1.currentUser?.displayName}", style: TextStyle(color: Colors.white, fontSize: 24)),
                    ],
                  )
                ),
                //profile
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=> ProfileScreen(user: Apis.me,)));
                    // Handle profile tap
                  },
                ),
                //setting
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () {
                    // Handle settings tap
                  },
                ),
                //Logout
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () async {
                    await Apis.auth1.signOut();
                    await GoogleSignIn().signOut();
                    // Navigate to login screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
              ],
            ),
          ),

          //to add the user
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: FloatingActionButton(
              onPressed: (){
                //Add members
              },
              child: Icon(Icons.add_comment_rounded),backgroundColor: Colors.cyan,),
          ),
          body: StreamBuilder(
              stream: AddedUser,
              builder: (context,snapshot){
                switch(snapshot.connectionState)
                {
                  //if data is loading
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                      return Center(child: CircularProgressIndicator(),);
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data=snapshot.data?.docs;
                    _list=data!.map((e)=> ChatUser.fromJson(e)).toList();
                }

                if(_list.isNotEmpty){
                  return ListView.builder(
                      padding: EdgeInsets.only(top: mq.height * 0.01),
                      physics: BouncingScrollPhysics(),
                      itemCount:_isSearching?_searchlist.length :_list.length,
                      itemBuilder: (context, index){
                        return ChatUserCard(user:_isSearching?_searchlist[index]: _list[index],);
                        //return Text("Name: ${list[index]}");
                      });
                }else{
                  return Center(child: Text("No Connection Found", style: TextStyle(fontSize: 20),));
                }
              })
        ),
      ),
    );
  }
}
