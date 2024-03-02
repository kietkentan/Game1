import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'shared_preference_helper.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerSingleton<SharedPreferenceHelper>(SharedPreferenceHelper());
}

void setupOrientations() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}

AppLocalizations translation(BuildContext context) {
  return AppLocalizations.of(context)!;
}

String formatNumberWithCommas(int number) {
  final formatter = NumberFormat('#,##0');
  return formatter.format(number);
}

String formatMillisecondsToTime(int milliseconds) {
  if (milliseconds < 0) return '00:00';
  Duration duration = Duration(milliseconds: milliseconds);

  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

  return "$twoDigitMinutes:$twoDigitSeconds";
}

launchURL(String url) async {
  Uri u = Uri.parse(url);
  await launchUrl(u, mode: LaunchMode.externalApplication);
}

const double baseSpeed = 200;
const double baseFishSpeed = -100;
final Vector2 sizeBullet = Vector2(21, 71);
final List<Vector2> listSizeFish = [
  Vector2(73, 43),
  Vector2(63, 43),
  Vector2(59, 49),
  Vector2(60, 66),
  Vector2(74, 58),
  Vector2(89, 70),
  Vector2(83, 77),
  Vector2(91, 94),
  Vector2(86, 76)
];
final List<int> listHeartFish = [
  1, 1, 1, 2, 2, 2, 3, 3, 4
];