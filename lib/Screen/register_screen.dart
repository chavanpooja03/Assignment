import 'dart:typed_data';
import 'package:assignment/Screen/Home_page.dart';
import 'package:assignment/Screen/OTP_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:assignment/snackBar.dart';
import 'package:assignment/resources.dart';

class UserInfoScreen extends StatefulWidget {
  String phoneNumber;
  UserInfoScreen({required this.phoneNumber, super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  Uint8List? _image;
  String? imgUrl;
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  void selectImage() async {
    Uint8List img = await pickImage(context);
    setState(() {
      _image = img;
    });
  }

  void verifyUser(String phoneNumber) async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: widget.phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) {},
          verificationFailed: (FirebaseAuthException e) {
            showSnackBar(context, e.toString());
          },
          codeSent: (String verificationid, int? resendToken) {
            uploadData();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => confirmPage(
                      phoneNo: widget.phoneNumber,
                      verificationId: verificationid)),
            );
          },
          codeAutoRetrievalTimeout: (String verificationid) {});
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InkWell(
                    onTap: () => selectImage(),
                    child: _image == null
                        ? const CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 50.0,
                            child: Icon(
                              Icons.account_circle,
                              size: 50,
                              color: Colors.white,
                            ),
                          )
                        : CircleAvatar(
                            backgroundImage: MemoryImage(_image!),
                            radius: 200,
                            // Add fit property to control the image aspect ratio
                            backgroundColor: Colors.transparent,
                            foregroundImage: Image.memory(
                              _image!,
                              fit: BoxFit.cover,
                            ).image,
                          ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter name",
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: bioController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Bio",
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        verifyUser(widget.phoneNumber);
                      },
                      child: Text('Continue'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void uploadData() async {
    String url =
        await StoreData().UploadImageToStorage(widget.phoneNumber, _image!);
    await StoreData().saveData(
        name: nameController.text,
        bio: bioController.text,
        url: url,
        phoneNumber: widget.phoneNumber);
  }
}
