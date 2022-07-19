library images_gallery;

import 'dart:convert';

import 'package:flutter/material.dart';

/// A Gallery Display.
class Gallery {
  late final BuildContext context;
  late final Map<String, List<double>> images;
  late final Map<String, String> imagesBase64;
  late final double remainingScreenWidth;
  late final Function? callBack;
  Gallery(
      {required BuildContext buildContext,
      required Map<String, List<double>> imageWithSizesMap,
      double totalSidesPadding = 0,
      this.imagesBase64 = const {},
      this.callBack}) {
    context = buildContext;
    images = imageWithSizesMap;
    remainingScreenWidth =
        MediaQuery.of(context).size.width - totalSidesPadding;
  }
  // This function is called if imagesPerRow isn't 2
  Widget _normalGalleryImages(
      {required Map<String, List<double>> images,
      required String pathOrUrl,
      String localOrRemote = 'local',
      int imagesPerRow = 3,
      double padding = 3}) {
    List<Widget> gallery = [];
    List<Widget> imageWidgets = [];
    // Get screen width and subtract the padding, to calculate image width
    double screenWithWithoutPadding =
        remainingScreenWidth - (imagesPerRow * 2 * padding);
    double width = (screenWithWithoutPadding) / imagesPerRow;
    double height = width;
    List<String> imageNames = images.keys.toList();
    for (int i = 0; i < imageNames.length; i++) {
      var thisImageSize = images[imageNames[i]];
      var imageWidget = Center(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Container(
            height: imagesPerRow > 1
                ? height
                : thisImageSize![1] /
                    (thisImageSize![0] / screenWithWithoutPadding),
            width: width,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: isVertical(thisImageSize!) || imagesPerRow == 1
                    ? BoxFit.fitWidth
                    : BoxFit.fitHeight,
                image: imagesBase64.keys.contains(imageNames[i])
                    ? MemoryImage(base64Decode(imagesBase64[imageNames[i]]!))
                    : localOrRemote == 'remote'
                        ? NetworkImage('$pathOrUrl${imageNames[i]}')
                        : AssetImage('$pathOrUrl${imageNames[i]}')
                            as ImageProvider,
              ),
            ),
          ),
        ),
      );
      if (callBack != null) {
        imageWidgets.add(GestureDetector(
          onTap: () {
            if (imagesBase64.keys.contains(imageNames[i])) {
              callBack!(imagesBase64[imageNames[i]]);
            } else {
              callBack!("$pathOrUrl${imageNames[i]}");
            }
          },
          child: imageWidget,
        ));
      } else {
        imageWidgets.add(imageWidget);
      }

      if ((i + 1) % imagesPerRow == 0) {
        gallery.add(Row(
          children: imageWidgets,
        ));
        imageWidgets = [];
      }
    }

    if (imageWidgets.isNotEmpty) {
      gallery.add(Row(
        children: imageWidgets,
      ));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: gallery,
      ),
    );
  }

  // This is the main function that will be called
  Widget galleryImages({
    required String pathOrUrl,
    String localOrRemote = 'local',
    int imagesPerRow = 2,
    double padding = 4,
  }) {
    localOrRemote = localOrRemote.toLowerCase();
    pathOrUrl = fixPathOrUrl(pathOrUrl);
    if (imagesPerRow != 2) {
      return _normalGalleryImages(
          images: images,
          imagesPerRow: imagesPerRow,
          padding: padding,
          pathOrUrl: pathOrUrl,
          localOrRemote: localOrRemote);
    }

    List<Widget> gallery = [];
    List<String> imageNames = images.keys.toList();

    localOrRemote = localOrRemote.toLowerCase();
    double totalHeight = MediaQuery.of(context).size.height;
    double calcTotalHeight = 0;
    int lastI = 0;
    double top = 0;
    double left = 0;
    double imagesHeight = 0;

    for (int i = 0; i < imageNames.length; i++) {
      if (i < imageNames.length - 1) {
        String currentImage = imageNames[i];
        String nextImage = imageNames[i + 1];
        List<double> positions =
            getPositioning(images[currentImage]!, images[nextImage]!);

        if (positions.length == 2) {
          imagesHeight =
              positions[1] / (images[currentImage]![0] / remainingScreenWidth);
          var imageWidget = Padding(
            padding: EdgeInsets.all(padding),
            child: imagesBase64.keys.contains(currentImage)
                ? Image.memory(base64Decode(imagesBase64[currentImage]!))
                : localOrRemote == 'remote'
                    ? Image.network(
                        '$pathOrUrl$currentImage',
                        fit: BoxFit.fill,
                      )
                    : Image.asset(
                        '$pathOrUrl$currentImage',
                        fit: BoxFit.fill,
                      ),
          );
          if (callBack != null) {
            gallery.add(
              Positioned(
                top: top,
                left: 0,
                width: remainingScreenWidth,
                height: imagesHeight,
                child: GestureDetector(
                  onTap: () {
                    if (imagesBase64.keys.contains(currentImage)) {
                      callBack!(imagesBase64[currentImage]);
                    } else {
                      callBack!("$pathOrUrl$currentImage");
                    }
                  },
                  child: imageWidget,
                ),
              ),
            );
          } else {
            gallery.add(
              Positioned(
                  top: top,
                  left: 0,
                  width: remainingScreenWidth,
                  height: imagesHeight,
                  child: imageWidget),
            );
          }
          top += imagesHeight;
        } else {
          var imageWidget = Padding(
            padding: EdgeInsets.all(padding),
            child: imagesBase64.keys.contains(currentImage)
                ? Image.memory(base64Decode(imagesBase64[currentImage]!))
                : localOrRemote == 'remote'
                    ? Image.network(
                        '$pathOrUrl$currentImage',
                        fit: BoxFit.fill,
                      )
                    : Image.asset(
                        '$pathOrUrl$currentImage',
                        fit: BoxFit.fill,
                      ),
          );
          if (callBack != null) {
            gallery.add(Positioned(
              top: top,
              left: 0,
              width: remainingScreenWidth * positions[0],
              height: positions[2],
              child: GestureDetector(
                onTap: () {
                  if (imagesBase64.keys.contains(currentImage)) {
                    callBack!(imagesBase64[currentImage]);
                  } else {
                    callBack!("$pathOrUrl$currentImage");
                  }
                },
                child: imageWidget,
              ),
            ));
          } else {
            gallery.add(
              Positioned(
                  top: top,
                  left: 0,
                  width: remainingScreenWidth * positions[0],
                  height: positions[2],
                  child: imageWidget),
            );
          }
          left = remainingScreenWidth * positions[0];
          imageWidget = Padding(
            padding: EdgeInsets.all(padding),
            child: imagesBase64.keys.contains(nextImage)
                ? Image.memory(base64Decode(imagesBase64[nextImage]!))
                : localOrRemote == 'remote'
                    ? Image.network(
                        '$pathOrUrl$nextImage',
                        fit: BoxFit.fill,
                      )
                    : Image.asset(
                        '$pathOrUrl$nextImage',
                        fit: BoxFit.fill,
                      ),
          );
          if (callBack != null) {
            gallery.add(Positioned(
              top: top,
              left: left,
              width: remainingScreenWidth * positions[1],
              height: positions[2],
              child: GestureDetector(
                onTap: () {
                  if (imagesBase64.keys.contains(nextImage)) {
                    callBack!(imagesBase64[nextImage]);
                  } else {
                    callBack!("$pathOrUrl$nextImage");
                  }
                },
                child: imageWidget,
              ),
            ));
          } else {
            gallery.add(
              Positioned(
                  top: top,
                  left: left,
                  width: remainingScreenWidth * positions[1],
                  height: positions[2],
                  child: imageWidget),
            );
          }
          left = 0;
          top += positions[2];
          calcTotalHeight += top;
          i++;
        }
      }
      lastI = i;
    }
    if (lastI == images.length - 1) {
      imagesHeight = images[imageNames.last]![1] /
          (images[imageNames.last]![0] / remainingScreenWidth);
      var imageWidget = imagesBase64.keys.contains(imageNames.last)
          ? Image.memory(base64Decode(imagesBase64[imageNames.last]!))
          : localOrRemote == 'remote'
              ? Image.network(
                  '$pathOrUrl${imageNames.last}',
                  fit: BoxFit.fill,
                )
              : Image.asset(
                  '$pathOrUrl${imageNames.last}',
                  fit: BoxFit.fill,
                );
      if (callBack != null) {
        gallery.add(Positioned(
          width: remainingScreenWidth,
          height: imagesHeight,
          top: top,
          left: 0,
          child: GestureDetector(
            onTap: () {
              if (imagesBase64.keys.contains(imageNames.last)) {
                callBack!(imagesBase64[imageNames.last]);
              } else {
                callBack!("$pathOrUrl${imageNames.last}");
              }
            },
            child: imageWidget,
          ),
        ));
      } else {
        gallery.add(
          Positioned(
            width: remainingScreenWidth,
            height: imagesHeight,
            top: top,
            left: 0,
            child: imageWidget,
          ),
        );
      }
      calcTotalHeight = top + imagesHeight;
    }
    gallery.add(Container(
      height: calcTotalHeight > totalHeight ? calcTotalHeight : totalHeight,
    ));

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Stack(
        children: gallery,
      ),
    );
  }

  List<double> getPositioning(List<double> size1, List<double> size2) {
    // sizes will contain the width of the 1st image, width of 2nd image, and
    // height of both images

    List<double> sizes = [1, size1[1]];

    if (isSquare(size1) && isSquare(size2) ||
        (isHorizontal(size1) && isHorizontal(size2)) ||
        (isVertical(size1) && isVertical(size2))) {
      double firstHeight = size1[1] / (size1[0] / (remainingScreenWidth / 2));
      double secondHeight = size2[1] / (size2[0] / (remainingScreenWidth / 2));

      return [
        0.5,
        0.5,
        firstHeight > secondHeight ? secondHeight : firstHeight
      ];
    }

    if ((isSquare(size1) || isHorizontal(size1)) && isVertical(size2)) {
      double firstHeight =
          size1[1] / (size1[0] / (remainingScreenWidth * 0.62));
      double secondHeight =
          size2[1] / (size2[0] / (remainingScreenWidth * 0.38));
      return [
        0.62,
        0.38,
        firstHeight > secondHeight ? secondHeight : firstHeight
      ];
    }

    if ((isSquare(size2) || isHorizontal(size2)) && isVertical(size1)) {
      double firstHeight =
          size1[1] / (size1[0] / (remainingScreenWidth * 0.38));
      double secondHeight =
          size2[1] / (size2[0] / (remainingScreenWidth / 0.62));
      return [
        0.38,
        0.62,
        firstHeight > secondHeight ? secondHeight : firstHeight
      ];
    }

    return sizes;
  }

  String fixPathOrUrl(String pathOrUrl) {
    if (pathOrUrl.substring(pathOrUrl.length - 1) != '/') {
      pathOrUrl += '/';
    }
    return pathOrUrl;
  }

  bool isSquare(List<double> size) => size[0] == size[1];

  bool isHorizontal(List<double> size) => size[0] > size[1];

  bool isVertical(List<double> size) => size[0] < size[1];
}
