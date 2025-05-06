import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:track/bloc/delete_category_bloc/delete_category_bloc_state.dart';
import 'package:track/firebase2/src/expense_repo.dart';

part 'delete_category_bloc_event.dart';

class DeleteCategoryBlocBloc extends Bloc<DeleteCategoryBlocEvent, DeleteCategoryBlocState> {
  final ExpenseRepo expenseRepo;
  
  DeleteCategoryBlocBloc({required this.expenseRepo})
      : super(DeleteCategoryBlocInitial()) {
    on<DeleteCategoryEvent>((event, emit) async {
      emit(DeleteCategoryBlocLoading());
      try {
        await expenseRepo.deleteCategory(event.categoryId);
        emit(DeleteCategoryBlocLoaded(
          message: "Category deleted successfully",
          success: true,
          deletedCategoryId: event.categoryId,
        ));
      } catch (e) {
        emit(DeleteCategoryBlocError(
          errorMessage: 'Error deleting category: ${e.toString()}',
        ));
      }
    });
  }
}