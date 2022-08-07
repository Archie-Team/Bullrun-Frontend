import 'package:flutter/widgets.dart';

class CountdownController {
  VoidCallback? onPause;

  VoidCallback? onResume;

  VoidCallback? onRestart;

  VoidCallback? onStart;

  bool? isCompleted;

  final bool autoStart;

  CountdownController({this.autoStart = false});

  start() {
    if (onStart != null) {
      onStart!();
    }
  }

  setOnStart(VoidCallback onStart) {
    this.onStart = onStart;
  }

  pause() {
    if (onPause != null) {
      onPause!();
    }
  }

  setOnPause(VoidCallback onPause) {
    this.onPause = onPause;
  }

  resume() {
    if (onResume != null) {
      onResume!();
    }
  }

  setOnResume(VoidCallback onResume) {
    this.onResume = onResume;
  }

  restart() {
    if (onRestart != null) {
      onRestart!();
    }
  }

  setOnRestart(VoidCallback onRestart) {
    this.onRestart = onRestart;
  }
}
