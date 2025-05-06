part of 'delete_expense_bloc_bloc.dart';

@immutable
abstract  class DeleteExpenseBlocEvent {}

class DeleteExpenseEvent extends DeleteExpenseBlocEvent {
  final String expenseId;
  DeleteExpenseEvent({required this.expenseId});
}
