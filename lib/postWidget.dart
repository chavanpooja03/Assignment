import 'package:flutter/material.dart';
import 'UploadForm.dart';

class PostWidget extends StatelessWidget {
  final snapshot;
  PostWidget(this.snapshot, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 375,
          height: 54,
          color: Colors.white,
          child: ListTile(
            title: Text(
              snapshot['name'] ?? '',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
