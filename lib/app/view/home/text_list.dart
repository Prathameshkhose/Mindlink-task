import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // For jsonDecode
import 'package:http/http.dart' as http;
import 'package:project_task/app/view/home/text_post.dart';
import 'package:project_task/app/view/image/image_list.dart';
import 'package:project_task/app/view/video/video_list.dart';
import 'package:share_plus/share_plus.dart';

import '../../utils/Api.dart';
import '../image/image_post.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
      routes: {
        '/': (context) => const Home(),
        // '/imageList': (context) => const ImageList(),
        // '/videoList': (context) => const VideoList(),
      },
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});


  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late AppLinks _appLinks;
  int currentPageIndex = 0;
  List<dynamic> _items = []; // Dynamic list to hold fetched data
  // bool _isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchData();
    _initDeepLinkHandling();
  }



  Future<void> _fetchData() async {
    var data = await getData('Text');  // data is now a List<dynamic>
    print(data);
    setState(() {
      _items = data;  // Assign the fetched data to _items
      // _isLoading = false;
    });
  }

  Future<void> _initDeepLinkHandling() async {
    _appLinks = AppLinks();

    // Handle app start with initial deep link


    // Handle deep links while the app is running
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleIncomingLink(uri);
      }
    });
  }

  void _handleIncomingLink(Uri uri) {
    print('Received deep link: $uri');
    // Handle navigation based on the incoming deep link
    if (uri.path == '/image') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ImageList()),
      );
    }else if(uri.path == '/video'){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VideoList()),
      );
    }else{
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    }
  }


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
            icon: Badge(child: Icon(Icons.photo)),
            label: 'Image',
          ),
          NavigationDestination(
            icon: Badge(
              child: Icon(Icons.video_camera_front),
            ),
            label: 'Video',
          ),
        ],
      ),
      body:
          ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          var item = _items[index]; // Each item from the API
          return Card(
            child: ListTile(
              leading: const Icon(Icons.notifications_sharp),
              title: Text(item['content'] ?? 'No Title'), // Assuming 'title' field in API
              subtitle: Text(item['content'] ?? 'No Description'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () async{
                      // Add general share logic here
                      //var webUrl = 'https://pk.code-hint.in/admin/Mobileapi/getTasks';
                      // if(webUrl){
                        await Share.share('${item['content']}');
                      // }
                    },
                    icon: const Icon(Icons.share),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TextPost()),
        );
      },
        child: const Icon(Icons.add),
      ),
    );
  }
}
