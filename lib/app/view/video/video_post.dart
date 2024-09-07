

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_task/app/utils/Api.dart';

class VideoPost extends StatefulWidget {
  const VideoPost({super.key});

  @override
  State<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost> {
  File ? _selectedVideo;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Video"),),
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
                      child: const Text("Pick Video From Gallery",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),),
                      onPressed: () {
                        _pickVideoFromGallery();
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 15),
                  child: const SizedBox(height: 5,),
                ),
                _selectedVideo != null ? Image.file(_selectedVideo!) : const Text("Please Select Video"),
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
                        if (_selectedVideo != null) {

                         var Upload =  await postDta("Video", _selectedVideo);
                         if(Upload){
                           ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(content: Text("Video Uploaded Successful"),
                               backgroundColor: Colors.green,
                             ),
                           );
                         }else{
                           ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(content: Text("Oops something went wrong to upload video"),
                               backgroundColor: Colors.red,
                             ),
                           );
                         }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("No video selected!"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          print("No video selected");
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

  Future _pickVideoFromGallery() async{
    final returnedImage = await ImagePicker().pickVideo(source: ImageSource.gallery);
    // final returnedImage = await ImagePicker().pickVideo(source: ImageSource.gallery);
    // final hello = await ImagePicker().pickVideo(source: source)
    setState(() {
      _selectedVideo = File(returnedImage!.path);
    });
  }
}
