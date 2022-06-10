import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:images_gallery/images_gallery.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  int imagesPerRow = 2;
  double currentScale = 1;
  double updatedScale = 1;
  @override
  Widget build(BuildContext context) {
    Map<String, List<double>> images = {
      'feed8.jpg': [4032, 3024],
      'feed1.jpg': [3024, 4032],
      'feed2.jpg': [3024, 4032],
      'feed3.jpg': [3024, 3024],
      'feed4.jpg': [4032, 1816],
      'feed5.jpg': [3024, 3024],
      'feed6.jpg': [3024, 3024],
      'feed7.jpg': [3024, 3024],
    };
    return SafeArea(
      child: Gallery(buildContext: context, imageWithSizesMap: images)
          .galleryImages(
              imagesPerRow: imagesPerRow,
              pathOrUrl: 'lib/assets/images/',
              localOrRemote: 'local'),
    );
  }
}
