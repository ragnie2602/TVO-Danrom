import 'dart:math';

import 'package:flutter/material.dart';

class CardState extends ChangeNotifier {
  final List<String> cardTexts = [
    "No regrets, just lessons.",
    "Step out of your comfort zone.",
    "Just Say Yes",
    "Flip a coin and do the opposite",
    "Keep moving forward.",
    "Trust your instincts.",
    "Make it happen.",
    "Be fearless.",
    "Ask your mom",
    "What will be will be",
    "Haste makes waste",
    "A miss is as good as a mile",
    "Let bygones be bygones",
    "All that glitters is not gold",
    "No more no less",
    "Better late than never",
    "Sink or swim",
    "You can't have it both ways",
    "A good beginning makes a good ending",
    "Misfortunes never come alone.",
    "To be not as black as it is painted",
    "After rain comes fair weather",
    "Better luck next time",
    "Judge not, that you be not judged",
    "Something better than nothing",
    "Hatred is as blind as love",
    "If you sell the cow, you will sell her milk too",
    "Judge a man by his work",
    "Observations is the best teacher",
    "What goes up must go down",
    "Love can't be forced",
    "As clear as daylight",
    "Time cure all pains",
    "Never put off tomorrow what you can do today",
    "Great minds think alike",
    "It's the best thing since sliced bread",
    "See eye to eye",
    "Hit the sack",
    "Nobody has ever shed tears without seeing a coffin",
    "When pigs fly",
    "Have your ducks in a row",
    "Waste of time",
    "Know your limits",
    "Have your head in the clouds",
    "Believe in yourself",
    "Go back to the drawing board",
    "Keep your chin up",
    "Get the ball rolling",
    "Chase rainbows",
    "Something to kill time",
    "Turn a blind eye",
    "Bite the bullet",
    "Break the ice",
    "It's all downhill from here",
    "Dont cry over split milk",
    "At all costs",
    "Let's face it",
    "Put yourself in his/her shoes",
    "Change your/his/ her mind",
    "Pay a heavy toll",
    "Cut corners",
    "Paint the town red",
    "A shot in the dark",
    "Get the hold of the wrong end of the stick",
    "Play it by ear",
    "Let sleeping dogs lie"
  ];
  late final int length;
  int _i = 0;
  List<String> _trash = ['', '', ''];

  CardState() {
    length = cardTexts.length;
  }

  randomizeNoLoop() async {
    while (_trash.contains(cardTexts[_i])) {
      _i = Random().nextInt(cardTexts.length);
    }
    _trash.removeAt(0);
    _trash.add(cardTexts[_i]);
  }

  int get index => _i;

  String get text => cardTexts[_i];

  set i(int value) {
    _i = value;
  }
}
