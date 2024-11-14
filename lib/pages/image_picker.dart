import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerPage extends StatefulWidget {
  const ImagePickerPage({super.key});

  @override
  State<ImagePickerPage> createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  Future<void> getImageFromCamera() async {
    await requestPermissions();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  Future<void> requestPermissions() async {
    if (await Permission.camera.isDenied) {
      await Permission.camera.request();
    }
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.blueAccent.withOpacity(0.6),
        centerTitle: true,
        title: Text(
          "Image Picker",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: _image == null
                ? Text(
                    "No Image Selected!",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Image.file(
                        height: MediaQuery.of(context).size.height * 0.5,
                        File(_image!.path),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
          ),
          SizedBox(
            height: 25,
          ),
          _image != null
              ? OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _image = null;
                    });
                  },
                  child: Icon(
                    CupertinoIcons.delete,
                    color: Colors.red,
                  ),
                )
              : Container(),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: getImage,
                  backgroundColor: Colors.blue.withOpacity(0.6),
                  child: Icon(
                    Icons.image,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 16),
                FloatingActionButton(
                  onPressed: getImageFromCamera,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.camera_alt),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
