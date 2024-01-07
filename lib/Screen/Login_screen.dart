import 'package:assignment/Screen/OTP_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneContoller = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  String phoneNo = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 100,
                  width: double.infinity,
                  child: Image.asset(
                    'images/Blackcofffer.jpg',
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: _phoneContoller,
                  decoration: InputDecoration(
                    labelText: "Enter mobile Number",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.verifyPhoneNumber(
                            verificationCompleted:
                                (PhoneAuthCredential credential) {},
                            verificationFailed: (FirebaseAuthException e) {},
                            codeSent:
                                (String verificationid, int? resendtoken) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => confirmPage(
                                          phoneNo:
                                              _phoneContoller.text.toString(),
                                          verificationId: verificationid)));
                            },
                            codeAutoRetrievalTimeout:
                                (String verificationid) {},
                            phoneNumber: _phoneContoller.text.toString());
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text('Next')),
                TextButton(
                  onPressed: () {},
                  child: Text('Already have an account?Login'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
