import 'package:assignment/Navigation.dart';
import 'package:assignment/entry_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:assignment/Screen/Home_page.dart';
import 'package:assignment/Screen/Login_screen.dart';
import 'package:assignment/snackBar.dart';

class confirmPage extends StatefulWidget {
  String phoneNo;
  String verificationId;
  confirmPage({super.key, required this.phoneNo, required this.verificationId});

  @override
  State<confirmPage> createState() => _confirmPageState();
}

class _confirmPageState extends State<confirmPage> {
  final TextEditingController _OTPcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                height: 100.0,
                width: 100,
                child: Image.asset('images/Blackcofffer.jpg')),
            SizedBox(
              height: 10.0,
            ),
            Text("otp is sent to ${widget.phoneNo}"),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              controller: _OTPcontroller,
              decoration: InputDecoration(
                labelText: "Enter the OTP",
                border: OutlineInputBorder(),
              ),
            ),
            TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.verifyPhoneNumber(
                      verificationCompleted:
                          (PhoneAuthCredential credential) {},
                      verificationFailed: (FirebaseAuthException e) {},
                      codeSent: (String verificationid, int? resendtoken) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => confirmPage(
                                      verificationId: widget.verificationId,
                                      phoneNo: widget.phoneNo,
                                    )));
                      },
                      codeAutoRetrievalTimeout: (String verificationid) {},
                      phoneNumber: widget.phoneNo);
                },
                child: Text(
                  'Did not get otp,resend?',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                )),
            ElevatedButton(
                onPressed: () async {
                  try {
                    PhoneAuthCredential credential =
                        await PhoneAuthProvider.credential(
                            verificationId: widget.verificationId,
                            smsCode: _OTPcontroller.text.toString());
                    FirebaseAuth.instance
                        .signInWithCredential(credential)
                        .then((value) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    });
                  } catch (e) {
                    showSnackBar(context, e.toString());
                  }
                },
                child: Text(
                  'Get Started',
                )),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => entryPage()));
              },
              child: Text('Back'),
            )
          ],
        ),
      ),
    ));
  }
}
