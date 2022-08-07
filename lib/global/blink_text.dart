import 'package:flutter/material.dart';

class BlinkText extends StatefulWidget {
  const BlinkText(
      {Key? key,
      required this.text,
      required this.style,
      required this.beginColor,
      required this.endColor,
      required this.duration,
      required this.times})
      : super(key: key);

  final String text;
  final TextStyle style;
  final Duration? duration;
  final int? times;
  final Color? beginColor;
  final Color? endColor;

  @override
  BlinkTextState createState() => BlinkTextState();
}

class BlinkTextState extends State<BlinkText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  int _counter = 0;
  Duration? duration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    //default duration
    if (widget.duration != null) {
      duration = widget.duration;
    }
    final times = widget.times ?? 0;

    _controller = AnimationController(vsync: this, duration: duration);
    _colorAnimation = ColorTween(begin: widget.beginColor, end: widget.endColor)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _counter++;
        _controller.reverse();
        if (_counter >= times && times > 0) {
          _endTween();
        }
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  _endTween() {
    Future.delayed(duration!, () {
      _controller.stop();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Widget _buildWidget() {
  //   return Text(
  //     widget.data,
  //     style: style.copyWith(color: _colorAnimation.value),
  //     strutStyle: widget.strutStyle,
  //     textAlign: widget.textAlign,
  //     textDirection: widget.textDirection,
  //     locale: widget.locale,
  //     textScaleFactor: 1,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Text(widget.text,
            style: widget.style.copyWith(
              color: _colorAnimation.value,
            ));
      },
    );
  }
}
