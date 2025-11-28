sealed class ExpenseEffect {}

class ExpenseAddedEffect extends ExpenseEffect {}

class ExpenseDeletedEffect extends ExpenseEffect {}

class ShowErrorEffect extends ExpenseEffect {
  final String message;
  ShowErrorEffect(this.message);
}
