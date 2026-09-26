// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsFontsGen {
  const $AssetsFontsGen();

  /// File path: assets/fonts/Satoshi-Black.ttf
  String get satoshiBlack => 'assets/fonts/Satoshi-Black.ttf';

  /// File path: assets/fonts/Satoshi-Light.ttf
  String get satoshiLight => 'assets/fonts/Satoshi-Light.ttf';

  /// File path: assets/fonts/Satoshi-Medium.ttf
  String get satoshiMedium => 'assets/fonts/Satoshi-Medium.ttf';

  /// File path: assets/fonts/Satoshi-Regular.ttf
  String get satoshiRegular => 'assets/fonts/Satoshi-Regular.ttf';

  /// File path: assets/fonts/Satoshi-Variable.ttf
  String get satoshiVariable => 'assets/fonts/Satoshi-Variable.ttf';

  /// List of all assets
  List<String> get values => [
    satoshiBlack,
    satoshiLight,
    satoshiMedium,
    satoshiRegular,
    satoshiVariable,
  ];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/booking.svg
  String get booking => 'assets/icons/booking.svg';

  /// File path: assets/icons/calender.svg
  String get calender => 'assets/icons/calender.svg';

  /// File path: assets/icons/camera.svg
  String get camera => 'assets/icons/camera.svg';

  /// File path: assets/icons/caregiver.svg
  String get caregiver => 'assets/icons/caregiver.svg';

  /// File path: assets/icons/client.svg
  String get client => 'assets/icons/client.svg';

  /// File path: assets/icons/earning.svg
  String get earning => 'assets/icons/earning.svg';

  /// File path: assets/icons/google.svg
  String get google => 'assets/icons/google.svg';

  /// File path: assets/icons/home.svg
  String get home => 'assets/icons/home.svg';

  String get location => 'assets/icons/location.svg';

  String get medicale => 'assets/icons/medicale.svg';

  /// File path: assets/icons/message.svg
  String get message => 'assets/icons/message.svg';

  /// File path: assets/icons/message_send.svg
  String get messageSend => 'assets/icons/message_send.svg';

  /// File path: assets/icons/profile.svg
  String get profile => 'assets/icons/profile.svg';

  /// File path: assets/icons/s_booking.svg
  String get sBooking => 'assets/icons/s_booking.svg';

  /// File path: assets/icons/s_earning.svg
  String get sEarning => 'assets/icons/s_earning.svg';

  /// File path: assets/icons/s_home.svg
  String get sHome => 'assets/icons/s_home.svg';

  /// File path: assets/icons/s_message.svg
  String get sMessage => 'assets/icons/s_message.svg';

  /// File path: assets/icons/s_profile.svg
  String get sProfile => 'assets/icons/s_profile.svg';

  /// File path: assets/icons/s_search.svg
  String get sSearch => 'assets/icons/s_search.svg';

  /// File path: assets/icons/search.svg
  String get search => 'assets/icons/search.svg';

  /// File path: assets/icons/star_icon.svg
  String get starIcon => 'assets/icons/star_icon.svg';

  /// File path: assets/icons/verify.svg
  String get verify => 'assets/icons/verify.svg';

  /// List of all assets
  List<String> get values => [
    booking,
    calender,
    camera,
    caregiver,
    client,
    earning,
    google,
    home,
    location,
    medicale,
    message,
    messageSend,
    profile,
    sBooking,
    sEarning,
    sHome,
    sMessage,
    sProfile,
    sSearch,
    search,
    starIcon,
    verify,
  ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/img.png
  AssetGenImage get img => const AssetGenImage('assets/images/img.png');

  /// File path: assets/images/onboarding1.png
  AssetGenImage get onboarding1 =>
      const AssetGenImage('assets/images/onboarding1.png');

  /// File path: assets/images/onboarding2.png
  AssetGenImage get onboarding2 =>
      const AssetGenImage('assets/images/onboarding2.png');

  /// File path: assets/images/splash_bg.png
  AssetGenImage get splashBg =>
      const AssetGenImage('assets/images/splash_bg.png');

  /// List of all assets
  List<AssetGenImage> get values => [img, onboarding1, onboarding2, splashBg];
}

class $AssetsLogoGen {
  const $AssetsLogoGen();

  /// File path: assets/logo/app_logo.png
  AssetGenImage get appLogoPng =>
      const AssetGenImage('assets/logo/app_logo.png');

  /// File path: assets/logo/app_logo.svg
  String get appLogoSvg => 'assets/logo/app_logo.svg';

  /// File path: assets/logo/app_logo2.png
  AssetGenImage get appLogo2 =>
      const AssetGenImage('assets/logo/app_logo2.png');

  /// List of all assets
  List<dynamic> get values => [appLogoPng, appLogoSvg, appLogo2];
}

class Assets {
  const Assets._();

  static const $AssetsFontsGen fonts = $AssetsFontsGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLogoGen logo = $AssetsLogoGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
