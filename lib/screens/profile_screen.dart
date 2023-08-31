import 'dart:developer';
import 'dart:io';

import 'package:app_chat/helper/dialogs.dart';
import 'package:app_chat/models/chat_user.dart';
import 'package:app_chat/screens/auth/login_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import '../api/APIs.dart';
import '../main.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        //app bar
        appBar: AppBar(
          title: Text(
            'Profile',
          ),
        ),
        // floating button to add new user
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.red,
            onPressed: () async {
              //showing progress dialog
              Dialogs.showProgressBar(context);
await APIs.updateActiveStatus(false);

              //sign out from app
              await APIs.auth.signOut().then((value) async {
                await GoogleSignIn().signOut();
                //for hiding process dialog
                Navigator.pop(context);
                //moving to home screen
                Navigator.pop(context);
                APIs.auth=FirebaseAuth.instance;
                // replacing home screen with login screen
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => LoginScreen()));
              });
            },
            icon: Icon(Icons.logout),
            label: Text('Logout'),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //adding some space
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .03,
                  ),
                  //user profile picture
                  Stack(
                    children: [
                      //profile image
                      _image != null
                          ?
                          //local image
                          ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * .1),
                              child: Image.file(
                                File(_image!),
                                width: mq.height * .2,
                                height: mq.height * .2,
                                fit: BoxFit.cover,
                              ),
                            )
                          :
                          //image from server
                          ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * .1),
                              child: CachedNetworkImage(
                                width: mq.height * .2,
                                height: mq.height * .2,
                                fit: BoxFit.fill,
                                imageUrl: widget.user.image,
                                // placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    CircleAvatar(
                                        child: Icon(CupertinoIcons.person)),
                              ),
                            ),
                      //edit image button
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          elevation: 1,
                          onPressed: () {
                            _showBottomSheet();
                          },
                          shape: CircleBorder(),
                          color: Colors.white,
                          child: Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                        ),
                      )
                    ],
                  ),
                  //adding some space
                  SizedBox(
                    height: mq.height * .03,
                  ),
                  Text(
                    widget.user.email,
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  SizedBox(
                    height: mq.height * .05,
                  ),
                  //name input field
                  TextFormField(
                    initialValue: widget.user.name,
                    //check text
                    onSaved: (val) => APIs.me.name = val ?? "",
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    //form info
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      hintText: 'hus hus',
                      label: Text('Name'),
                    ),
                  ),
                  SizedBox(
                    height: mq.height * .02,
                  ),
                  //about input button
                  TextFormField(
                    initialValue: widget.user.about,
                    //check text
                    onSaved: (val) => APIs.me.name = val ?? "",
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    //form info
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.info_outline,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      hintText: 'about',
                      label: Text('about'),
                    ),
                  ),
                  SizedBox(
                    height: mq.height * .04,
                  ),
                  //update profile button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        minimumSize: Size(mq.width * .5, mq.height * .06)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        APIs.updateUserInfo().then((value) {
                          Dialogs.showSnackbar(
                              context, 'profile Updated Successfully');
                        });
                      }
                    },
                    icon: Icon(
                      Icons.edit,
                      size: 28,
                    ),
                    label: Text(
                      'Update',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .02, bottom: mq.height * .05),
            children: [
              //pick profile picture label
              Text(
                'Pick profile picture',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: mq.height * .02,
              ),
              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //pick from gallery button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        //pick an image
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery,imageQuality: 80);
                        if (image != null) {
                          log('image Path: ${image.path}-- MimeType: ${image.mimeType}');
                          setState(() {
                            _image = image.path;
                          });
                          APIs.updateProfilePicture(File(_image!));

                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/photo.png')),
                  //take picture from camera button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        //pick an image
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera,imageQuality: 80);
                        if (image != null) {
                          log('image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });
                           APIs.updateProfilePicture(File(_image!));

                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/camera.png')),
                ],
              )
            ],
          );
        });
  }
}
