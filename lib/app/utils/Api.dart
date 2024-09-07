import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';  // For getting the file name
import 'package:http/http.dart' as http;


Future<void> postDataImage(String contentType, dynamic content) async {
  // print("textController.text$content");
  // return;
  var headers = {
    'Cookie': 'ci_session=3udblla2og2sv32tvrtsr1oeekpnhl56'
  };
  var request = http.MultipartRequest(
      'POST', Uri.parse('https://pk.code-hint.in/admin/Mobileapi/contentAdd'));
  if((contentType == "Video") ||(contentType == "Image")){
    print("hello iam in");
    request.fields.addAll({
      'contentType': contentType
    });
    File file = File(content);  // content should be a file path
    request.files.add(await http.MultipartFile.fromPath(
        'content',
      file.path,
      filename: basename(file.path)
    ));
  }else{
    print("hello iam out");
    request.fields.addAll({
      'content': content,
      'content_type': contentType
    });
  }

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  }
  else {
    print(response.reasonPhrase);
  }
}



 postDta(String contentType, File? file) async {
  if (file == null) {
    print("No file selected");
    return;
  }

  var headers = {
    'Cookie': 'ci_session=3udblla2og2sv32tvrtsr1oeekpnhl56'
  };

  var request = http.MultipartRequest('POST', Uri.parse('https://pk.code-hint.in/admin/Mobileapi/contentAdd'));

  request.fields['content_type'] = contentType; // Add the content type (image, text, etc.)

  // Add the file to the request
  request.files.add(await http.MultipartFile.fromPath(
    'content',  // This key should match the expected key on the server
    file.path,
    filename: basename(file.path),  // Get the file name
  ));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  } else {
    print(response.reasonPhrase);
  }
}

getData(String ContentType) async {
  if(ContentType == null){
    return;

  }
  var headers = {
    'Cookie': 'ci_session=d87f9v7scro6v3hrteep3vm0um96s34s'
  };
  var request = http.Request('GET', Uri.parse('https://pk.code-hint.in/admin/Mobileapi/getTask/$ContentType'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {

    // print(await response.stream.bytesToString());
    var responseBody = await response.stream.bytesToString();
    var data = jsonDecode(responseBody);

    // Assuming the data is a list of items
    return data;
  }
  else {
    print(response.reasonPhrase);
  }

}