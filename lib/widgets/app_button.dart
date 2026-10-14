import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:core_kit/text/common_text.dart';
import 'package:core_kit/utils/core_screen_utils.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.titleText,
    super.key,
    this.onTap,
    this.isLoading = false,
    this.buttonColor,
    this.titleColor,
    this.buttonWidth,
    this.buttonHeight,
    this.buttonRadius,
    this.elevation = 0,
    this.borderColor,
    this.borderWidth,
    this.fontSize,
    this.fontWeight,
  });

  final String titleText;
  final VoidCallback? onTap;
  final bool isLoading;
  final Color? buttonColor;
  final Color? titleColor;
  final double? buttonWidth;
  final double? buttonHeight;
  final double? buttonRadius;
  final double elevation;
  final Color? borderColor;
  final double? borderWidth;
  final double? fontSize;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    final effectiveButtonColor = buttonColor ?? AppColors.instance.primary;
    final effectiveTitleColor = titleColor ?? Colors.white;
    final effectiveRadius = buttonRadius ?? 16.r;
    final effectiveHeight = buttonHeight ?? 54.h;

    return SizedBox(
      width: buttonWidth ?? double.infinity,
      height: effectiveHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveButtonColor,
          disabledBackgroundColor: effectiveButtonColor.withAlpha(200),
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(effectiveRadius),
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: borderWidth ?? 1)
                : BorderSide.none,
          ),
          padding: EdgeInsets.zero,
        ),
        child: isLoading
            ? SizedBox(
                width: 24.w,
                height: 24.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(effectiveTitleColor),
                ),
              )
            : CommonText(
                text: titleText,
                textColor: effectiveTitleColor,
                fontSize: fontSize ?? 16.sp,
                fontWeight: fontWeight ?? FontWeight.w700,
              ),
      ),
    );
  }
}
