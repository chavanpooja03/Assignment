import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'snackBar.dart';
import 'package:uuid/uuid.dart';

final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class StoreData {
  Future<String> UploadImageToStorage(String ChildName, Uint8List file) async {
    Reference ref = _firebaseStorage.ref().child(ChildName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> UploadVedioToStorage(String videoUrl) async {
    Reference ref = _firebaseStorage.ref().child(videoUrl);
    await ref.putFile(File(videoUrl));
    String videoURL = await ref.getDownloadURL();
    return videoURL;
  }

  Future<void> saveVideoData(String videoDownloadUrl, String name) async {
    var uid = Uuid().v4();
    await _firestore.collection('videos').doc(uid).set({
      'url': videoDownloadUrl,
      'timeStamps': FieldValue.serverTimestamp(),
      'name': 'User Video'
    });
  }

  Future<bool> saveData(
      {required String name,
      required String bio,
      required String url,
      required String phoneNumber}) async {
    try {
      await _firestore.collection('userProfile').doc(phoneNumber).set({
        'name': name,
        'bio': bio,
        'imageLink': url,
        'phoneNUmber': phoneNumber
      });
      print("Data saved successfully");
    } on FirebaseAuthException catch (e) {
      print("Error in saving firebase data:$e");
      return false;
    }
    return true;
  }
}
