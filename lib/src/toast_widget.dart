import 'package:flutter/material.dart';

class _ToastWidget extends StatefulWidget {
  final String message;
  final int seconds;
  final VoidCallback whenCompleted;
  const _ToastWidget({
    Key? key,
    required this.message,
    required this.seconds,
    required this.whenCompleted,
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
    return FadeTransition(
      opacity: opacity,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.65),
            borderRadius: const BorderRadius.all(Radius.circular(32)),
          ),
          margin: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).size.height * .125,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 14,
          ),
          child: Text(
            widget.message,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class ToastWidget {
  OverlayEntry? _overlayEntry;
  final String message;
  final int seconds;

  ToastWidget({required this.message, this.seconds = 2});

  Future<void> show(BuildContext context) async {
    createOverlay();
    Overlay.of(context)?.insert(_overlayEntry!);
  }

  void createOverlay() {
    _overlayEntry = OverlayEntry(builder: (BuildContext context) {
      return _ToastWidget(
        message: message,
        seconds: seconds,
        whenCompleted: removeOverlay,
      );
    });
  }

  void removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
