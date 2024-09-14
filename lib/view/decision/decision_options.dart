import 'package:danrom/app_localization.dart';
import 'package:danrom/data/local/local_data_access.dart';
import 'package:danrom/di/di.dart';
import 'package:danrom/resources/colors.dart';
import 'package:danrom/resources/resources.dart';
import 'package:danrom/resources/themes.dart';
import 'package:danrom/shared/widget/bouncing.dart';
import 'package:danrom/shared/widget/option_item.dart';
import 'package:danrom/shared/widget/primary_icon_button.dart';
import 'package:danrom/view/decision/card_skin.dart';
import 'package:danrom/view/decision/cubit/decision_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DecisionOptions extends StatefulWidget {
  final TextEditingController questionController;
  final Function() shuffle;

  const DecisionOptions({super.key, required this.questionController, required this.shuffle});

  @override
  State<DecisionOptions> createState() => _DecisionOptionsState();
}

class _DecisionOptionsState extends State<DecisionOptions> {
  final DecisionCubit cubit = getIt.get();
  final TextEditingController localController = TextEditingController();
  final LocalDataAccess localDataAccess = getIt.get();

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
            Text(AppLocalizations.of(context)?.translate('Question') ?? '',
                style: AppTextTheme.descriptionBoldSemiLarge),
            const Spacer(),
            PrimaryIconButton(
                backgroundColor: AppColor.white,
                child: SvgPicture.asset(Assets.icClose),
                onPressed: () {
                  Navigator.pop(context);
                })
          ]),
          TextField(
              controller: localController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.all(16),
                  filled: true,
                  fillColor: AppColor.gray05,
                  hintText: AppLocalizations.of(context)?.translate('Wanna hangout?')),
              onSubmitted: (value) {
                widget.questionController.text = value;
              },
              style: AppTextTheme.descriptionRegularSemiLarge),
          const SizedBox(height: 8),
          Text(AppLocalizations.of(context)?.translate('Options') ?? '', style: AppTextTheme.descriptionBoldSemiLarge),
          const SizedBox(height: 4),
          OptionItem(
              content: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(AppLocalizations.of(context)?.translate('No Loop') ?? '', style: AppTextTheme.optionTitleMedium),
                Text(
                    AppLocalizations.of(context)
                            ?.translate('Disable the result automatically, it can\'t be drawn until reset') ??
                        '',
                    style: AppTextTheme.optionBodyRegular)
              ]),
              initSwitch: localDataAccess.getCardLoop(),
              isShowSwitch: true,
              onSwitched: (p0) {
                localDataAccess.setCardLoop(!p0);
                cubit.setCardLoop(!p0);
              },
              prefixIcon: SvgPicture.asset(Assets.icNoLoop)),
          const SizedBox(height: 16),
          Bouncing(
              child: GestureDetector(
                  onTap: () {
                    widget.shuffle();
                    Navigator.pop(context);
                  },
                  child: OptionItem(
                      content: Text(' ${AppLocalizations.of(context)?.translate('Shuffle Cards')}',
                          style: AppTextTheme.optionTitleMedium),
                      prefixIcon: SvgPicture.asset(Assets.icShuffle)))),
          const SizedBox(height: 16),
          Bouncing(
              child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context, builder: (context) => const CardSkin(), isScrollControlled: true);
                  },
                  child: OptionItem(
                      content: Row(children: [
                        Text(AppLocalizations.of(context)?.translate('Card Skins') ?? '',
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
                      suffixIcon: const Icon(Icons.keyboard_arrow_right_rounded))))
        ]));
  }
}
