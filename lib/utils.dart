import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:convert';

// Function that turns an asset image into a base64 byte string
Future<String> imageToBase64(String path) async {
  final bytes = await rootBundle.load(path);
  return base64Encode(Uint8List.view(bytes.buffer));
}

// Function that turns a base64 byte string into an image
Uint8List base64ToBytes(String base64String) {
  // Convert base64 byte string to image
  final imgBytes = base64Decode(base64String);
  return imgBytes;
}