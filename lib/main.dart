import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'config/route.dart';
import 'extension/extensions.dart';
import 'state/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider<AppState>(create: (_) => AppState())],
        child: MaterialApp(
          title: 'Ban Ca',
          routes: Routes.route(),
          onGenerateRoute: (settings) => Routes.onGenerateRoute(settings),
          onUnknownRoute: (settings) => Routes.onUnknownRoute(settings),
          initialRoute: "SplashScreen",
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('vi', ''),
          debugShowCheckedModeBanner: false,
        )
    );
  }
}