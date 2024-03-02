import 'package:flutter/material.dart';

import '../color/app_color.dart';

class TextStyles {
  TextStyles._();

  static TextStyle get textLoading {
    return const TextStyle(
        fontSize: 16,
        color: AppColor.white,
        fontFamily: 'InterRegular',
        decoration: TextDecoration.none);
  }

  static TextStyle get textInterBold {
    return const TextStyle(
        color: AppColor.white,
        fontFamily: 'InterBold',
        decoration: TextDecoration.none);
  }

  static TextStyle get textInter {
    return const TextStyle(
        color: AppColor.white,
        fontFamily: 'InterRegular',
        decoration: TextDecoration.none);
  }

  static TextStyle get textNunitoExtraBold {
    return const TextStyle(
        color: AppColor.white,
        fontFamily: 'NunitoExtraBold',
        decoration: TextDecoration.none);
  }

  static TextStyle get textNunitoBold {
    return const TextStyle(
        fontFamily: 'NunitoBold',
        decoration: TextDecoration.none);
  }
}