import 'dart:developer';
import 'dart:io';

import 'package:app_chat/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class APIs {
  // for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;
  //accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  //accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

//storing self information
  static late ChatUser me;
//return current user
  static User get user => auth.currentUser!;
// checking if user exists or not?
  static Future<bool> userExists() async {
    return (await firestore.collection("users").doc(user.uid).get()).exists;
  }

//getting current user info
  static Future<void> getSelfInfo() async {
    await firestore.collection("users").doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        log('my data: ${user.data()}');
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

//creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
        id: user.uid,
        name: user.displayName.toString(),
        email: user.email.toString(),
        about: 'hello',
        image: user.photoURL.toString(),
        createdAt: time,
        isOnline: false,
        lastActive: time,
        pushToken: '');
    return await firestore
        .collection("users")
        .doc(user.uid)
        .set(chatUser.toJson());
  }

//getting all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Future<void> updateUserInfo() async {
    await firestore.collection("users").doc(user.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }

  //update profile picture of user
  static Future<void> updateProfilePicture(File file) async {
    //getting image file extension
    final ext = file.path.split('pattern').last;
    log('extension: $ext');

    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');
    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('data Transferred: ${p0.bytesTransferred / 1000}kb');
    });
    //updating image in firestore database
    me.image = await ref.getDownloadURL();
    await firestore.collection("users").doc(user.uid).update({
      'image': me.image,
    });
  }
  /**********Chat Screen Related APIs **********/

  //for getting all messages of a specific conversation from firestore database
   static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages() {
    return firestore
        .collection('message')
        .snapshots();
  }
}
