import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:core_kit/app_bar/common_app_bar.dart';
import 'package:flutter/material.dart';

class DefaultBackgroundTemplate extends StatelessWidget {
  final Widget child;
  final bool hideBackButton;
  final Color? appBarBackgroundColor;
  final Color? bodyBackgroundColor;
  final String? appBarTitle;
  final Widget? titleWidget;
  final VoidCallback? onBackPress;
  final List<Widget>? actions;
  final String? backgroundImage;
  const DefaultBackgroundTemplate({super.key, required this.child, this.hideBackButton = false, this.appBarBackgroundColor, this.appBarTitle, this.actions, this.onBackPress, this.bodyBackgroundColor, this.titleWidget, this.backgroundImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: backgroundImage != null ? Colors.transparent : (bodyBackgroundColor ?? AppColors.instance.screenBg),
      appBar: CommonAppBar(

        titleWidget: titleWidget,
        hideBack: hideBackButton,
        appbarConfig: AppbarConfig(
          titleSpacing: -10,
          titleAlignment: Alignment.topLeft,
          backgroundColor: appBarBackgroundColor,
          actions: actions ?? [],
        ),
        title: appBarTitle,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: backgroundImage != null ? BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage!),
            fit: BoxFit.cover,
            opacity: 0.8, // Increased opacity for better visibility
          ),
        ) : null,
        child: SafeArea(child: child),
      ),
    );
  }
}
