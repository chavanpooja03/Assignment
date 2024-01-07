import 'package:assignment/Screen/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'snackBar.dart';
import 'Screen/OTP_screen.dart';

class entryPage extends StatefulWidget {
  const entryPage({super.key});

  @override
  State<entryPage> createState() => _entryPageState();
}

class _entryPageState extends State<entryPage> {
  bool isLoading = false;
  final TextEditingController phoneNo = TextEditingController();
  Country selectedCountry = Country(
      phoneCode: "91",
      countryCode: "IN",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "India",
      example: "India",
      displayName: "India",
      displayNameNoCountryCode: "IN",
      e164Key: "");
  @override
  Widget build(BuildContext context) {
    phoneNo.selection =
        TextSelection.fromPosition(TextPosition(offset: phoneNo.text.length));
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: phoneNo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                onChanged: (value) {
                  setState(() {
                    phoneNo.text = value;
                  });
                },
                decoration: InputDecoration(
                    labelText: "Enter mobile No",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.grey.shade500,
                    ),
                    border: OutlineInputBorder(),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(17.0),
                      child: Container(
                        child: InkWell(
                          onTap: () {
                            showCountryPicker(
                                context: context,
                                countryListTheme: CountryListThemeData(
                                  bottomSheetHeight: 500,
                                ),
                                onSelect: (value) {
                                  setState(() {
                                    selectedCountry = value;
                                  });
                                });
                          },
                          child: Text(
                            "${selectedCountry.flagEmoji}+${selectedCountry.phoneCode}",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    suffixIcon: phoneNo.text.length > 9
                        ? Container(
                            height: 30,
                            width: 30,
                            margin: const EdgeInsets.all(10.0),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                            child: const Icon(
                              Icons.done,
                              color: Colors.white,
                              size: 20,
                            ),
                          )
                        : null),
              ),
              SizedBox(
                height: 20.0,
              ),
              (isLoading)
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          final phoneNumber = phoneNo;
                          final doc_snapshot = await FirebaseFirestore.instance
                              .collection('userProfile')
                              .doc(phoneNumber.text.toString())
                              .get();
                          if (doc_snapshot.exists) {
                            await FirebaseAuth.instance.verifyPhoneNumber(
                                verificationCompleted:
                                    (PhoneAuthCredential credential) {},
                                verificationFailed:
                                    (FirebaseAuthException e) {},
                                codeSent:
                                    (String verificationid, int? resendtoken) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => confirmPage(
                                              phoneNo: phoneNo.text.toString(),
                                              verificationId: verificationid)));
                                },
                                codeAutoRetrievalTimeout:
                                    (String verificationid) {},
                                phoneNumber: phoneNo.text.toString());
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserInfoScreen(
                                        phoneNumber: phoneNo.text.toString(),
                                      )),
                            );
                          }
                          setState(() {
                            isLoading = false;
                          });
                        } catch (e) {
                          showSnackBar(context, e.toString());
                        }
                      },
                      child: Text(
                        'Login',
                      )),
              ElevatedButton(
                  onPressed: () {
                    _signOut(context);
                  },
                  child: Text('SignOut'))
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => entryPage()));
  } catch (e) {
    print("Error in signing in out:$e");
  }
}
