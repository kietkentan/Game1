import 'dart:async';

import 'package:flutter/material.dart';
import 'package:game/extension/extensions.dart';
import 'package:game/theme/color/app_color.dart';
import 'package:game/theme/text_styles/text_styles.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../../state/app_state.dart';

class CoinGame extends StatefulWidget {
  AppState state;
  double height;
  EdgeInsets? margin;

  CoinGame({required this.state, required this.height, this.margin, super.key});

  @override
  _CoinGameState createState() => _CoinGameState();
}

class _CoinGameState extends State<CoinGame> {
  Timer? _timer;
  int value = 0;

  @override
  void initState() {
    _startTimer(widget.state);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.height,
        margin: widget.margin,
        child: Stack(children: [
          Container(
              height: widget.height * 0.8,
              margin: EdgeInsets.symmetric(vertical: widget.height * 0.1),
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [AppColor.topCoin, AppColor.bottomCoin],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                  border: const GradientBoxBorder(
                      gradient: LinearGradient(
                          colors: [
                            AppColor.topCoinStroke,
                            AppColor.bottomCoinStroke
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                      width: 3),
                  borderRadius:
                      BorderRadius.all(Radius.circular(widget.height * 0.5))),
              padding: EdgeInsets.only(
                  left: widget.height, right: widget.height * 0.2),
              child: Text(formatNumberWithCommas(value),
                  style: TextStyles.textInter
                      .copyWith(fontSize: widget.height * 0.4),
                  textAlign: TextAlign.center)),
          Image.asset('assets/ic_gold.png', fit: BoxFit.fitHeight)
        ]));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer(AppState state) {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (value != state.coin) {
        setState(() {
          value = state.coin;
        });
      }
    });
  }
}
