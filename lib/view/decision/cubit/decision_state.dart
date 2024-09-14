part of 'decision_cubit.dart';

abstract class DecisionState extends Equatable {
  const DecisionState();
  @override
  List<Object?> get props => [];
}

class DecisionInitial extends DecisionState {}

class DecisionChooseCardSkin extends DecisionState {
  final String cardSkin;

  const DecisionChooseCardSkin({required this.cardSkin});
  @override
  List<Object?> get props => [cardSkin];
}

class DecisionSetCardLoop extends DecisionState {
  final bool cardLoop;

  const DecisionSetCardLoop(this.cardLoop);
  @override
  List<Object?> get props => [cardLoop];
}
