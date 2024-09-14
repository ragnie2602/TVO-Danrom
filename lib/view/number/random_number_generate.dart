import 'dart:async';
import 'dart:math';

import 'package:danrom/di/di.dart';
import 'package:danrom/resources/colors.dart';
import 'package:danrom/resources/themes.dart';
import 'package:danrom/view/number/cubit/number_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class RandomNumberGenerate extends StatefulWidget {
  final Duration? durationLoop;
  final int index;
  int loop;
  final int minimum;
  final int maximum;
  final TextStyle style;

  RandomNumberGenerate(
      {super.key,
      this.durationLoop,
      required this.index,
      required this.loop,
      required this.maximum,
      required this.minimum,
      this.style = AppTextTheme.poppinsMedium20});

  @override
  State<RandomNumberGenerate> createState() => _RandomNumberGenerateState();
}

class _RandomNumberGenerateState extends State<RandomNumberGenerate> {
  final NumberCubit cubit = getIt.get();
  Timer? _timer;
  late int _value;

  @override
  void initState() {
    startTimer();
    super.initState();

    _value = Random().nextInt(widget.maximum - widget.minimum) + widget.minimum;
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColor.primaryColor1, AppColor.primaryColor2],
            ).createShader(bounds),
        child: BlocListener<NumberCubit, NumberState>(
            listener: (context, state) {
              if (state is NumbersHaveGeneratedAll) {
                setState(() {
                  _value = state.numbers[widget.index];
                });
              } else if (state is NumberIsDuplicated && widget.index == state.index) {
                while (state.newResults
                    .contains(_value = Random().nextInt(widget.maximum - widget.minimum) + widget.minimum)) {}
                cubit.hasGenerate(_value, index: widget.index);

                setState(() {});
              }
            },
            child: Text('$_value', style: widget.style)));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(widget.durationLoop ?? const Duration(milliseconds: 100), (Timer timer) {
      if (widget.loop == 0) {
        cubit.hasGenerate(_value, index: widget.index);
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          widget.loop--;
          _value = Random().nextInt(widget.maximum - widget.minimum) + widget.minimum;
        });
      }
    });
  }

  int get value => _value;
}
