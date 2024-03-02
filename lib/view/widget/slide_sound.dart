import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomSlider extends StatefulWidget {
  final String? assetImage;
  final LinearGradient linearGradient;
  final Color inActiveTrackColor;
  final double min;
  final double max;
  final double value;
  final double height;
  final int? divisions;
  final ValueChanged<double>? onChanged;

  const CustomSlider({
    super.key,
    this.assetImage,
    required this.linearGradient,
    required this.inActiveTrackColor,
    required this.min,
    required this.max,
    required this.value,
    this.onChanged,
    this.divisions,
    required this.height,
  });

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  ui.Image? customImage;

  Future<ui.Image> load(String asset) async {
    ByteData data = await rootBundle.load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: widget.height.toInt(),
        targetWidth: widget.height.toInt());
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  @override
  void initState() {
    if (widget.assetImage != null) {
      load(widget.assetImage!).then((image) {
        setState(() {
          customImage = image;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double slideHeight = widget.height * 0.8;
    return SizedBox(
        height: widget.height,
        width: slideHeight * 13.7 + widget.height * 0.2,
        child: Stack(
            children: [
              Container(
                  height: widget.height,
                  width: slideHeight * 13.7 + widget.height * 0.2,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(widget.height / 2))
                  )
              ),
              Center(
                  child: SizedBox(
                      width: slideHeight * 13.7,
                      height: slideHeight,
                      child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                              inactiveTrackColor: widget.inActiveTrackColor,
                              overlayShape: SliderComponentShape.noOverlay,
                              trackHeight: slideHeight,
                              trackShape: GradientSliderTrackShape(linearGradient: widget.linearGradient, assetImageWidth: slideHeight, width: slideHeight * 13.7),
                              thumbShape: customImage != null
                                  ? SliderThumbImage(customImage!)
                                  : SliderComponentShape.noThumb),
                          child: Slider(
                              min: widget.min,
                              max: widget.max,
                              onChanged: widget.onChanged ?? (v) {},
                              value: widget.value
                          )
                      )
                  )
              )
            ]
        )
    );
  }
}

class GradientSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  LinearGradient? linearGradient;
  double assetImageWidth;
  double width;

  GradientSliderTrackShape({this.linearGradient, required this.assetImageWidth, required this.width}) {
    linearGradient ??
        const LinearGradient(colors: [
          Colors.black,
          Colors.amber,
        ]);
  }

  @override
  void paint(
      PaintingContext context,
      ui.Offset offset, {
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required Animation<double> enableAnimation,
        required ui.Offset thumbCenter,
        ui.Offset? secondaryOffset,
        bool isEnabled = false,
        bool isDiscrete = false,
        required ui.TextDirection textDirection,
        double additionalActiveTrackHeight = 2,
      }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);

    if (sliderTheme.trackHeight! <= 0) {
      return;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final activeGradientRect = Rect.fromLTRB(
      trackRect.left,
      (textDirection == TextDirection.ltr)
          ? trackRect.top - (additionalActiveTrackHeight / 2)
          : trackRect.top,
      thumbCenter.dx,
      (textDirection == TextDirection.ltr)
          ? trackRect.bottom + (additionalActiveTrackHeight / 2)
          : trackRect.bottom,
    );

    final ColorTween activeTrackColorTween = ColorTween(
        begin: sliderTheme.disabledActiveTrackColor,
        end: sliderTheme.activeTrackColor);
    final ColorTween inactiveTrackColorTween = ColorTween(
        begin: sliderTheme.disabledInactiveTrackColor,
        end: sliderTheme.inactiveTrackColor);
    final Paint activePaint = Paint()
      ..shader = linearGradient!.createShader(activeGradientRect)
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint inactivePaint = Paint()
      ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;
    final Paint leftTrackPaint;
    final Paint rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }

    final Rect leftTrackSegment = Rect.fromLTRB(
        0, trackRect.top, thumbCenter.dx, trackRect.bottom);
    final RRect trackRRect = RRect.fromRectAndRadius(leftTrackSegment, const Radius.circular(20));
    final Rect rightTrackSegment = Rect.fromLTRB(
        thumbCenter.dx, trackRect.top, width, trackRect.bottom);
    final RRect trackRRect2 = RRect.fromRectAndRadius(trackRect, const Radius.circular(20));
    if (!rightTrackSegment.isEmpty) {
      context.canvas.drawRRect(trackRRect2, rightTrackPaint);
    }
    if (!leftTrackSegment.isEmpty) {
      context.canvas.drawRRect(trackRRect, leftTrackPaint);
    }
  }
}

class SliderThumbImage extends SliderComponentShape {
  final ui.Image image;

  SliderThumbImage(this.image);
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(0, 0);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow}) {
    var canvas = context.canvas;
    final picWidth = image.width;
    final picHeight = image.height;

    Offset picOffset = Offset(
      (center.dx - (picWidth / 2)),
      (center.dy - (picHeight / 2)),
    );

    Paint paint = Paint()..filterQuality = FilterQuality.high;
    canvas.drawImage(image, picOffset, paint);
  }
}