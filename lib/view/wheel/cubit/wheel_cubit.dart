import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'wheel_state.dart';

class WheelCubit extends Cubit<WheelState> {
  WheelCubit() : super(WheelInitial());

  changeChoices() {
    emit(WheelInitial());
    emit(WheelChangeChoices());
    emit(WheelInitial());
  }

  changeDuration(int duration) {
    emit(WheelInitial());
    emit(WheelChangeDuration(duration));
  }

  changeLoopable(bool isLoop) {
    emit(WheelInitial());
    emit(WheelLoop(isLoop));
  }

  changeQuestion(String question) {
    emit(WheelInitial());
    emit(WheelChangeQuestion(question));
  }

  changeSkin(String wheelSkin) {
    emit(WheelInitial());
    emit(WheelChangeSkin(wheelSkin));
  }

  removeDuplicateChoices() {
    emit(WheelInitial());
    emit(WheelRemoveDuplicateChoice());
  }

  shuffleChoices() {
    emit(WheelInitial());
    emit(WheelShuffleChoice());
  }
}
