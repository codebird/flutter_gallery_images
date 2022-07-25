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
    // If some images are base64 you can send them in this dictionary where the key
    // is the same as images dictionary and the value is the base64 string
    Map<String, String> imagesBase64 = {'feed8.jpg': 'Some BASE64 string'};
    Map<String, Widget> imagesChildren = {
      'feed8.jpg': Container(
        child: Text('Play as you like'),
      )
    };
    Map<String, Alignment> childrenAlignment = {
      'feed8.jpg': Alignment.bottomCenter
    };

    void callbackFunctionName(String newPath) {
      //Do something with the imagePath newPath
    }

    return SafeArea(
      child: Gallery(
              buildContext: context,
              imageWithSizesMap: images,
              imagesBase64: imagesBase64, // send base64 images here (optional)
              imagesChildren:
                  imagesChildren, // if you need to add a layer above the image, a title or something (optional)
              childrenAlignment:
                  childrenAlignment, // if children are provided, alignment can be controlled, default Alignment.bottomCenter (optional)
              totalSidesPadding:
                  48, // Sum of the left and right padding if any, defaults to 0
              callBack:
                  //callback function will be called with a String of the path of the clicked image,
                  // if the image is base64, the base 64 string will be sent to the callback
                  callbackFunctionName)
          .galleryImages(
              imagesPerRow: imagesPerRow,
              pathOrUrl: 'lib/assets/images/',
              localOrRemote: 'local'),
    );
  }
}
