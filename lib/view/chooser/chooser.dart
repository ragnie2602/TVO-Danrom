import 'dart:async';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:danrom/app_ad.dart';
import 'package:danrom/app_localization.dart';
import 'package:danrom/data/local/local_data_access.dart';
import 'package:danrom/di/di.dart';
import 'package:danrom/resources/colors.dart';
import 'package:danrom/resources/resources.dart';
import 'package:danrom/resources/themes.dart';
import 'package:danrom/shared/utils/dart_extensions.dart';
import 'package:danrom/shared/widget/primary_icon_button.dart';
import 'package:danrom/view/chooser/chooser_options.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Chooser extends StatefulWidget {
  const Chooser({super.key});

  @override
  State<Chooser> createState() => _ChooserState();
}

class _ChooserState extends State<Chooser> {
  late final MultiChooser body;
  final GlobalKey<_MultiChooserState> bodyKey = GlobalKey();
  int countDown = 3;
  final MultiTapGestureRecognizer gestureRecognizer = MultiTapGestureRecognizer();
  final LocalDataAccess localDataAccess = getIt.get();
  bool started = false;
  late Timer timer;

  @override
  void initState() {
    super.initState();

    body = MultiChooser(
        key: bodyKey, getStart: getStart, getEnd: getEnd, startCountdown: startCountdown, endCountdown: endCountDown);
    countDown = 3;

    timer = Timer.periodic(const Duration(), (timer) {});
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.white,
        body: Column(children: [
          Expanded(
              child: Stack(children: [
            if (!started)
              Center(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                SvgPicture.asset(Assets.icTouch),
                const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(AppLocalizations.of(context)?.translate('Hold your finger to ') ?? '',
                      style: AppTextTheme.descriptionSmall),
                  Text(AppLocalizations.of(context)?.translate('Start!') ?? '',
                      style: AppTextTheme.descriptionBoldSmall)
                ])
              ])),
            body
          ])),
          Padding(
              padding: const EdgeInsets.all(16),
              child: Stack(children: [
                Row(children: [
                  PrimaryIconButton(
                      child: SvgPicture.asset(Assets.icSliderHorizontal),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => ChooserOptions(onChanged: () {
                                  setState(() {
                                    bodyKey.currentState?.reset();
                                    countDown = 3;
                                    timer.cancel();
                                    started = false;
                                  });
                                }));
                      })
                ]),
                if (started)
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                colors: [AppColor.primaryColor1, AppColor.primaryColor2],
                                end: Alignment.bottomRight)),
                        child: ElevatedButton(
                            onPressed: () {
                              if (countDown > 0) {
                                timer.cancel();
                                setState(() {
                                  countDown = 0;
                                  bodyKey.currentState?.startProc();
                                });
                              } else {
                                setState(() {
                                  bodyKey.currentState?.reset();
                                  countDown = 3;
                                  started = false;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.transparent,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                                shadowColor: AppColor.transparent),
                            child: Text(
                                countDown > 0
                                    ? '${AppLocalizations.of(context)?.translate('Start')} ${timer.isActive ? '($countDown)' : ''}'
                                    : AppLocalizations.of(context)?.translate('Reset') ?? '',
                                style: AppTextTheme.descriptionSemiBoldSmall.copyWith(color: AppColor.white))))
                  ])
              ]))
        ]));
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  getStart() {
    if (!started) setState(() => started = true);
  }

  getEnd() {
    if (started) setState(() => started = false);
  }

  void startCountdown() {
    if (timer.isActive) return;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (countDown > 0) {
          countDown--;
        } else {
          timer.cancel();
          bodyKey.currentState?.startProc();
        }
      });
    });
  }

  void endCountDown() {
    timer.cancel();
    setState(() => countDown = 3);
  }
}

// ignore: must_be_immutable
class MultiChooser extends StatefulWidget {
  final Function() getStart;
  final Function() getEnd;
  final Function() startCountdown;
  final Function() endCountdown;

  const MultiChooser(
      {super.key,
      required this.getStart,
      required this.getEnd,
      required this.startCountdown,
      required this.endCountdown});

  @override
  State<MultiChooser> createState() => _MultiChooserState();
}

class _MultiChooserState extends State<MultiChooser> {
  final AppAd appAd = getIt.get();
  double countDown = 6;
  int successing = 6;
  List<Offset> fingers = [];
  final LocalDataAccess localDataAccess = getIt.get();
  final player = AudioPlayer();
  late Timer procTimer, successTimer;
  List<int> results = [];

  @override
  void initState() {
    super.initState();

    // Avoid unintialized
    procTimer = Timer.periodic(const Duration(), (timer) {});
    procTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
        gestures: <Type, GestureRecognizerFactory>{
          ImmediateMultiDragGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<ImmediateMultiDragGestureRecognizer>(
                  () => ImmediateMultiDragGestureRecognizer(), (ImmediateMultiDragGestureRecognizer instance) {
            instance.onStart = (Offset offset) {
              if (countDown < 6) return null;
              if (!localDataAccess.getTapMode() && fingers.length >= 5) return null;

              widget.endCountdown();
              widget.startCountdown();

              setState(() {
                countDown = 6;
                fingers.add(offset);
                results.clear();
              });

              if (fingers.length > localDataAccess.getWinners()) {
                widget.startCountdown();
              } else if (fingers.isEmpty) {
                widget.getEnd();
              } else {
                widget.getStart();
              }
              return ItemDrag(
                  offset, (p0, p1) => onDrag(p0, p1), (p0) => localDataAccess.getTapMode() ? null : onEndDrag(p0));
            };
          })
        },
        child: Container(
            color: AppColor.transparent,
            child: Stack(children: [
              for (int i = 0; i < fingers.length; i++)
                Positioned(
                    left: fingers[i].dx - 50,
                    top: fingers[i].dy - 150,
                    child: Stack(alignment: Alignment.center, children: [
                      if (!results.contains(i) || successing % 2 == 0)
                        Container(
                            width: context.screenWidth * 106 / 393,
                            height: context.screenWidth * 106 / 393,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 4,
                                      color: AppColor.black.withOpacity(0.25),
                                      offset: const Offset(0, 4))
                                ],
                                gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    colors: [AppColor.primaryColor1, AppColor.primaryColor2],
                                    end: Alignment.bottomRight),
                                shape: BoxShape.circle)),
                      if (results.contains(i))
                        (successing % 2 == 0
                            ? SvgPicture.asset(Assets.icChooserResult,
                                height: context.screenWidth * 120 / 393, width: context.screenWidth * 120 / 393)
                            : Container())
                      else if (countDown <= 0)
                        Container(
                            width: context.screenWidth * 106 / 393,
                            height: context.screenWidth * 106 / 393,
                            decoration: const BoxDecoration(color: Color(0x80FFFFFF), shape: BoxShape.circle))
                    ]))
            ])));
  }

  @override
  void dispose() {
    procTimer.cancel();
    super.dispose();
  }

  void onDrag(Offset oldOffset, Offset newOffset) {
    setState(() => fingers[fingers.indexOf(oldOffset)] = newOffset);
  }

  void onEndDrag(Offset details) {
    if (countDown < 6) return;

    setState(() => fingers.remove(details));
    if (fingers.length > localDataAccess.getWinners()) {
      widget.startCountdown();
    } else {
      widget.endCountdown();
      if (fingers.isEmpty) widget.getEnd();
    }

    countDown = 6;
  }

  void startProc() {
    successing = 6;

    while (results.length < localDataAccess.getWinners()) {
      results.add(-1);
    }

    procTimer = Timer.periodic(const Duration(milliseconds: 250), (timer) {
      if (countDown > 3.5) {
        setState(() {
          countDown -= 0.25;

          int len = results.length, upr = fingers.length;
          for (var i = 0; i < len; i++) {
            int idx = math.Random().nextInt(upr);
            while (results.contains(idx)) {
              idx = math.Random().nextInt(upr);
            }
            results[i] = idx;
          }
        });
        player.stop();
        player.play(AssetSource(Assets.auChooserRandoming));
      } else {
        procTimer.cancel();
        procTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
          if (countDown > 2) {
            setState(() {
              countDown -= 0.5;

              int len = results.length, upr = fingers.length;
              for (var i = 0; i < len; i++) {
                int idx = math.Random().nextInt(upr);
                while (results.contains(idx)) {
                  idx = math.Random().nextInt(upr);
                }
                results[i] = idx;
              }
            });
            player.stop();
            player.play(AssetSource(Assets.auChooserRandoming));
          } else {
            procTimer.cancel();
            procTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
              if (countDown > 0) {
                setState(() {
                  countDown -= 1;

                  int len = results.length, upr = fingers.length;
                  for (var i = 0; i < len; i++) {
                    int idx = math.Random().nextInt(upr);
                    while (results.contains(idx)) {
                      idx = math.Random().nextInt(upr);
                    }
                    results[i] = idx;
                  }
                });
                player.stop();
                player.play(AssetSource(Assets.auChooserRandoming));
              } else {
                successTimer = Timer.periodic(const Duration(milliseconds: 750), (timer) {
                  if (successing > 0) {
                    setState(() {
                      successing--;
                    });
                  } else {
                    successTimer.cancel();
                  }
                });
                player.stop();
                player.play(AssetSource(Assets.auChooserSuccess));
                procTimer.cancel();
              }
            });
          }
        });
      }
    });

    if (successing == 0) appAd.loadInterstitialAd();
  }

  void reset() {
    setState(() {
      countDown = 6;
      fingers.clear();
      try {
        procTimer.cancel();
      } catch (e) {}
      results.clear();
    });
  }
}

class ItemDrag extends Drag {
  Offset offset;
  final Function(Offset, Offset) onUpdate;
  final Function(Offset) onEnd;

  ItemDrag(this.offset, this.onUpdate, this.onEnd);

  @override
  void update(DragUpdateDetails details) {
    super.update(details);

    onUpdate(offset, details.localPosition);
    offset = details.localPosition;
  }

  @override
  void end(DragEndDetails details) {
    super.end(details);
    onEnd(offset);
  }
}
