import 'package:flutter/material.dart';

import '../../theme/color/app_color.dart';

class ButtonScale extends StatefulWidget {
  double height;
  double? ratio;
  double? scale;
  double? letterSpacing;
  String? bg;
  String? bgDisable;
  String? icon;
  String? textCenter;
  String? font;
  EdgeInsets? margin;
  double? padding;
  double? paddingTop;
  double? paddingBottom;
  double? paddingLeft;
  double? paddingRight;
  Color? textColor;
  Paint? foreground;
  BoxFit? fit;
  LinearGradient? linearGradient;
  double? fontSize;
  VoidCallback onClick;

  ButtonScale(
      {super.key,
        required this.height,
        this.ratio,
        this.scale,
        this.letterSpacing,
        this.bg,
        this.bgDisable,
        this.icon,
        this.textCenter,
        this.font,
        this.margin,
        this.padding,
        this.paddingTop,
        this.paddingBottom,
        this.paddingRight,
        this.paddingLeft,
        this.textColor,
        this.foreground,
        this.fit = BoxFit.fitHeight,
        this.linearGradient,
        this.fontSize,
        required this.onClick}) {
    assert(
    padding == null ||
        (paddingBottom == null ||
            paddingLeft == null ||
            paddingRight == null ||
            paddingTop == null),
    "Only padding all or padding each region is available");
  }

  @override
  _ButtonScaleState createState() => _ButtonScaleState(
      eachPadding: paddingTop != null ||
          paddingBottom != null ||
          paddingLeft != null ||
          paddingRight != null);
}

class _ButtonScaleState extends State<ButtonScale> {
  bool isPressed = false;
  bool eachPadding;

  _ButtonScaleState({required this.eachPadding});

  @override
  Widget build(BuildContext context) {
    double scale = 1 - (widget.scale ?? 0.9);
    double width = widget.height * (widget.ratio ?? 1.0);
    String? bg =
    (widget.bgDisable != null && isPressed) ? widget.bgDisable : widget.bg;
    return Container(
        margin: widget.margin,
        child: GestureDetector(
            onTapDown: (_) {
              setState(() {
                isPressed = true;
              });
            },
            onTapUp: (_) {
              _resetScale();
            },
            onTapCancel: () {
              _resetScale();
            },
            onTap: widget.onClick,
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                transform: Matrix4.identity()
                  ..translate(isPressed ? (width * scale) / 2 : 0.0,
                      isPressed ? (widget.height * scale) / 2 : 0.0)
                  ..scale(isPressed ? widget.scale ?? 0.9 : 1.0),
                child: Container(
                    height: widget.height,
                    width: width,
                    padding: eachPadding
                        ? EdgeInsets.only(
                        top: (widget.paddingTop ?? 0) * widget.height,
                        left: (widget.paddingLeft ?? 0) * width,
                        right: (widget.paddingRight ?? 0) * width,
                        bottom: (widget.paddingBottom ?? 0) * widget.height)
                        : EdgeInsets.symmetric(
                        vertical: (widget.padding ?? 0) * widget.height,
                        horizontal: (widget.padding ?? 0) * width),
                    decoration: bg != null
                        ? BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(bg), fit: BoxFit.fitHeight))
                        : null,
                    child: widget.icon != null
                        ? Image.asset(widget.icon!,
                        fit: widget.fit)
                        : widget.textCenter != null
                        ? Center(
                        child: widget.linearGradient != null
                            ? Stack(
                          children: [
                            ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return widget.linearGradient!
                                      .createShader(bounds);
                                },
                                child: Text(widget.textCenter!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        letterSpacing:
                                        widget.letterSpacing,
                                        fontSize: widget.height *
                                            (widget.fontSize ?? 0.3),
                                        color: widget.textColor ??
                                            Colors.white,
                                        shadows: const [
                                          Shadow(
                                            offset: Offset(0.0, 1.35),
                                            blurRadius: 0.67,
                                            color: AppColor.black,
                                          )
                                        ],
                                        fontFamily: widget.font,
                                        decoration:
                                        TextDecoration.none))),
                            widget.foreground != null
                                ? Text(widget.textCenter!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    letterSpacing:
                                    widget.letterSpacing,
                                    fontSize: widget.height *
                                        (widget.fontSize ?? 0.3),
                                    fontFamily: widget.font,
                                    decoration:
                                    TextDecoration.none,
                                    foreground:
                                    widget.foreground))
                                : const SizedBox()
                          ],
                        )
                            : Stack(children: [
                          Text(widget.textCenter!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  letterSpacing: widget.letterSpacing,
                                  fontSize: widget.height *
                                      (widget.fontSize ?? 0.3),
                                  color: widget.textColor ??
                                      Colors.white,
                                  shadows: const [
                                    Shadow(
                                      offset: Offset(0.0, 1.35),
                                      blurRadius: 0.67,
                                      color: AppColor.black,
                                    )
                                  ],
                                  fontFamily: widget.font,
                                  decoration: TextDecoration.none)),
                          widget.foreground != null
                              ? Text(widget.textCenter!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  letterSpacing:
                                  widget.letterSpacing,
                                  fontSize: widget.height *
                                      (widget.fontSize ?? 0.3),
                                  fontFamily: widget.font,
                                  decoration: TextDecoration.none,
                                  foreground: widget.foreground))
                              : const SizedBox()
                        ]))
                        : const SizedBox())))
    );
  }

  void _resetScale() {
    setState(() {
      isPressed = false;
    });
  }
}
