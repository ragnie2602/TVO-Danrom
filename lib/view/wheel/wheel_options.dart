// ignore_for_file: must_be_immutable

import 'package:danrom/app_localization.dart';
import 'package:danrom/data/local/local_data_access.dart';
import 'package:danrom/di/di.dart';
import 'package:danrom/resources/colors.dart';
import 'package:danrom/resources/resources.dart';
import 'package:danrom/resources/themes.dart';
import 'package:danrom/shared/utils/dart_extensions.dart';
import 'package:danrom/shared/widget/bouncing.dart';
import 'package:danrom/shared/widget/option_item.dart';
import 'package:danrom/shared/widget/primary_icon_button.dart';
import 'package:danrom/view/wheel/cubit/wheel_cubit.dart';
import 'package:danrom/view/wheel/wheel_skins.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WheelOptions extends StatelessWidget {
  final WheelCubit cubit = getIt.get();
  final LocalDataAccess localDataAccess = getIt.get();

  WheelOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: cubit,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 8,
                      color: AppColor.black.withOpacity(0.08),
                      offset: const Offset(0, -2),
                      spreadRadius: 0)
                ],
                color: AppColor.white),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Scaffold(
                appBar: AppBar(
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PrimaryIconButton(
                              backgroundColor: AppColor.white,
                              child: SvgPicture.asset(Assets.icClose),
                              onPressed: () => Navigator.pop(context)),
                        ],
                      )
                    ],
                    backgroundColor: AppColor.white,
                    leading: Container(),
                    scrolledUnderElevation: 0.0,
                    surfaceTintColor: AppColor.transparent),
                backgroundColor: AppColor.white,
                body: SingleChildScrollView(
                    child:
                        Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  Text(AppLocalizations.of(context)?.translate('Question') ?? '',
                      style: AppTextTheme.descriptionBoldSemiLarge),
                  const SizedBox(height: 8),
                  BlocBuilder<WheelCubit, WheelState>(builder: (context, state) {
                    return TextField(
                        controller: TextEditingController(text: state is WheelChangeQuestion ? state.question : ''),
                        decoration: InputDecoration(
                            border:
                                OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.all(16),
                            filled: true,
                            fillColor: AppColor.gray05,
                            hintText: AppLocalizations.of(context)?.translate('Wanna hangout?') ?? ''),
                        onSubmitted: (value) {
                          cubit.changeQuestion(value);
                        },
                        style: AppTextTheme.descriptionRegularSemiLarge);
                  }),
                  const SizedBox(height: 20),
                  Text(AppLocalizations.of(context)?.translate('Options') ?? '',
                      style: AppTextTheme.descriptionBoldSemiLarge),
                  const SizedBox(height: 8),
                  const WheelChoices(),
                  const SizedBox(height: 20),
                  Text(AppLocalizations.of(context)?.translate('Advanced Settings') ?? '',
                      style: AppTextTheme.descriptionBoldSemiLarge),
                  const SizedBox(height: 8),
                  OptionItem(
                      content: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(AppLocalizations.of(context)?.translate('No Loop') ?? '',
                            style: AppTextTheme.optionTitleMedium),
                        Text(
                            AppLocalizations.of(context)
                                    ?.translate('Disable the result automatically, it can\'t be drawn until reset') ??
                                '',
                            style: AppTextTheme.optionBodyRegular)
                      ]),
                      initSwitch: localDataAccess.getWheelLoop(),
                      isShowSwitch: true,
                      onSwitched: (p0) => cubit.changeLoopable(!p0),
                      prefixIcon: SvgPicture.asset(Assets.icNoLoop)),
                  const SizedBox(height: 16),
                  OptionItem(
                      content: Text(AppLocalizations.of(context)?.translate('Set duration') ?? '',
                          style: AppTextTheme.optionTitleMedium),
                      prefixIcon: SvgPicture.asset(Assets.icTimeFill),
                      suffixIcon: Row(mainAxisSize: MainAxisSize.min, children: [
                        SizedBox(
                            height: context.screenWidth * 28 / 393,
                            width: context.screenWidth * 28 / 393,
                            child: PrimaryIconButton(
                                backgroundColor: AppColor.white,
                                border: const MaterialStatePropertyAll(BorderSide(width: 0.5)),
                                onPressed: () {
                                  int tmp = localDataAccess.getWheelDuration() - 1;

                                  localDataAccess.setWheelDuration(tmp);
                                  cubit.changeDuration(tmp);
                                },
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                child: SvgPicture.asset(Assets.icMinus))),
                        SizedBox(width: context.screenWidth * 10 / 393),
                        BlocBuilder<WheelCubit, WheelState>(
                            builder: (context, state) =>
                                Text('${localDataAccess.getWheelDuration()}s', style: AppTextTheme.optionBodyMedium)),
                        SizedBox(width: context.screenWidth * 10 / 393),
                        SizedBox(
                            height: context.screenWidth * 28 / 393,
                            width: context.screenWidth * 28 / 393,
                            child: PrimaryIconButton(
                                backgroundColor: AppColor.white,
                                border: const MaterialStatePropertyAll(BorderSide(width: 0.5)),
                                onPressed: () {
                                  int tmp = localDataAccess.getWheelDuration() + 1;

                                  localDataAccess.setWheelDuration(tmp);
                                  cubit.changeDuration(tmp);
                                },
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                child: SvgPicture.asset(Assets.icPlus))),
                      ])),
                  const SizedBox(height: 16),
                  Bouncing(
                      child: GestureDetector(
                          onTap: () {
                            cubit.shuffleChoices();
                          },
                          child: OptionItem(
                              content: Text(AppLocalizations.of(context)?.translate('Shuffle Options') ?? '',
                                  style: AppTextTheme.optionTitleMedium),
                              prefixIcon: SvgPicture.asset(Assets.icShuffle)))),
                  const SizedBox(height: 16),
                  Bouncing(
                      child: GestureDetector(
                          onTap: () {
                            cubit.removeDuplicateChoices();
                          },
                          child: OptionItem(
                              content: Text(AppLocalizations.of(context)?.translate('Remove Duplicated Options') ?? '',
                                  style: AppTextTheme.optionTitleMedium),
                              prefixIcon: SvgPicture.asset(Assets.icRemove)))),
                  const SizedBox(height: 16),
                  Bouncing(
                      child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                backgroundColor: AppColor.transparent,
                                barrierColor: AppColor.transparent,
                                context: context,
                                builder: (context) => Container(
                                    constraints: BoxConstraints(maxHeight: context.screenHeight * 351 / 393),
                                    decoration: BoxDecoration(boxShadow: [
                                      BoxShadow(
                                          blurRadius: 8,
                                          color: AppColor.black.withOpacity(0.08),
                                          offset: const Offset(0, -2),
                                          spreadRadius: 0)
                                    ]),
                                    child: Padding(
                                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                        child: WheelSkins(cubit: cubit, localDataAccess: localDataAccess))),
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(24), topRight: Radius.circular(24))));
                          },
                          child: OptionItem(
                              content: Row(mainAxisSize: MainAxisSize.min, children: [
                                Text(AppLocalizations.of(context)?.translate('Wheel Skins') ?? '',
                                    style: AppTextTheme.optionTitleMedium),
                                const SizedBox(width: 6),
                                Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(100),
                                        gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            colors: [AppColor.primaryColor1, AppColor.primaryColor2],
                                            end: Alignment.bottomRight)),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    child: Text('Pro',
                                        style: AppTextTheme.descriptionSemiBoldSmall.copyWith(color: AppColor.white)))
                              ]),
                              prefixIcon: SvgPicture.asset(Assets.icCardSkin),
                              suffixIcon: const Icon(Icons.keyboard_arrow_right_rounded)))),
                  const SizedBox(height: 16),
                ])),
                resizeToAvoidBottomInset: false)));
  }
}

class WheelChoices extends StatefulWidget {
  const WheelChoices({super.key});

  @override
  State<WheelChoices> createState() => _WheelChoicesState();
}

class _WheelChoicesState extends State<WheelChoices> {
  final WheelCubit cubit = getIt.get();
  final LocalDataAccess localDataAccess = getIt.get();
  late List<String> wheelChoices;

  @override
  void initState() {
    super.initState();
    wheelChoices = localDataAccess.getWheelChoices();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvoked: (didPop) {
          localDataAccess.setWheelChoices(wheelChoices);
          cubit.changeChoices();
        },
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          BlocListener<WheelCubit, WheelState>(
              listener: (context, state) {
                if (state is WheelShuffleChoice) {
                  setState(() {
                    wheelChoices.shuffle();
                  });
                } else if (state is WheelRemoveDuplicateChoice) {
                  setState(() {
                    wheelChoices = wheelChoices.toSet().toList();
                  });
                }
              },
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                      wheelChoices.length,
                      (index) => WheelChoiceItem(
                          onChanged: (p0) => p0.isEmpty
                              ? setState(() {
                                  wheelChoices.removeAt(index);
                                })
                              : wheelChoices[index] = p0,
                          text: wheelChoices[index])))),
          Bouncing(
              child: GestureDetector(
                  onTap: () => setState(() {
                        wheelChoices.add('${wheelChoices.length + 1}');
                      }),
                  child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColor.gray05),
                      padding: const EdgeInsets.all(16),
                      child: Row(children: [
                        SvgPicture.asset(Assets.icAdd),
                        const SizedBox(width: 12),
                        Text(AppLocalizations.of(context)?.translate('Add New Option') ?? '',
                            style: AppTextTheme.descriptionRegularSemiLarge.copyWith(color: AppColor.purple01))
                      ])))),
          const SizedBox(height: 8),
          Bouncing(
              child: GestureDetector(
                  onTap: () => showModalBottomSheet(
                      barrierColor: AppColor.transparent,
                      context: context,
                      builder: (context) => Container(
                          constraints: BoxConstraints(maxHeight: context.screenHeight * 2 / 3),
                          child: MultipleChoiceOptions(
                            onSave: (choices) => setState(() {
                              wheelChoices.addAll(choices);
                            }),
                          )),
                      isScrollControlled: true),
                  child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColor.gray05),
                      padding: const EdgeInsets.all(16),
                      child: Row(children: [
                        SvgPicture.asset(Assets.icMultiple),
                        const SizedBox(width: 12),
                        Text(AppLocalizations.of(context)?.translate('Add Multiple Options') ?? '',
                            style: AppTextTheme.descriptionRegularSemiLarge.copyWith(color: AppColor.purple01))
                      ])))),
        ]));
  }
}

class WheelChoiceItem extends StatelessWidget {
  late final TextEditingController controller;
  final Function(String) onChanged;
  String text;

  WheelChoiceItem({super.key, required this.onChanged, required this.text}) {
    controller = TextEditingController(text: text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      FocusScope(
          onFocusChange: (value) => onChanged(controller.text),
          child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.all(16),
                  filled: true,
                  fillColor: AppColor.gray05),
              onSubmitted: (value) => onChanged(value),
              style: AppTextTheme.descriptionRegularSemiLarge)),
      const SizedBox(height: 8)
    ]);
  }
}

class MultipleChoiceOptions extends StatefulWidget {
  final Function(List<String>) onSave;

  const MultipleChoiceOptions({super.key, required this.onSave});

  @override
  State<MultipleChoiceOptions> createState() => _MultipleChoiceOptionsState();
}

class _MultipleChoiceOptionsState extends State<MultipleChoiceOptions> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                  blurRadius: 8, color: AppColor.black.withOpacity(0.08), offset: const Offset(0, -2), spreadRadius: 0)
            ],
            color: AppColor.white),
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            const Spacer(),
            PrimaryIconButton(
                backgroundColor: AppColor.white,
                child: SvgPicture.asset(Assets.icClose),
                onPressed: () {
                  Navigator.pop(context);
                })
          ]),
          const Text('Add Multiple Questions', style: AppTextTheme.descriptionBoldSemiLarge),
          const SizedBox(height: 8),
          Expanded(
              child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.all(16),
                      filled: true,
                      fillColor: AppColor.gray05,
                      hintText: 'Enter any options you want, one per line, for example:\nCar\nBicycle\nTrain'),
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: AppTextTheme.descriptionSmall,
                  textAlignVertical: TextAlignVertical.top)),
          const SizedBox(height: 20),
          Container(
              constraints: BoxConstraints(minWidth: context.screenWidth),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: const LinearGradient(
                      colors: [AppColor.primaryColor1, AppColor.primaryColor2],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight)),
              padding: EdgeInsets.zero,
              child: TextButton(
                  onPressed: () {
                    widget.onSave(controller.text.split('\n')..removeWhere((element) => element.isEmpty));
                    Navigator.pop(context);
                  },
                  child: Text('Save', style: AppTextTheme.bodyMedium.copyWith(color: AppColor.white))))
        ]));
  }
}
