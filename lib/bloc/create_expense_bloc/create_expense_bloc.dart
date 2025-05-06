import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:track/firebase2/src/expense_reposit.dart';
part 'create_expense_event.dart';
part 'create_expense_state.dart';
// Modified CreateExpenseBloc class
class CreateExpenseBloc extends Bloc<CreateExpenseEvent, CreateExpenseState> {
  ExpenseRepo expenseRepo;
  CreateExpenseBloc(this.expenseRepo) : super(CreateExpenseInitial()) {
    on<CreateExpense>((event, emit) async {
      emit(CreateExpenseLoading());
      try {
        await expenseRepo.createExpense(event.expense);
        emit(CreateExpenseLoaded());
      } catch (e) {
        emit(CreateExpenseFailure());
      }
    });
  }
}
