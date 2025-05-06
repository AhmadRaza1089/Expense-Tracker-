// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:track/firebase2/src/model/category.dart';

class ExpenseEntity {
  String expenseId;
  Category category;
  DateTime data;
  int amount;
  ExpenseEntity({
    required this.expenseId,
    required this.category,
    required this.data,
    required this.amount,
  });

  ExpenseEntity copyWith({
    String? expenseId,
    Category? category,
    DateTime? data,
    int? amount,
  }) {
    return ExpenseEntity(
      expenseId: expenseId ?? this.expenseId,
      category: category ?? this.category,
      data: data ?? this.data,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'expenseId': expenseId,
      'category': category.toMap(),
      'data': data.millisecondsSinceEpoch,
      'amount': amount,
    };
  }

  factory ExpenseEntity.fromMap(Map<String, dynamic> map) {
    return ExpenseEntity(
      expenseId: map['expenseId'] as String,
      category: Category.fromMap(map['category'] as Map<String,dynamic>),
      data: DateTime.fromMillisecondsSinceEpoch(map['data'] as int),
      amount: map['amount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpenseEntity.fromJson(String source) => ExpenseEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ExpenseEntity(expenseId: $expenseId, category: $category, data: $data, amount: $amount)';
  }

  @override
  bool operator ==(covariant ExpenseEntity other) {
    if (identical(this, other)) return true;
  
    return 
      other.expenseId == expenseId &&
      other.category == category &&
      other.data == data &&
      other.amount == amount;
  }

  @override
  int get hashCode {
    return expenseId.hashCode ^
      category.hashCode ^
      data.hashCode ^
      amount.hashCode;
  }
}
