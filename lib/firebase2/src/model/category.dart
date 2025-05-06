// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Category {
  String categoryId;
  String name;
  String totalExpense;
  String color;
  String? icon; // Made nullable to handle null icons

  Category({
    required this.categoryId,
    required this.name,
    required this.totalExpense,
    required this.color,
    required this.icon, // Still required but can accept null
  });

  Category copyWith({
    String? categoryId,
    String? name,
    String? totalExpense,
    String? color,
    String? icon,
  }) {
    return Category(
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      totalExpense: totalExpense ?? this.totalExpense,
      color: color ?? this.color,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'categoryId': categoryId,
      'name': name,
      'totalExpense': totalExpense,
      'color': color,
      'icon': icon,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      categoryId: map['categoryId'] as String,
      name: map['name'] as String,
      totalExpense: map['totalExpense'] as String,
      // Handle color properly - ensure it's converted to String
      color: map['color']?.toString() ?? '0xFF000000', // Default black color if null
      // Handle icon properly - might be null
      icon: map['icon'] != null ? map['icon'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) => Category.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Category(categoryId: $categoryId, name: $name, totalExpense: $totalExpense, color: $color, icon: $icon)';
  }

  @override
  bool operator ==(covariant Category other) {
    if (identical(this, other)) return true;
  
    return 
      other.categoryId == categoryId &&
      other.name == name &&
      other.totalExpense == totalExpense &&
      other.color == color &&
      other.icon == icon;
  }

  @override
  int get hashCode {
    return categoryId.hashCode ^
      name.hashCode ^
      totalExpense.hashCode ^
      color.hashCode ^
      icon.hashCode;
  }
}