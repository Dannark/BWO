import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';

class ImagePainter {

  bool isGenerating = false;

  /// Generates a [ui.Image] with certain pixel data
  Future<ui.Image> generateImage(int width, int height, Int32List pixels) async {
    if (isGenerating == false) {
      isGenerating = true;

      var completer = Completer<ui.Image>();

      /*Int32List pixels = Int32List(width * height);
      
      for (var x = 0; x < width; x++) {
        for (var y = 0; y < height; y++) {
          int index = y * width + x;
          pixels[index] = generatePixel(x, y, width, height);
        }
      }*/

      ui.decodeImageFromPixels(
        pixels.buffer.asUint8List(),
        width,
        height,
        ui.PixelFormat.rgba8888,
        (ui.Image img) {
          completer.complete(img);
        },
      );

      isGenerating= false;
      return completer.future;
    }
    return null;
  }

}
