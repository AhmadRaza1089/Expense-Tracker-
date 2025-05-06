part of 'create_expense_bloc.dart';

@immutable
sealed class CreateExpenseState {}

final class CreateExpenseInitial extends CreateExpenseState {}
final class CreateExpenseFailure extends CreateExpenseState {}
final class CreateExpenseLoading extends CreateExpenseState {}
final class CreateExpenseLoaded extends CreateExpenseState {}
