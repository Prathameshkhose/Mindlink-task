import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../utils/Api.dart';
import 'image_post.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';


class ImageList extends StatefulWidget {
  const ImageList({super.key});

  @override
  State<ImageList> createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {

  List<dynamic> _items = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    var data = await getData('Image');  // data is now a List<dynamic>
    setState(() {
      _items = data;  // Assign the fetched data to _items
    });
  }



  int currentPageIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("App")),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });

          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/imageList');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/videoList');
          }
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.photo),
            label: 'Image',
          ),
          NavigationDestination(
            icon: Icon(Icons.video_camera_front),
            label: 'Video',
          ),
        ],
      ),
      body: _items.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          var item = _items[index];
          print("https://pk.code-hint.in/${item['content']}");
          return Card(
            color: Colors.white70,
            elevation: 8.0,
            margin: const EdgeInsets.all(8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),

                  child: Image.network(

                    "https://pk.code-hint.in/${item['content']}", // Replace with actual image URL from API
                    height: MediaQuery.of(context).size.width * (3 / 4),
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                Row(
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(
                          left: 170.0, right: 30.0, bottom: 10.0),
                      child: IconButton(
                        onPressed: () async{
                          // Parse the image URL
                          final uri = Uri.parse("https://code-hint.in/${item['content']}");


                          final res = await http.get(uri);
                          final bytes = res.bodyBytes;

                          final tempDir = await getTemporaryDirectory();

                          final filePath = '${tempDir.path}/image.jpg';

                          File(filePath).writeAsBytesSync(bytes);

                          await Share.shareXFiles([XFile(filePath)]);
                        },
                        icon: const Icon(Icons.share,color: Colors.redAccent,),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ImagePost()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
