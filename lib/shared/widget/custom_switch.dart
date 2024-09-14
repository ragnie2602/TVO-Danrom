import 'package:danrom/resources/colors.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final String activeText;
  final String inactiveText;
  final Color activeTextColor;
  final Color inactiveTextColor;

  const CustomSwitch(
      {super.key,
      required this.value,
      required this.onChanged,
      this.activeColor = AppColor.primaryColor1,
      this.inactiveColor = Colors.grey,
      this.activeText = '',
      this.inactiveText = '',
      this.activeTextColor = Colors.white70,
      this.inactiveTextColor = Colors.white70});

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> with SingleTickerProviderStateMixin {
  late Animation _circleAnimation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 60));
    _circleAnimation = AlignmentTween(
            begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
            end: widget.value ? Alignment.centerLeft : Alignment.centerRight)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return GestureDetector(
              onTap: () {
                if (_animationController.isCompleted) {
                  _animationController.reverse();
                } else {
                  _animationController.forward();
                }
                widget.onChanged(!widget.value);
              },
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: _circleAnimation.value == Alignment.centerLeft ? widget.inactiveColor : widget.activeColor,
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          // You can set your own colors in here!
                          colors: _circleAnimation.value == Alignment.centerRight
                              ? const [AppColor.primaryColor1, AppColor.primaryColor2]
                              : [AppColor.gray03, AppColor.gray03])),
                  child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                        _circleAnimation.value == Alignment.centerRight
                            ? Padding(
                                padding: const EdgeInsets.only(left: 25.0, right: 0),
                                child: Text(widget.activeText,
                                    style: TextStyle(
                                        color: widget.activeTextColor, fontWeight: FontWeight.w900, fontSize: 16.0)))
                            : Container(),
                        Align(
                            alignment: _circleAnimation.value,
                            child: Container(
                                width: 25.0,
                                height: 25.0,
                                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white))),
                        _circleAnimation.value == Alignment.centerLeft
                            ? Padding(
                                padding: const EdgeInsets.only(left: 0, right: 25.0),
                                child: Text(widget.inactiveText,
                                    style: TextStyle(
                                        color: widget.inactiveTextColor, fontWeight: FontWeight.w900, fontSize: 16.0)))
                            : Container(),
                      ]))));
        });
  }
}
