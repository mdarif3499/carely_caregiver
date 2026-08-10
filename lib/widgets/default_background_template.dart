import 'package:carely_caregiver/constant/app_colors.dart';
import 'package:core_kit/app_bar/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DefaultBackgroundTemplate extends StatelessWidget {
  final Widget child;
  final bool hideBackButton;
  final Color? appBarBackgroundColor;
  final Color? bodyBackgroundColor;
  final String? appBarTitle;
  final Widget? titleWidget;
  final VoidCallback? onBackPress;
  final List<Widget>? actions;
  const DefaultBackgroundTemplate({super.key, required this.child, this.hideBackButton = false, this.appBarBackgroundColor, this.appBarTitle, this.actions, this.onBackPress, this.bodyBackgroundColor, this.titleWidget});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackgroundColor??AppColors.instance.screenBg,
      appBar: CommonAppBar(
        titleWidget: titleWidget,
        hideBack: hideBackButton,

        appbarConfig: AppbarConfig(
          titleSpacing: -10,
        titleAlignment: Alignment.topLeft,
        backgroundColor: appBarBackgroundColor,
          actions: actions??[],
        ),
        title: appBarTitle,
      ),
      body: SafeArea(child: child),
    );
  }
}
