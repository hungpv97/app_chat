import 'dart:io';

import 'package:app_chat/models/chat_user.dart';
import 'package:app_chat/models/message.dart';
import 'package:app_chat/widgets/message_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../api/APIs.dart';
import '../main.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
//for storing all messages
  List<Message> _list = [];
  //for handling message text changes
  final _textController = TextEditingController();
  //for storing value of showing or hiding emoji
  bool _showEmoji = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          //if search is on & back button is pressed then close search
          //or else simple close current screen on back button click
          onWillPop: () {
            if (_showEmoji) {
              setState(() {
                _showEmoji = !_showEmoji;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
            ),
            backgroundColor: Color.fromARGB(255, 238, 245, 250),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: APIs.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        //if data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return SizedBox();
                        //some or all data is loader then show it
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          _list = data
                                  ?.map((e) => Message.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                                itemCount: _list.length,
                                padding: EdgeInsets.only(top: mq.height * .01),
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return MessageCard(
                                    message: _list[index],
                                  );
                                });
                          } else {
                            return Center(
                              child: Text(
                                'eroor',
                                style: TextStyle(fontSize: 20),
                              ),
                            );
                          }
                      }
                    },
                  ),
                ),
                _chatInput(),
                //show emojis on keyboard emoji button click & vice versa
                if (_showEmoji)
                  SizedBox(
                    height: mq.height * .35,
                    child: EmojiPicker(
                      textEditingController: _textController,
                      config: Config(
                        bgColor: Color.fromARGB(255, 238, 245, 250),
                        columns: 8,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: mq.height * .01, horizontal: mq.width * .025),
        child: Row(
          children: [
            //back button
            IconButton(
                onPressed: () => Navigator.pop(context),
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
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //user name
                Text(
                  widget.user.name,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
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
        ),
      ),
    );
  }

//bottom chat input field
  Widget _chatInput() {
    return Row(
      children: [
        //input field & button
        Expanded(
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                // emoji button
                IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() => _showEmoji = !_showEmoji);
                    },
                    icon: Icon(
                      Icons.emoji_emotions,
                      color: Colors.blueAccent,
                      size: 25,
                    )),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: () {
                      if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
                    },
                    decoration: InputDecoration(
                      hintText: 'Type Something',
                      hintStyle: TextStyle(color: Colors.blueAccent),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                // emoji button
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.image,
                      color: Colors.blueAccent,
                      size: 26,
                    )),
                // emoji button
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.blueAccent,
                      size: 26,
                    )),
                SizedBox(
                  width: mq.width * .02,
                ),
              ],
            ),
          ),
        ),

        //send message button
        MaterialButton(
          onPressed: () {
            if (_textController.text.isNotEmpty) {
              APIs.sendMessage(widget.user, _textController.text);
              _textController.text = '';
            }
          },
          minWidth: 0,
          padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
          shape: CircleBorder(),
          color: Colors.green,
          child: Icon(
            Icons.send,
            color: Colors.white,
            size: 28,
          ),
        )
      ],
    );
  }
}
