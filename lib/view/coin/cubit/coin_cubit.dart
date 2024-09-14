import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'coin_state.dart';

class CoinCubit extends Cubit<CoinState> {
  CoinCubit() : super(CoinInitial());

  chooseCoinSkin(String coinSkin) {
    emit(CoinChooseCoinSkin(coinSkin: coinSkin));
  }
}
