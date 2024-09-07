

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../utils/Api.dart';

class TextPost extends StatefulWidget {
  const TextPost({super.key});

  @override
  State<TextPost> createState() => _TextPostState();
}

class _TextPostState extends State<TextPost> {
  final TextEditingController textController = TextEditingController();
  final ContentType contentType = ContentType.text;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Text"),),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 175.0, bottom: 20),
                child: Center(
                  child: SizedBox(
                    child: Text(
                      'Text',
                      style: TextStyle(color: Colors.black, fontSize: 30),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 15),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: textController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Text',
                      hintText: 'Enter your text'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter text';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                height: 60,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Text Added Successful"),
                          backgroundColor: Colors.green,
                        ),
                      );
                      AddText();
                      print("succesful");

                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Filed Required!"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      print("failed");
                    }
                  },
                  child: Text(
                    'Sumbit',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future AddText() async {
    // var APIURL = Uri.parse("https://pk.code-hint.in/admin/Mobileapi/contentAdd");
    //
    // Map mappeddate = {
    //   'content_type' : "Text",
    //   'content': textController.text,
    // };
    // print("Json Data: ${mappeddate}");
    //
    // http.Response reponse = await http.post(APIURL as Uri, body: mappeddate);
    //
    // var data = jsonDecode(reponse.body);
    // print("Data:${data}");
    postDataImage("Text",textController.text);
  }

}
