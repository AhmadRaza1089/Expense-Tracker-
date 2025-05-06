// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Expense {
  String expenseId;
  String category;
  DateTime date;
  int amount;
  String ?color;
  String? icon;
  
  Expense({
    required this.expenseId,
    required this.category,
    required this.date,
    required this.amount,
    required this.color,
    this.icon,
  });
  
  static Expense empty() {
    return Expense(
      expenseId: '',
      category: '',
      date: DateTime.now(),
      amount: 0,
      color: '0xFF000000',
      icon: null,
    );
  }
  
  Expense copyWith({
    String? expenseId,  // Fixed parameter name
    String? category,
    DateTime? date,
    int? amount,
    String? color,
    String? icon,
  }) {
    return Expense(
      expenseId: expenseId ?? this.expenseId,  // Fixed parameter usage
      category: category ?? this.category,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      color: color ?? this.color,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {  // Added proper type annotation
    return {
      'expense': expenseId,
      'category': category,
      'date': date.millisecondsSinceEpoch,
      'amount': amount,
      'color': color,
      'icon': icon,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {  // Added proper type annotation
    return Expense(
      expenseId: map['expense'] as String,
      category: map['category'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      amount: map['amount'] as int,
      color: map['color']?.toString() ?? '0xFF000000',
      icon: map['icon'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory Expense.fromJson(String source) => Expense.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Expense(expenseId: $expenseId, category: $category, date: $date, amount: $amount, color: $color, icon: $icon)';
  }

  @override
  bool operator ==(covariant Expense other) {
    if (identical(this, other)) return true;
    
    return 
      other.expenseId == expenseId &&
      other.category == category &&
      other.date == date &&
      other.amount == amount &&
      other.color == color &&
      other.icon == icon;
  }

  @override
  int get hashCode {
    return expenseId.hashCode ^
      category.hashCode ^
      date.hashCode ^
      amount.hashCode ^
      color.hashCode ^
      (icon?.hashCode ?? 0);
  }
}