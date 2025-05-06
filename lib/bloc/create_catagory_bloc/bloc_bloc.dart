import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:track/firebase2/src/expense_repo.dart';
import 'package:track/firebase2/src/model/category.dart';

part 'bloc_event.dart';
part 'bloc_state.dart';

class BlocBloc extends Bloc<BlocEvent, BlocState> {
  final ExpenseRepo expenseRepo;
  
  BlocBloc(this.expenseRepo) : super(BlocInitial()) {
    // Handle each event type specifically
    on<CreateCategory>((event, emit) async {
      emit(CategoryLoading());
      try {
        await expenseRepo.createCategory(event.category); // Use event.category instead of event.
        emit(CategorySuccess());
      } catch (e) {
        emit(CategoryFailer());
      }
    });
  }
}