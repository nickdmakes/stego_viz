import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

import 'dart:convert';

// Function that turns an asset image into a base64 byte string
Future<String> imageToBase64(String path) async {
  final bytes = await rootBundle.load(path);
  return base64Encode(Uint8List.view(bytes.buffer));
}

// Function that turns Uint8List into a base64 byte string
String bytesToBase64(Uint8List bytes) {
  return base64Encode(bytes);
}

// Function that turns a base64 byte string into an image
Uint8List base64ToBytes(String base64String) {
  return base64Decode(base64String);
}

class CompressAndResizeImageParams {
  final Uint8List imageBytes;
  final int longestSide;

  CompressAndResizeImageParams(this.imageBytes, this.longestSide);
}

int getNumChannels(Uint8List imageBytes) {
  img.Image? image = img.decodeImage(imageBytes);
  return image!.numChannels;
}

Uint8List compressAndResizeImage(CompressAndResizeImageParams params) {
  img.Image? image = img.decodeImage(params.imageBytes);

  int width;
  int height;

  if (image!.width > image.height) {
    width = params.longestSide;
    height = (image.height / image.width * params.longestSide).round();
  } else {
    height = params.longestSide;
    width = (image.width / image.height * params.longestSide).round();
  }
  img.Image resizedImage = img.copyResize(image, width: width, height: height);
  // Compress the image with PNG format
  List<int> compressedBytes = img.encodePng(resizedImage);  // Adjust quality as needed
  return Uint8List.fromList(compressedBytes);
}

Uint8List reformatForStegoViz(Uint8List imageBytes) {
  // Resposible for converting the image to PNG format and performing any other necessary conversions to make
  // the image compatible with the app
  img.Image? image = img.decodeImage(imageBytes);
  List<int> pngBytes = img.encodePng(image!);
  return Uint8List.fromList(pngBytes);
}

int getImageWidth(Uint8List imageBytes) {
  img.Image? image = img.decodeImage(imageBytes);
  return image!.width;
}

int getImageHeight(Uint8List imageBytes) {
  img.Image? image = img.decodeImage(imageBytes);
  return image!.height;
}

// Function that sends a prettified string of the size of the image
// if the image is larger than 1MB, it will be displayed in MB
// otherwise, it will be displayed in KB
String prettifyImageSize(String base64String) {
  final imgBytes = base64ToBytes(base64String);
  final imgSize = imgBytes.lengthInBytes;

  if (imgSize > 1000000) {
    return '${(imgSize/1000000).toStringAsFixed(2)} MB';
  } else {
    return '${(imgSize/1000).round()} KB';
  }
}
