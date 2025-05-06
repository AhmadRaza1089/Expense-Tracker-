import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:track/bloc/delete_category_bloc/delete_category_bloc_bloc.dart';
import 'package:track/data/data.dart';
import 'package:track/firebase2/src/model/category.dart';

class CategoryList extends StatelessWidget {
  final List<Category> categories;
  final Function(Category) onCategorySelected;
  final Category? selectedCategory;

  const CategoryList({
    super.key,
    required this.categories,
    required this.onCategorySelected,
    this.selectedCategory,
  });

  // Helper function to get icon data
  IconData _getIconData(String? iconName) {
    if (iconName == null || iconName.isEmpty) {
      return FontAwesomeIcons.tag;
    }

    for (var item in data) {  // assuming 'data' is accessible
      if (item["name"] == iconName) {
        return item["icon"] as IconData;
      }
    }
    return FontAwesomeIcons.tag;
  }

  // Helper function to parse color
  Color _getColorFromString(String? colorStr) {
    if (colorStr == null || colorStr.isEmpty) {
      return Colors.grey;
    }

    try {
      return Color(int.parse(colorStr));
    } catch (e) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: categories.isEmpty
          ? const Center(
              child: Text(
                "No categories found.\nTap the + button to create one.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final Color categoryColor = _getColorFromString(category.color);
                
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: InkWell(
                    onTap: () {
                      onCategorySelected(category);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedCategory?.categoryId == category.categoryId
                            ? categoryColor.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: selectedCategory?.categoryId == category.categoryId
                            ? Border.all(color: categoryColor, width: 1)
                            : null,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        leading: CircleAvatar(
                          backgroundColor: categoryColor,
                          child: Icon(
                            _getIconData(category.icon),
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        title: Text(
                          category.name,
                          style: TextStyle(
                            fontWeight: selectedCategory?.categoryId == category.categoryId
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Delete icon button
                            IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.red.shade400,
                                size: 20,
                              ),
                              onPressed: () {
                                _showDeleteConfirmation(context, category);
                              },
                            ),
                            // Selected indicator
                            if (selectedCategory?.categoryId == category.categoryId)
                              Icon(
                                Icons.check_circle,
                                color: categoryColor,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Category category) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Delete Category"),
        content: Text("Are you sure you want to delete '${category.name}'? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              // Trigger the delete event
              context.read<DeleteCategoryBlocBloc>().add(
                DeleteCategoryEvent(categoryId: category.categoryId),
              );
              Navigator.pop(dialogContext);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}