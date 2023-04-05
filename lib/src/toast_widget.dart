import 'package:flutter/material.dart';

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
            (value) => widget.whenCompleted,
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
    return Material(
      child: SafeArea(
        child: FadeTransition(
          opacity: opacity,
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
    BoxDecoration? decoration,
    TextStyle? style,
  }) {
    _createOverlay(
      message: message,
      seconds: seconds,
      decoration: decoration,
      style: style,
    );
    Overlay.of(context)?.insert(_overlayEntry!);
  }

  static void _createOverlay({
    required String message,
    int seconds = 2,
    BoxDecoration? decoration,
    TextStyle? style,
  }) {
    _overlayEntry = OverlayEntry(builder: (BuildContext context) {
      return Align(
        alignment: Alignment.center,
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
