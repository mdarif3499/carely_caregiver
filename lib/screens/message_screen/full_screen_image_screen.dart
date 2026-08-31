import 'package:carely_caregiver/widgets/show_custom_snackbar.dart';
import 'package:core_kit/core_kit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gal/gal.dart';

class FullScreenImageScreen extends StatelessWidget {
  const FullScreenImageScreen({super.key});

  Future<void> _downloadImage(String url) async {
    if (url.isEmpty) return;
    try {
      final response = await Dio().get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      await Gal.putImageBytes(
        Uint8List.fromList(response.data),
        name: "carely_${DateTime.now().millisecondsSinceEpoch}",
      );

      showCustomSnackbar(message: "Image saved to gallery", isError: false);
    } catch (e) {
      debugPrint("Download Error: $e");
      showCustomSnackbar(message: "Failed to save image", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    String imageUrl = '';
    String heroTag = '';

    if (args is Map) {
      imageUrl = args['url'] ?? '';
      heroTag = args['tag'] ?? imageUrl;
    } else if (args is String) {
      imageUrl = args;
      heroTag = imageUrl;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded, color: Colors.white, size: 28),
            onPressed: () => _downloadImage(imageUrl),
          ),
          const SizedBox(width: 10),
        ],
        elevation: 0,
      ),
      body: Center(
        child: Hero(
          tag: heroTag,
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 4.0,
            child: CommonImage(
              src: imageUrl,
              width: double.infinity,
              height: double.infinity,
              fill: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
