import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddExpenseFormState {
  final DateTime selectedDate;

  const AddExpenseFormState({required this.selectedDate});

  AddExpenseFormState copyWith({DateTime? selectedDate}) {
    return AddExpenseFormState(selectedDate: selectedDate ?? this.selectedDate);
  }
}

class AddExpenseFormViewModel extends StateNotifier<AddExpenseFormState> {
  AddExpenseFormViewModel()
    : super(AddExpenseFormState(selectedDate: DateTime.now()));

  void updateDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void resetForm() {
    state = AddExpenseFormState(selectedDate: DateTime.now());
  }
}
