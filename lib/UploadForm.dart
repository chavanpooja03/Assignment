import 'package:assignment/Screen/Home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'resources.dart';

class Uploadform extends StatefulWidget {
  final File videoFile;
  final String videoPath;
  Uploadform({required this.videoFile, required this.videoPath});

  @override
  State<Uploadform> createState() => _UploadformState();
}

class _UploadformState extends State<Uploadform> {
  VideoPlayerController? _controller;
  bool isLoading = false;
  String? _videoURl;
  final TextEditingController name = TextEditingController();

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  void _initVideoPlayer() {
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {
          _controller!.play();
        });
      });
  }

  Widget _videoPreviewWidget() {
    if (_controller != null) {
      return AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: VideoPlayer(_controller!),
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 65,
                height: 65,
                child: _videoPreviewWidget(),
              ),
              TextFormField(
                controller: name,
                decoration: InputDecoration(
                  labelText: "Enter the Name",
                  border: OutlineInputBorder(),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  String? _videoURl = await StoreData().UploadVedioToStorage(
                    widget.videoPath,
                  );
                  await StoreData().saveVideoData(_videoURl, name.text);

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                  // Add your logic for video upload here
                },
                child: Text('Upload Video'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
