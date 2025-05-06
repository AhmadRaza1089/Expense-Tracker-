// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CategoryEntity {
  String categoryId;
  String name;
  String totalExpense;
  String color;
  CategoryEntity({
    required this.categoryId,
    required this.name,
    required this.totalExpense,
    required this.color,
  });

  CategoryEntity copyWith({
    String? categoryId,
    String? name,
    String? totalExpense,
    String? color,
  }) {
    return CategoryEntity(
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      totalExpense: totalExpense ?? this.totalExpense,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'categoryId': categoryId,
      'name': name,
      'totalExpense': totalExpense,
      'color': color,
    };
  }

  factory CategoryEntity.fromMap(Map<String, dynamic> map) {
    return CategoryEntity(
      categoryId: map['categoryId'] as String,
      name: map['name'] as String,
      totalExpense: map['totalExpense'] as String,
      color: map['color'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryEntity.fromJson(String source) => CategoryEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CategoryEntity(categoryId: $categoryId, name: $name, totalExpense: $totalExpense, color: $color)';
  }

  @override
  bool operator ==(covariant CategoryEntity other) {
    if (identical(this, other)) return true;
  
    return 
      other.categoryId == categoryId &&
      other.name == name &&
      other.totalExpense == totalExpense &&
      other.color == color;
  }

  @override
  int get hashCode {
    return categoryId.hashCode ^
      name.hashCode ^
      totalExpense.hashCode ^
      color.hashCode;
  }
}
