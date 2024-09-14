import 'package:danrom/app_localization.dart';
import 'package:danrom/data/local/local_data_access.dart';
import 'package:danrom/di/di.dart';
import 'package:danrom/resources/colors.dart';
import 'package:danrom/resources/resources.dart';
import 'package:danrom/resources/themes.dart';
import 'package:danrom/shared/utils/dart_extensions.dart';
import 'package:danrom/shared/widget/option_item.dart';
import 'package:danrom/shared/widget/primary_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NumberOptions extends StatefulWidget {
  final Function() onChanged;

  const NumberOptions({super.key, required this.onChanged});

  @override
  State<NumberOptions> createState() => _NumberOptionsState();
}

class _NumberOptionsState extends State<NumberOptions> {
  final TextEditingController countController = TextEditingController();
  final TextEditingController localController = TextEditingController();
  final TextEditingController minimumController = TextEditingController();
  final TextEditingController maximumController = TextEditingController();
  final LocalDataAccess localDataAccess = getIt.get();

  @override
  void initState() {
    super.initState();

    countController.text = '${localDataAccess.getCount()}';
    maximumController.text = '${localDataAccess.getMaximumRange()}';
    minimumController.text = '${localDataAccess.getMinimumRange()}';
  }

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
            Text(AppLocalizations.of(context)?.translate('Options') ?? '',
                style: AppTextTheme.descriptionBoldSemiLarge),
            const Spacer(),
            PrimaryIconButton(
                backgroundColor: AppColor.white,
                child: SvgPicture.asset(Assets.icClose),
                onPressed: () {
                  Navigator.pop(context);
                })
          ]),
          const SizedBox(height: 4),
          OptionItem(
              content:
                  Text(AppLocalizations.of(context)?.translate('Range') ?? '', style: AppTextTheme.optionTitleMedium),
              prefixIcon: SvgPicture.asset(Assets.icRange),
              suffixIcon: Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColor.gray02),
                    width: context.screenWidth * 60 / 393,
                    child: TextField(
                        controller: minimumController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                            isDense: true),
                        keyboardType: TextInputType.number,
                        onSubmitted: (value) {
                          minimumHandler();
                          countHandler();
                        },
                        onTapOutside: (event) => minimumHandler(),
                        style: AppTextTheme.descriptionSemiBoldRegular)),
                Text(' ${AppLocalizations.of(context)?.translate('to')} ', style: AppTextTheme.optionTitleMedium),
                Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColor.gray02),
                    width: context.screenWidth * 60 / 393,
                    child: TextField(
                        controller: maximumController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                            isDense: true),
                        keyboardType: TextInputType.number,
                        onSubmitted: (value) {
                          maximumHandler();
                          countHandler();
                        },
                        onTapOutside: (event) {
                          maximumHandler();
                          countHandler();
                        },
                        style: AppTextTheme.descriptionSemiBoldRegular))
              ])),
          const SizedBox(height: 16),
          OptionItem(
              content:
                  Text(AppLocalizations.of(context)?.translate('Count') ?? '', style: AppTextTheme.optionTitleMedium),
              prefixIcon: SvgPicture.asset(Assets.icCount),
              suffixIcon: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColor.gray02),
                  width: context.screenWidth * 60 / 393,
                  child: TextField(
                      controller: countController,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          isDense: true),
                      keyboardType: TextInputType.number,
                      onSubmitted: (value) {
                        countHandler();
                      },
                      onTapOutside: (event) {
                        countHandler();
                      },
                      style: AppTextTheme.descriptionSemiBoldRegular))),
          const SizedBox(height: 16),
          if (localDataAccess.getCount() > 1)
            OptionItem(
                content: Text(AppLocalizations.of(context)?.translate('Sort Results') ?? '',
                    style: AppTextTheme.optionTitleMedium),
                initSwitch: !localDataAccess.getSortResults(),
                isShowSwitch: true,
                onSwitched: (p0) {
                  localDataAccess.setSortResults(p0);
                },
                prefixIcon: SvgPicture.asset(Assets.icSortAscending)),
          const SizedBox(height: 16),
          if (localDataAccess.getCount() > 1)
            OptionItem(
                content: Text(AppLocalizations.of(context)?.translate('Duplicate Results') ?? '',
                    style: AppTextTheme.optionTitleMedium),
                initSwitch: !localDataAccess.getDuplicateResults(),
                isShowSwitch: true,
                onSwitched: (p0) {
                  int tmp = int.parse(maximumController.text) - int.parse(minimumController.text) + 1;
                  if (!localDataAccess.getDuplicateResults() && int.parse(countController.text) > tmp) {
                    countController.text = '$tmp';
                  }

                  localDataAccess.setDuplicateResults(p0);
                  setState(() {});
                },
                prefixIcon: SvgPicture.asset(Assets.icDuplicate)),
          const SizedBox(height: 16)
        ]));
  }

  @override
  void deactivate() {
    widget.onChanged();
    super.deactivate();
  }

  countHandler() {
    if (countController.text.isEmpty || int.parse(countController.text) < 1) {
      countController.text = '1';
    }
    int tmp = int.parse(maximumController.text) - int.parse(minimumController.text) + 1;
    if (!localDataAccess.getDuplicateResults() && int.parse(countController.text) > tmp) {
      countController.text = '$tmp';
    }

    localDataAccess.setCount(int.parse(countController.text));
  }

  minimumHandler() {
    if (minimumController.text.isEmpty || int.parse(minimumController.text) < 1) {
      minimumController.text = '1';
    }
    if (int.parse(minimumController.text) > int.parse(maximumController.text)) {
      minimumController.text = maximumController.text;
    }

    localDataAccess.setMinimumRange(int.parse(minimumController.text));
  }

  maximumHandler() {
    if (maximumController.text.isEmpty || int.parse(maximumController.text) < 1) {
      maximumController.text = '1';
    }
    if (int.parse(maximumController.text) < int.parse(minimumController.text)) {
      maximumController.text = minimumController.text;
    }

    localDataAccess.setMaximumRange(int.parse(maximumController.text));
  }
}
