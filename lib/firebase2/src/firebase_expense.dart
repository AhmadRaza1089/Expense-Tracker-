import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:track/firebase2/src/expense_repo.dart';
import 'package:track/firebase2/src/model/category.dart';
import 'package:track/firebase2/src/model/expense.dart';

class FirebaseExpense implements ExpenseRepo {
  final categoryCollection = FirebaseFirestore.instance.collection(
    "categories",
  );
  final expenseCollection = FirebaseFirestore.instance.collection("expenses");

  @override
  Future<void> createCategory(Category category) async {
    try {
      await categoryCollection.doc(category.categoryId).set(category.toMap());
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<List<Category>> getCategory() async {
    try {
      final snapshot = await categoryCollection.get();
      return snapshot.docs.map((doc) => Category.fromMap(doc.data())).toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  @override
  Future<void> createExpense(Expense expense) async {
    try {
      await expenseCollection.doc(expense.expenseId).set(expense.toMap());
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<List<Expense>> getExpense() async {
    try {
      final snapshot = await expenseCollection.get();
      return snapshot.docs.map((doc) => Expense.fromMap(doc.data())).toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  @override
  Future<void> deleteCategory(String categoryId) async{
  try {
      await categoryCollection.doc(categoryId).delete();
      log('Category successfully deleted');
    } catch (e) {
      log('Error deleting category: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteExpense(String expenseId) async{
    try {
      await expenseCollection.doc(expenseId).delete();
      log('Expense successfully deleted');
    } catch (e) {
      log('Error deleting expense: ${e.toString()}');
    }
  }
}
