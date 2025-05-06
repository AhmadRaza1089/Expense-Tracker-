import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:track/firebase2/src/expense_reposit.dart';

part 'get_categories_event.dart';
part 'get_categories_state.dart';

class GetCategoriesBloc extends Bloc<GetCategoriesEvent, GetCategoriesState> {
  ExpenseRepo expenseRepo;
  GetCategoriesBloc(this.expenseRepo) : super(GetCategoriesInitial()) {
    on<GetCategoriesEvent>((event, emit) async {
      emit(GetCategoriesLoading());
      try {
        List<Category> categories =  await expenseRepo.getCategory();
        emit(GetCategoriesSuccess(categories));
      } catch (e) {
        emit(GetCategoriesFailure());
      }
    });
  }
}
