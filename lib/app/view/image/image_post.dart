import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/Api.dart';

class ImagePost extends StatefulWidget {
  const ImagePost({super.key});

  @override
  State<ImagePost> createState() => _ImagePostState();
}

class _ImagePostState extends State<ImagePost> {

  File ? _selectedImage;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Image"),),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 10),
              child: Center(
                child: MaterialButton(
                  color: Colors.blue,
                  child: const Text("Pick Image From Gallery",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),),
                  onPressed: () {
                    _pickImageFromGallery();
                  },
                ),
              ),
            ),
           Padding(
             padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 15),
             child: const SizedBox(height: 5,),
           ),
            _selectedImage != null ? Image.file(_selectedImage!) : const Text("Please Select Image"),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 60,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                    onPressed: () async {
                      if (_selectedImage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Image Uploaded Successful"),
                            backgroundColor: Colors.green,
                          ),
                        );
                        await postDta("Image", _selectedImage);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("No Image selected!"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        print("No image selected");
                      }
                    },
                  child: Text(
                    'Sumbit',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
  Future _pickImageFromGallery() async{
  final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
  // final returnedImage = await ImagePicker().pickVideo(source: ImageSource.gallery);
  // final hello = await ImagePicker().pickVideo(source: source)
  setState(() {
    _selectedImage = File(returnedImage!.path);
  });
  }
}


