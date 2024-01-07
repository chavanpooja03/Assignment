import 'package:assignment/UploadForm.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:get/get.dart';

class addVideo extends StatefulWidget {
  const addVideo({super.key});

  @override
  State<addVideo> createState() => _addVideoState();
}

class _addVideoState extends State<addVideo> {
  getVideoFile(ImageSource sourceImg) async {
    XFile? videoFile = await ImagePicker().pickVideo(source: sourceImg);
    if (videoFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Uploadform(
                videoFile: File(videoFile.path), videoPath: videoFile.path)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add video'),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  getVideoFile(ImageSource.camera);
                },
                child: Text('Make a video')),
          ],
        ),
      ),
    );
  }
}
