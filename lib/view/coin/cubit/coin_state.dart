part of 'coin_cubit.dart';

abstract class CoinState extends Equatable {
  const CoinState();
  @override
  List<Object?> get props => [];
}

class CoinInitial extends CoinState {}

class CoinChooseCoinSkin extends CoinState {
  final String coinSkin;

  const CoinChooseCoinSkin({required this.coinSkin});
  @override
  List<Object?> get props => [coinSkin];
}
