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
  late final Stream<QuerySnapshot<Map<String, dynamic>>> addedUser = Apis.getAllUser();

  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];

  bool _isSearching = false;
  late Size mq;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _initSelfInfo();
  }

  Future<void> _initSelfInfo() async {
    await Apis.selfInfo(); // Ensure Apis.me is set
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async {
          if (_isSearching) {
            setState(() {
              _isSearching = false;
              _searchList.clear();
            });
            return false;
          }
          return true;
        },
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.grey.shade300,
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(9.0),
              child: InkWell(
                onTap: () => _scaffoldKey.currentState?.openDrawer(),
                child: CircleAvatar(
                  backgroundImage: FirebaseAuth.instance.currentUser?.photoURL != null
                      ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)
                      : const AssetImage('assets/images/default.png') as ImageProvider,
                ),
              ),
            ),
            title: _isSearching
                ? TextField(
              autofocus: true,
              cursorColor: Colors.black,
              style: const TextStyle(fontSize: 16, letterSpacing: 0.4),
              decoration: const InputDecoration(
                hintText: "Email, Name...",
                border: InputBorder.none,
              ),
              onChanged: (val) {
                setState(() {
                  _searchList.clear();
                  _searchList.addAll(_list.where((user) =>
                  (user.name?.toLowerCase() ?? '').contains(val.toLowerCase()) ||
                      (user.email?.toLowerCase() ?? '').contains(val.toLowerCase())));
                });
              },
            )
                : const Text("We Chat"),
            actions: [
              //for search
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                      if (!_isSearching) _searchList.clear();
                    });
                  },
                  icon: Icon(_isSearching ? Icons.close : Icons.search)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: Colors.cyan),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: Apis.auth1.currentUser?.photoURL != null
                            ? NetworkImage(Apis.auth1.currentUser!.photoURL!)
                            : const AssetImage('assets/images/default.png') as ImageProvider,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Apis.auth1.currentUser?.displayName ?? 'Guest',
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => ProfileScreen(user: Apis.me!),
                      ),
                    );
                                    },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () async {
                    await Apis.auth1.signOut();
                    await GoogleSignIn().signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: FloatingActionButton(
              onPressed: () {
                // Add members logic
              },
              backgroundColor: Colors.cyan,
              child: const Icon(Icons.add_comment_rounded),
            ),
          ),
          body: StreamBuilder(
            stream: addedUser,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());

                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  print(data);
                  if (data == null || data.isEmpty) {
                    return const Center(child: Text("No users found"));
                  }

                  _list = data.map((e) => ChatUser.fromJson(e.data())).toList();

                  return ListView.builder(
                    padding: EdgeInsets.only(top: mq.height * 0.01),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _isSearching ? _searchList.length : _list.length,
                    itemBuilder: (context, index) {
                      return ChatUserCard(
                        user: _isSearching ? _searchList[index] : _list[index],
                      );
                    },
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
