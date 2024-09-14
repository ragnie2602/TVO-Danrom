part of 'wheel_cubit.dart';

abstract class WheelState extends Equatable {
  const WheelState();
  @override
  List<Object?> get props => [];
}

class WheelInitial extends WheelState {}

class WheelChangeChoices extends WheelState {}

class WheelChangeDuration extends WheelState {
  final int duration;

  const WheelChangeDuration(this.duration);
  @override
  List<Object?> get props => [duration];
}

class WheelChangeQuestion extends WheelState {
  final String question;

  const WheelChangeQuestion(this.question);

  @override
  List<Object?> get props => [question];
}

class WheelChangeSkin extends WheelState {
  final String wheelSkin;

  const WheelChangeSkin(this.wheelSkin);

  @override
  List<Object?> get props => [wheelSkin];
}

class WheelLoop extends WheelState {
  final bool isLoop;

  const WheelLoop(this.isLoop);
  @override
  List<Object?> get props => [isLoop];
}

class WheelRemoveDuplicateChoice extends WheelState {}

class WheelShuffleChoice extends WheelState {}
