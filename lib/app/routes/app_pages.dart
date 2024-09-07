import 'package:flutter/material.dart';
import 'package:project_task/app/view/home/text_list.dart';
import 'package:project_task/app/view/home/text_post.dart';
import 'package:project_task/app/view/image/image_list.dart';
import 'package:project_task/app/view/image/image_post.dart';
import 'package:project_task/app/view/video/video_post.dart';

import '../view/video/video_list.dart';
import 'app_routes.dart';

class AppPages {
  static Map<String, WidgetBuilder> routes = {
    Routes.homeRoute: (context) => const Home(),
    Routes.textRoute: (context) => const TextPost(),
    Routes.imagePostRoute: (context) => const ImagePost(),
    Routes.videoPostRoute: (context) => const VideoPost(),
    Routes.imageListRoute: (context) => const ImageList(),
    Routes.videoListRoute: (context) => const VideoList(),

  };
}