import 'package:danrom/app_ad.dart';
import 'package:danrom/app_localization.dart';
import 'package:danrom/data/local/local_data_access.dart';
import 'package:danrom/di/di.dart';
import 'package:danrom/resources/colors.dart';
import 'package:danrom/resources/resources.dart';
import 'package:danrom/resources/themes.dart';
import 'package:danrom/shared/utils/dart_extensions.dart';
import 'package:danrom/shared/utils/view_utils.dart';
import 'package:danrom/shared/widget/bouncing.dart';
import 'package:danrom/shared/widget/primary_icon_button.dart';
import 'package:danrom/view/number/cubit/number_cubit.dart';
import 'package:danrom/view/number/number_options.dart';
import 'package:danrom/view/number/random_number_generate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Number extends StatefulWidget {
  const Number({super.key});

  @override
  State<Number> createState() => _NumberState();
}

class _NumberState extends State<Number> {
  final AppAd appAd = getIt.get();

  final NumberCubit cubit = getIt.get();
  Key _key = UniqueKey();
  final LocalDataAccess localDataAccess = getIt.get();
  late int count, maximum, minimum;
  bool isDisable = false;
  late bool isDuplicate, isSorted;
  final List<int> results = [];
  bool started = false;

  @override
  void initState() {
    super.initState();
    count = localDataAccess.getCount();
    isDuplicate = localDataAccess.getDuplicateResults();
    isSorted = localDataAccess.getSortResults();
    maximum = localDataAccess.getMaximumRange();
    minimum = localDataAccess.getMinimumRange();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.white,
        body: BlocProvider.value(
          value: cubit,
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                BlocListener<NumberCubit, NumberState>(
                    listener: (context, state) {
                      if (state is NumberHasGenerated) {
                        if (!isDuplicate) {
                          // If duplicated results are not allowed
                          if (results.contains(state.number)) {
                            cubit.isDuplicate(state.index!, results); // Notify it is duplicated
                          } else {
                            results.add(state.number);
                          }
                        } else {
                          results.add(state.number); // Nothing to think, just add it...
                        }

                        if (results.length == count) {
                          if (isSorted) {
                            results.sort();
                            cubit.haveGeneratedAll(results);
                          }
                          cubit.blank();
                        }
                      }
                    },
                    child: Container()),
                Expanded(
                    child: started
                        ? Center(
                            child: count == 1
                                ? RandomNumberGenerate(
                                    index: 0,
                                    key: UniqueKey(),
                                    loop: 10,
                                    minimum: localDataAccess.getMinimumRange(),
                                    maximum: localDataAccess.getMaximumRange(),
                                    style: AppTextTheme.poppinsRegular96)
                                : SingleChildScrollView(
                                    controller: ScrollController(),
                                    child: Column(
                                        key: _key,
                                        children: List.generate(
                                            count * 2,
                                            (index) => index % 2 == 0
                                                ? Container(
                                                    constraints: BoxConstraints(minWidth: context.screenWidth),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(12),
                                                        color: AppColor.gray05),
                                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                                    child: Center(
                                                      child: RandomNumberGenerate(
                                                          index: index ~/ 2,
                                                          loop: 10,
                                                          maximum: maximum,
                                                          minimum: minimum),
                                                    ))
                                                : const SizedBox(height: 16)))))
                        : Center(
                            child: Bouncing(
                                child: GestureDetector(
                                    onTap: () async {
                                      appAd.loadInterstitialAd();
                                      setState(() {
                                        isDisable = true;
                                        started = true;
                                      });
                                    },
                                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                      SvgPicture.asset(Assets.icTouch),
                                      const SizedBox(height: 16),
                                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                        Text(AppLocalizations.of(context)?.translate('Touch to ') ?? '',
                                            style: AppTextTheme.descriptionSmall),
                                        Text(AppLocalizations.of(context)?.translate('Generate!') ?? '',
                                            style: AppTextTheme.descriptionBoldSmall)
                                      ])
                                    ]))))),
                Row(children: [
                  PrimaryIconButton(
                      child: SvgPicture.asset(Assets.icSliderHorizontal),
                      onPressed: () {
                        cubit.blank();
                        showModalBottomSheet(
                            backgroundColor: AppColor.transparent,
                            barrierColor: AppColor.transparent,
                            builder: (context) => Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                      blurRadius: 8,
                                      color: AppColor.black.withOpacity(0.08),
                                      offset: const Offset(0, -2),
                                      spreadRadius: 0)
                                ]),
                                child: Padding(
                                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                    child: NumberOptions(onChanged: () {
                                      setState(() {
                                        count = localDataAccess.getCount();
                                        isDuplicate = localDataAccess.getDuplicateResults();
                                        isSorted = localDataAccess.getSortResults();
                                        _key = UniqueKey();
                                        maximum = localDataAccess.getMaximumRange();
                                        minimum = localDataAccess.getMinimumRange();
                                        results.clear();
                                        started = false;
                                      });
                                    }))),
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))));
                      }),
                  const Spacer(),
                  if (started)
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                colors: [AppColor.primaryColor1, AppColor.primaryColor2],
                                end: Alignment.bottomRight)),
                        child: ElevatedButton(
                            onPressed: () async {
                              appAd.loadInterstitialAd();
                              setState(() {
                                _key = UniqueKey();
                                results.clear();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.transparent,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                                shadowColor: AppColor.transparent),
                            child: Text(AppLocalizations.of(context)?.translate('Touch to Generate') ?? '',
                                style: AppTextTheme.descriptionSemiBoldSmall.copyWith(color: AppColor.white)))),
                  const Spacer(),
                  if (started)
                    PrimaryIconButton(
                        child: SvgPicture.asset(Assets.icCopy),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: results.toString()));
                          toastInformation(AppLocalizations.of(context)?.translate("Text copied") ?? '');
                        })
                ])
              ])),
        ));
  }
}
