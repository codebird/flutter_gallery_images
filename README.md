Working on an app of mine, I needed a way to display images in a masonry style. Additionally I needed
the display to change based on how big the user wants the thumbnails. I tried to make it as close 
as possible to Samsung's gallery display, since I find intuitive.

## Features

- Masonry style display when imagesPerRow is set to 2
- Can go up to 8 images per row, images will be cropped and resized accordingly.
- Can go down to 1 image, images will be displayed based on the width of the screen.
- Can load local images, by setting pathOrUrl to a local path, and setting localOrRemote to 'local'
- Can load network images, by setting pathOrUrl to a remote url, and setting localOrRemote to 'remote'

## Usage

```dart
// Define a Map with String image name and List<double> of image width x height
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

// Include this in the child of something else.
Gallery(
buildContext: context,
imageWithSizesMap: images,
totalSidesPadding: 48,// Sum of the left and right padding if any, defaults to 0
)
.galleryImages(
imagesPerRow: imagesPerRow, pathOrUrl: 'lib/assets/images/', localOrRemote: 'local'),

```

