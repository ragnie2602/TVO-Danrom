part of 'number_cubit.dart';

abstract class NumberState extends Equatable {
  const NumberState();
  @override
  List<Object?> get props => [];
}

class NumberInitial extends NumberState {}

class NumberHasGenerated extends NumberState {
  final int? index;
  final int number;

  const NumberHasGenerated(this.number, {this.index});
  @override
  List<Object?> get props => [number, index];
}

class NumbersHaveGeneratedAll extends NumberState {
  final List<int> numbers;

  const NumbersHaveGeneratedAll(this.numbers);
  @override
  List<Object?> get props => [numbers];
}

class NumberIsDuplicated extends NumberState {
  final int index;
  final List<int> newResults;

  const NumberIsDuplicated(this.index, this.newResults);
  @override
  List<Object?> get props => [index, newResults];
}
