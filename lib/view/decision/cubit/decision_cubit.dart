import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'decision_state.dart';

class DecisionCubit extends Cubit<DecisionState> {
  DecisionCubit() : super(DecisionInitial());

  chooseCardSkin(String cardSkin) {
    emit(DecisionChooseCardSkin(cardSkin: cardSkin));
  }

  setCardLoop(bool cardLoop) {
    emit(DecisionSetCardLoop(cardLoop));
  }
}
