import 'package:app_chat/widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../api/APIs.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar
      appBar: AppBar(
        leading: Icon(CupertinoIcons.home),
        title: Text(
          'We Chat',
        ),
        actions: [
          //search user button
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          //more features button
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
      // floating button to add new user
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: () async {

            await APIs.auth.signOut();
            await GoogleSignIn().signOut();
          },
          child: Icon(Icons.add_comment_rounded),
        ),
      ),
    body: ListView.builder(
      itemCount: 16,
      padding: EdgeInsets.only(top: mq.height* .01),
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index){
      return ChatUserCard();
    }),
    );
  }
}
