import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'number_state.dart';

class NumberCubit extends Cubit<NumberState> {
  NumberCubit() : super(NumberInitial());

  hasGenerate(int number, {int? index}) {
    emit(NumberHasGenerated(number, index: index));
  }

  haveGeneratedAll(List<int> numbers) {
    emit(NumbersHaveGeneratedAll(numbers));
  }

  blank() {
    emit(NumberInitial());
  }

  isDuplicate(int index, List<int> newResults) {
    emit(NumberIsDuplicated(index, newResults));
  }
}
