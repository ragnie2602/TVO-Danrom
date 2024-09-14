import 'package:flutter/material.dart';

class Bouncing extends StatefulWidget {
  final Widget child;
  final Function? onPressed;

  const Bouncing({super.key, required this.child, this.onPressed});

  @override
  State<Bouncing> createState() => _BouncingState();
}

class _BouncingState extends State<Bouncing> with SingleTickerProviderStateMixin {
  double _scale = 0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.05,
    );
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return Listener(
      onPointerDown: (PointerDownEvent event) {
// if (widget.onPressed != null) {
        _controller.forward();
// }
      },
      onPointerUp: (PointerUpEvent event) {
// if (widget.onPressed != null) {
        _controller.reverse();
// }
      },
      child: Transform.scale(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}
