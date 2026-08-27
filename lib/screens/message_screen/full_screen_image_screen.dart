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
    final String imageUrl = Get.arguments ?? '';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
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
          tag: imageUrl,
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
