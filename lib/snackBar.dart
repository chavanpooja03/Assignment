import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(content)),
  );
}

pickImage(BuildContext context) async {
  File? image;
  try {
    XFile? _file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (_file != null) {
      return await _file.readAsBytes();
    }
  } catch (e) {
    showSnackBar(context, e.toString());
  }
  return image;
}
