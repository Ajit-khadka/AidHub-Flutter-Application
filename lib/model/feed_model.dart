import 'dart:io';

import 'dart:typed_data';

class FeedMediaModel {
  File? image;
  File? video;
  bool? isVideo;
  Uint8List? thumbnail;
  FeedMediaModel({this.image, this.video, this.isVideo, this.thumbnail});
}
