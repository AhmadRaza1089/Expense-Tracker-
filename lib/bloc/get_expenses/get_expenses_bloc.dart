import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:track/firebase2/src/expense_reposit.dart';

part 'get_expenses_event.dart';
part 'get_expenses_state.dart';

class GetExpensesBloc extends Bloc<GetExpensesEvent, GetExpensesState> {
  ExpenseRepo expenseRep;
  GetExpensesBloc(this.expenseRep) : super(GetExpensesInitial()) {
    on<GetExpensesEvent>((event, emit) async {
      emit(GetExpensesLoading());
      try {
        List<Expense> expenses = await expenseRep.getExpense();
        emit(GetExpensesLoaded(expenses));
      } catch (e) {
        emit(GetExpensesError());
      }
    });
  }
}
