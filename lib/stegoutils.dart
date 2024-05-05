import 'dart:math';
import 'dart:typed_data';
import 'package:image/image.dart';

// Class for exceptions thrown by StegoUtils
class StegoUtilsException implements Exception {
  StegoUtilsException(this.message);

  final String message;

  // factory from code
  factory StegoUtilsException.fromCode(int code) {
    switch(code) {
      case 1:
        return StegoUtilsException('Image is not an RGB image');
      case 2:
        return StegoUtilsException('Bit plane must be between 1 and 8');
      case 3:
        return StegoUtilsException('Message is too long to fit in the image');
      default:
        return StegoUtilsException('Unknown error');
    }
  }
}

// Function that converts an rgb image to greyscale
Uint8List grayscaleImage(Uint8List imageBytes) {
  Image image = decodeImage(imageBytes)!;

  Image gray = grayscale(image);
  if(gray.numChannels == 3) {
    final redChannelImage = _extractChannel3(gray, 0);
    return encodePng(redChannelImage);
  } else {
    return encodePng(gray);
  }
}

// Extract a color channel from an image and return it as a Uint8List
Image _extractChannel3(Image image, int channel) {
  // assert channel is 0, 1, or 2
  assert (channel >= 0 && channel <= 2);
  Uint8List channelBytes = Uint8List(image.width * image.height);
  for(int i = 0; i < image.height; i++) {
    for(int j = 0; j < image.width; j++) {
      final pixel = image.getPixel(j, i);
      if(channel == 0) {
        channelBytes[i * image.width + j] = pixel.r as int;
      } else if(channel == 1) {
        channelBytes[i * image.width + j] = pixel.g as int;
      } else {
        channelBytes[i * image.width + j] = pixel.b as int;
      }
    }
  }
  // make ByteBuffer from Uint8List
  ByteBuffer byteBuffer = channelBytes.buffer;
  // encode the channel bytes into an image
  Image channelImage = Image.fromBytes(
    width: image.width,
    height: image.height,
    bytes: byteBuffer,
    numChannels: 1,
  );
  return channelImage;
}

// lsbEmbedGray Arguments:
class LsbEmbedArguments {
  final Uint8List imageBytes;
  final String secretMessage;
  final int bitPlane;

  LsbEmbedArguments(this.imageBytes, this.secretMessage, this.bitPlane);
}

Uint8List lsbEmbedGray(LsbEmbedArguments arguments) {
  Image image = decodeImage(arguments.imageBytes)!;

  if(arguments.bitPlane < 0 || arguments.bitPlane > 7) {
    throw Exception('Bit plane must be between 0 and 7');
  }

  // get the pixels of the image in lexicographical order
  List<Pixel> pixels = getPixelsLexicographically(image);
  // get the width and height of the image
  int width = image.width;
  int height = image.height;
  // number of bits in the header
  int headerSizeInPixels = (width * height).bitLength;
  // number of bits in the message
  int messageSizeInPixels = (arguments.secretMessage.length * 8);
  // message size in binary as list of bits padded to the left with 0s
  List<int> messageSizeBits = messageSizeInPixels.toRadixString(2).padLeft(headerSizeInPixels, '0').split('').map(int.parse).toList();

  final allowedMessageBytes = (((width * height) ~/ 8) - headerSizeInPixels.toString().length);

  if(messageSizeInPixels + headerSizeInPixels > width * height) {
    throw StegoUtilsException('Message is too long. Image can only fit $allowedMessageBytes bytes');
  }

  // Set the header bits in the image
  for(int i = 0; i < headerSizeInPixels; i++) {
    int newPixelValue = changePixelBitAndGetNewValue(pixels[i], arguments.bitPlane, messageSizeBits[i]);
    pixels[i].r = newPixelValue;
  }

  // Set the message bits in the image
  List<int> messageBits = stringToBits(arguments.secretMessage);
  for(int i = headerSizeInPixels; i < messageSizeInPixels + headerSizeInPixels; i++) {
    final currentMsgBit = messageBits[i - headerSizeInPixels];
    int newPixelValue = changePixelBitAndGetNewValue(pixels[i], arguments.bitPlane, currentMsgBit);
    pixels[i].r = newPixelValue;
  }

  // turn pixels back into an image
  Image newImage = Image.fromBytes(
    width: image.width,
    height: image.height,
    bytes: Uint8List.fromList(pixels.map((pixel) => pixel.r as int).toList()).buffer,
    numChannels: 1,
  );

  return encodePng(newImage);
}

Uint8List lsbEmbedRGB(LsbEmbedArguments arguments) {
  Image image = decodeImage(arguments.imageBytes)!;

  if(image.numChannels != 3) {
    throw StegoUtilsException.fromCode(1);
  }

  if(arguments.bitPlane < 0 || arguments.bitPlane > 7) {
    throw StegoUtilsException.fromCode(2);
  }

  // get the width and height of the image
  int width = image.width;
  int height = image.height;
  // number of bits in the header divided by 3 for each channel
  int headerSizeInPixels = ((width * height).bitLength) ~/ 3;
  // number of pixels needed for the message
  int messageSizeInPixels = (arguments.secretMessage.length * 8) ~/ 3;
  // message size in binary as list of bits padded to the left with 0s
  List<int> messageSizeBits = messageSizeInPixels.toRadixString(2).padLeft(headerSizeInPixels, '0').split('').map(int.parse).toList();

  final allowedMessageBytes = ((((width * height) ~/ 8) * 3) - ((headerSizeInPixels.toString().length ~/ 8) * 3));

  if(messageSizeInPixels + headerSizeInPixels > width * height) {
    throw StegoUtilsException('Message is too long. Image can only fit $allowedMessageBytes bytes');
  }

  List<int> messageBits = stringToBits(arguments.secretMessage);
  for(int i = 0; i < image.height; i++) {
    for(int j = 0; j < image.width; j++) {
      final pixelCount = i * image.width + j;
      final pixel = image.getPixel(j, i);
      if(pixelCount < headerSizeInPixels) {
        for(int k = 0; k < 3; k++) {
          if(pixelCount * 3 + k > messageSizeBits.length - 1) {
            break;
          }
          final currentMsgBit = messageSizeBits[pixelCount * 3 + k];
          if(k == 0) {
            pixel.r = changePixelBitAndGetNewValue(pixel, arguments.bitPlane, currentMsgBit, channel: 'r');
          } else if(k == 1) {
            pixel.g = changePixelBitAndGetNewValue(pixel, arguments.bitPlane, currentMsgBit, channel: 'g');
          } else {
            pixel.b = changePixelBitAndGetNewValue(pixel, arguments.bitPlane, currentMsgBit, channel: 'b');
          }
        }
      } else if(pixelCount < messageSizeInPixels + headerSizeInPixels) {
        for(int k = 0; k < 3; k++) {
          if((pixelCount - headerSizeInPixels) * 3 + k > messageBits.length - 1) {
            break;
          }
          final currentMsgBit = messageBits[(pixelCount - headerSizeInPixels) * 3 + k];
          if(k == 0) {
            pixel.r = changePixelBitAndGetNewValue(pixel, arguments.bitPlane, currentMsgBit, channel: 'r');
          } else if(k == 1) {
            pixel.g = changePixelBitAndGetNewValue(pixel, arguments.bitPlane, currentMsgBit, channel: 'g');
          } else {
            pixel.b = changePixelBitAndGetNewValue(pixel, arguments.bitPlane, currentMsgBit, channel: 'b');
          }
        }
      }
    }
  }

  // turn pixels back into an image
  Image newImage = Image.fromBytes(
    width: image.width,
    height: image.height,
    bytes: Uint8List.fromList(image.getBytes()).buffer,
    numChannels: 3,
  );

  return encodePng(newImage);
}

List<int> stringToBits(String secretMessage, {bool singleBit = false, int bit = 0}) {
  assert(!singleBit || bit > 0 && bit < 9);

  List<int> messageBits = [];
  for(int i = 0; i < secretMessage.length; i++) {
    int charCode = secretMessage.codeUnitAt(i);
    if(singleBit) {
      // only use the specified bit plane
      messageBits.add((charCode >> (7 - bit)) & 1);
    } else {
      for(int j = 0; j < 8; j++) {
        messageBits.add((charCode >> (7 - j)) & 1);
      }
    }
  }
  return messageBits;
}

// Function that gets the pixels of an image in lexicographical order
List<Pixel> getPixelsLexicographically(Image image) {
  List<Pixel> pixels = [];
  for(int i = 0; i < image.height; i++) {
    for(int j = 0; j < image.width; j++) {
      final pixel = image.getPixel(j, i);
      pixels.add(pixel);
    }
  }
  return pixels;
}

// Set the indicated bit of a pixel to a new value and return the new pixel value
int changePixelBitAndGetNewValue(Pixel pixel, int bitPlane, int newValue, {String channel = 'r'}) {
  if(bitPlane < 0 || bitPlane > 7) {
    throw StegoUtilsException.fromCode(2);
  }
  if(newValue < 0 || newValue > 1) {
    throw StegoUtilsException('New value must be 0 or 1');
  }

  int pixelValue = pixel.r as int;
  if(channel == 'g') {
    pixelValue = pixel.g as int;
  } else if(channel == 'b') {
    pixelValue = pixel.b as int;
  }

  int mask = 1 << bitPlane;
  int newPixelValue = (pixelValue & ~mask) | (newValue << bitPlane);
  return newPixelValue;
}
