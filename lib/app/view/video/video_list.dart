import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project_task/app/view/video/video_post.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

import '../../utils/Api.dart';

class VideoList extends StatefulWidget {
  const VideoList({super.key});

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  int currentPageIndex = 2;
  List<dynamic> _videoList = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    var data = await getData('video');  // data is now a List<dynamic>
    setState(() {
      _videoList = data;  // Assign the fetched data to _items
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video List'),
      ),
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
      body: _videoList.isEmpty

          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(

        itemCount: _videoList.length,
        itemBuilder: (context, index) {
          var video = _videoList[index];
          print("https://pk.code-hint.in/${video['content']}");
          return VideoCard(videoUrl: "https://pk.code-hint.in/${video['content']}");
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VideoPost()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class VideoCard extends StatefulWidget {
  final String videoUrl;

  const VideoCard({super.key, required this.videoUrl});

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white70,
      elevation: 8.0,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          _controller.value.isInitialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
              : const Center(child: CircularProgressIndicator()),

          // Play / Pause button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isPlaying ? _controller.pause() : _controller.play();
                    _isPlaying = !_isPlaying;
                  });
                },
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.black,
                ),
              ),
              // General Share Icon
              IconButton(
                onPressed: () {
                  // Handle general sharing
                },
                icon: const Icon(Icons.share, color: Colors.blue),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
