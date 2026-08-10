import 'package:core_kit/image/common_image.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final double size;
  final String imageUrl;
  final Color borderColor;
  final String? badgeIcon;
  final double? badgeSize;
  final double borderWidth;

  const ProfileAvatar({
    super.key,
    required this.size,
    required this.imageUrl,
    required this.borderColor,
    this.badgeIcon,
    this.borderWidth = 4, this.badgeSize,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: borderColor,
              width: borderWidth,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(borderWidth),
            child: ClipOval(
              child: CommonImage(
                src: imageUrl,
                fill: BoxFit.cover,
              ),
            ),
          ),
        ),

        if (badgeIcon != null)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: size * 0.28,
              width: size * 0.28,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              padding: EdgeInsets.all(size * 0.04),
              child: CommonImage(src: badgeIcon!,height: badgeSize,width: badgeSize),
            ),
          ),
      ],
    );
  }
}