sealed class ExpenseEvent {}

class LoadExpensesEvent extends ExpenseEvent {}

class AddExpenseEvent extends ExpenseEvent {
  final String title;
  final double amount;
  final DateTime date;
  final String category;

  AddExpenseEvent({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });
}

class DeleteExpenseEvent extends ExpenseEvent {
  final String id;

  DeleteExpenseEvent(this.id);
}
