import 'package:app_chat/models/chat_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),
      ),
    );
  }

  Widget _appBar() {
    return Row(
      children: [
        //back button
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black54,
            )),
        //user profile picture
        ClipRRect(
          borderRadius: BorderRadius.circular(mq.height * .3),
          child: CachedNetworkImage(
            width: mq.height * .055,
            height: mq.height * .05,
            imageUrl: widget.user.image,
            // placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) =>
                CircleAvatar(child: Icon(CupertinoIcons.person)),
          ),
        ),
SizedBox(width: 10,),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.user.name,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
             'Last seen not available',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        )
      ],
    );
  }
}
