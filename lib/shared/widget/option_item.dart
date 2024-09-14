import 'package:danrom/resources/colors.dart';
import 'package:danrom/shared/utils/dart_extensions.dart';
import 'package:danrom/shared/widget/custom_switch.dart';
import 'package:flutter/material.dart';

class OptionItem extends StatefulWidget {
  final Widget content;
  final Function(bool)? onSwitched;
  final bool initSwitch;
  final bool isShowSwitch;
  final Widget? prefixIcon, suffixIcon;

  const OptionItem(
      {super.key,
      required this.content,
      this.isShowSwitch = false,
      this.prefixIcon,
      this.suffixIcon,
      this.onSwitched,
      this.initSwitch = false});

  @override
  State<OptionItem> createState() => _OptionItemState();
}

class _OptionItemState extends State<OptionItem> {
  late bool _isSwitched;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isSwitched = !widget.initSwitch;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(minHeight: context.screenWidth * 66 / 393),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  blurRadius: 2, color: AppColor.gray04.withOpacity(0.1), offset: const Offset(0, 1), spreadRadius: 0),
              BoxShadow(
                  blurRadius: 4, color: AppColor.gray04.withOpacity(0.09), offset: const Offset(0, 4), spreadRadius: 0),
              BoxShadow(
                  blurRadius: 5, color: AppColor.gray04.withOpacity(0.05), offset: const Offset(0, 9), spreadRadius: 0),
              BoxShadow(
                  blurRadius: 6,
                  color: AppColor.gray04.withOpacity(0.01),
                  offset: const Offset(0, 16),
                  spreadRadius: 0),
              BoxShadow(
                  blurRadius: 7, color: AppColor.gray04.withOpacity(0), offset: const Offset(0, 25), spreadRadius: 0)
            ],
            color: AppColor.white),
        padding: const EdgeInsets.all(8),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (widget.prefixIcon != null) widget.prefixIcon!,
          if (widget.prefixIcon != null) const SizedBox(width: 6),
          Expanded(child: widget.content),
          if (widget.isShowSwitch)
            CustomSwitch(
                value: _isSwitched,
                onChanged: (value) => setState(() {
                      _isSwitched = value;
                      if (widget.onSwitched != null) widget.onSwitched!(value);
                    })),
          if (widget.suffixIcon != null) const SizedBox(width: 6),
          if (widget.suffixIcon != null) widget.suffixIcon!
        ]));
  }
}
