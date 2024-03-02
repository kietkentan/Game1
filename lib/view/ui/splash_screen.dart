import 'package:flutter/material.dart';
import 'package:game/extension/extensions.dart';
import 'package:game/theme/color/app_color.dart';
import 'package:game/theme/text_styles/text_styles.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../widget/loading/ball_pulse.dart';
import '../widget/loading/loading.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2)).then((value) {
      Navigator.of(context).pushReplacementNamed('/GameScreen');
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final state = context.watch<AppState>();
    if (state.coin < 0) {
      state.getValue();
    }
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/bg_splash.png'),
                  fit: BoxFit.cover
              )
          ),
        child: Container(
          padding: EdgeInsets.only(bottom: height * 0.6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [AppColor.loadingS, Colors.yellow, AppColor.loadingE],
                          stops: [0, 0.3, 0.7]
                      ).createShader(bounds);
                    },
                    child: Loading(
                        indicator: BallPulseIndicator(),
                        length: 10,
                        size: 25)
                ),
                const SizedBox(height: 10),
                Text(translation(context).loading.toUpperCase(), style: TextStyles.textLoading)
              ]
          )
        )
      )
    );
  }
}
