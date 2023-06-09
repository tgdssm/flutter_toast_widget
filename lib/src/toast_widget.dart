import 'package:flutter/material.dart';

enum ShowIn {
  topCenter,
  center,
  bottomCenter,
}

extension ShowInAlignment on ShowIn {
  Alignment get align {
    switch (this) {
      case ShowIn.topCenter:
        return Alignment.topCenter;
      case ShowIn.bottomCenter:
        return Alignment.bottomCenter;
      default:
        return Alignment.center;
    }
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final int seconds;
  final VoidCallback whenCompleted;
  final BoxDecoration? decoration;
  final TextStyle? style;
  const _ToastWidget({
    Key? key,
    required this.message,
    required this.seconds,
    required this.whenCompleted,
    this.decoration,
    this.style,
  }) : super(key: key);

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController opacity;

  @override
  void initState() {
    opacity = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..forward();
    Future.delayed(Duration(seconds: widget.seconds), () {
      opacity.reverse().then(
            (_) => widget.whenCompleted(),
          );
    });
    super.initState();
  }

  @override
  void dispose() {
    opacity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FadeTransition(
        opacity: opacity,
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: widget.decoration ??
                BoxDecoration(
                  color: Colors.black.withOpacity(.65),
                  borderRadius: const BorderRadius.all(Radius.circular(32)),
                ),
            margin: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 14,
            ),
            child: Text(
              widget.message,
              style: widget.style ??
                  const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class ToastWidget {
  static OverlayEntry? _overlayEntry;
  static void show({
    required BuildContext context,
    required String message,
    int seconds = 2,
    ShowIn showIn = ShowIn.center,
    BoxDecoration? decoration,
    TextStyle? style,
  }) {
    _createOverlay(
      message: message,
      seconds: seconds,
      showIn: showIn,
      decoration: decoration,
      style: style,
    );
    Overlay.of(context)?.insert(_overlayEntry!);
  }

  static void _createOverlay({
    required String message,
    required int seconds,
    required ShowIn showIn,
    BoxDecoration? decoration,
    TextStyle? style,
  }) {
    _overlayEntry = OverlayEntry(builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        alignment: showIn.align,
        child: _ToastWidget(
          message: message,
          seconds: seconds,
          decoration: decoration,
          style: style,
          whenCompleted: _removeOverlay,
        ),
      );
    });
  }

  static void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
