import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function(File pickedImage) imagePickedFn;
  const UserImagePicker(this.imagePickedFn);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _storedImage;
  void _pickImage() async {
    final pickedImageFile = await ImagePicker.platform.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxHeight: 150,
        maxWidth: 150);
    if (pickedImageFile == null) {
      return;
    }
    setState(() {
      _storedImage = File(pickedImageFile.path);
    });
    widget.imagePickedFn(_storedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, 30),
      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
          child: CircleAvatar(
            radius: 60,
            child: Center(
              child: _storedImage != null
                  ? null
                  : Icon(
                      Icons.person_outlined,
                      size: 60,
                    ),
            ),
            backgroundImage:
                _storedImage == null ? null : FileImage(_storedImage!),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 12,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.amber,
            ),
            child: IconButton(
              onPressed: _pickImage,
              icon: Icon(
                Icons.camera_alt,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
