import 'package:assignment/postWidget.dart';
import 'package:assignment/snackBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:assignment/postWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Homes Page',
        ),
      ),
      body: CustomScrollView(
        slivers: [
          StreamBuilder(
              stream: _firebaseFirestore
                  .collection('videos')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                print('snapshot:$snapshot');
                return SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    try {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error:${snapshot.error}'),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasData && snapshot.data != null) {
                        return PostWidget(snapshot.data!.docs[index].data());
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    } catch (e) {
                      showSnackBar(context, e.toString());
                    }
                  },
                  childCount:
                      snapshot.data == null ? 0 : snapshot.data!.docs.length,
                ));
              })
        ],
      ),
    );
  }
}
