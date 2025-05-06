import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:track/firebase2/src/expense_repo.dart';

part 'delete_expense_bloc_event.dart';
part 'delete_expense_bloc_state.dart';

class DeleteExpenseBlocBloc
    extends Bloc<DeleteExpenseBlocEvent, DeleteExpenseBlocState> {
  final ExpenseRepo expenseRepo;
  
  DeleteExpenseBlocBloc(this.expenseRepo) : super(DeleteExpenseBlocInitial()) {
    on<DeleteExpenseEvent>((event, emit) async {
      emit(DeleteExpenseBlocLoading());
      try {
        await expenseRepo.deleteExpense(event.expenseId);
        emit(
          DeleteExpenseBlocLoaded(
            deletedCategoryId: event.expenseId,
            message: "Expense deleted successfully",
            success: true,
          ),
        );
      } catch (e) {
        emit(DeleteExpenseBlocError());
      }
    });
  }
}