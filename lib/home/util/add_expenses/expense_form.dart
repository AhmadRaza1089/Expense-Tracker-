import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:track/bloc/delete_category_bloc/delete_category_bloc_bloc.dart';
import 'package:track/bloc/delete_category_bloc/delete_category_bloc_state.dart';
import 'package:track/bloc/get_categories/get_categories_bloc.dart';
import 'package:track/firebase2/src/model/category.dart';
import 'package:track/firebase2/src/model/expense.dart';
import 'package:track/home/util/add_expenses/category_creation.dart';
import 'package:track/data/data.dart';
import 'package:uuid/uuid.dart';

class ExpenseForm extends StatefulWidget {
  final List<Category> categories;
  final bool isLoading;
  final Function(Expense expense) onExpenseCreated;

  const ExpenseForm({
    super.key,
    required this.categories,
    required this.isLoading,
    required this.onExpenseCreated,
  });

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  // Controllers
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  
  // State variables
  DateTime _selectedDate = DateTime.now();
  Category? _selectedCategory;
  String _selectedColor = "0xFF000000";
  String? _selectedIcon;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat("MMM dd, yyyy").format(_selectedDate);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _categoryController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // Helper function to get icon data
  IconData _getIconData(String? iconName) {
    if (iconName == null || iconName.isEmpty) {
      return FontAwesomeIcons.tag;
    }

    for (var item in data) {
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
      log('Color parsing error: $e');
      return Colors.grey;
    }
  }

  void _validateAndSubmit() {
    // Validate input
    if (_amountController.text.isEmpty) {
      _showError("Please enter an amount");
      return;
    }
    
    if (_categoryController.text.isEmpty) {
      _showError("Please select a category");
      return;
    }
    
    try {
      // Create a new expense object with the form data
      final newExpense = Expense(
        expenseId: const Uuid().v1(),
        category: _categoryController.text,
        date: _selectedDate,
        amount: int.parse(_amountController.text),
        color: _selectedColor,
        icon: _selectedIcon,
      );
      
      // Call the callback
      widget.onExpenseCreated(newExpense);
    } catch (e) {
      _showError("Error: ${e.toString()}");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteCategoryBlocBloc, DeleteCategoryBlocState>(
      listener: (context, state) {
        if (state is DeleteCategoryBlocLoaded) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          
          // If the deleted category was selected, clear the selection
          if (_selectedCategory != null && 
              _selectedCategory!.categoryId == state.deletedCategoryId.toString()) {
            setState(() {
              _selectedCategory = null;
              _categoryController.text = '';
            });
          }
          
          // Refresh the categories list
          context.read<GetCategoriesBloc>().add(GetCategories());
        } else if (state is DeleteCategoryBlocError) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: ${state.errorMessage}"),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount Field
              _buildSectionTitle("Amount"),
              const SizedBox(height: 8),
              _buildAmountField(),
              const SizedBox(height: 24),
              
              // Category Field
              _buildSectionTitle("Category"),
              const SizedBox(height: 8),
              _buildCategoryField(),
              const SizedBox(height: 16),
              
              // Categories List
              _buildCategoriesList(),
              const SizedBox(height: 24),
              
              // Date Field
              _buildSectionTitle("Date"),
              const SizedBox(height: 8),
              _buildDateField(),
              const SizedBox(height: 32),
              
              // Submit Button
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2A2D34),
        ),
      ),
    );
  }

  Widget _buildAmountField() {
    return Container(
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
      child: TextFormField(
        controller: _amountController,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          hintText: "0.00",
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF0077B6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              FontAwesomeIcons.dollarSign,
              color: Color(0xFF0077B6),
              size: 16,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildCategoryField() {
    return Container(
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
      child: TextFormField(
        controller: _categoryController,
        readOnly: true,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: "Select Category",
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF0077B6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              FontAwesomeIcons.tags,
              color: Color(0xFF0077B6),
              size: 16,
            ),
          ),
          suffixIcon: GestureDetector(
            onTap: () async {
              final Category? newCategory = await showCreateCategoryDialog(context);
              if (newCategory != null) {
                setState(() {
                  _categoryController.text = newCategory.name;
                  _selectedCategory = newCategory;
                  _selectedColor = newCategory.color;
                  _selectedIcon = newCategory.icon;
                });
              }
            },
            child: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                FontAwesomeIcons.plus,
                color: Color(0xFF0077B6),
                size: 16,
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildCategoriesList() {
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
      child: widget.categories.isEmpty
          ? const Center(
              child: Text(
                "No categories found.\nTap the + button to create one.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: widget.categories.length,
              itemBuilder: (context, index) {
                final category = widget.categories[index];
                final Color categoryColor = _getColorFromString(category.color);
                
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _categoryController.text = category.name;
                        _selectedCategory = category;
                        _selectedColor = category.color;
                        _selectedIcon = category.icon;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selectedCategory?.categoryId == category.categoryId
                            ? categoryColor.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: _selectedCategory?.categoryId == category.categoryId
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
                            fontWeight: _selectedCategory?.categoryId == category.categoryId
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
                            if (_selectedCategory?.categoryId == category.categoryId)
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

  Widget _buildDateField() {
    return Container(
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
      child: TextFormField(
        controller: _dateController,
        readOnly: true,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        onTap: () async {
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: _selectedDate,
            firstDate: DateTime(2000),
            lastDate: DateTime.now().add(const Duration(days: 30)),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: Color(0xFF0077B6),
                    onPrimary: Colors.white,
                    onSurface: Colors.black,
                  ),
                ),
                child: child!,
              );
            },
          );
          
          if (pickedDate != null) {
            setState(() {
              _selectedDate = pickedDate;
              _dateController.text = DateFormat("MMM dd, yyyy").format(pickedDate);
            });
          }
        },
        decoration: InputDecoration(
          hintText: "Select Date",
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF0077B6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              FontAwesomeIcons.calendar,
              color: Color(0xFF0077B6),
              size: 16,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: widget.isLoading ? null : _validateAndSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0077B6),
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
          ),
          child: widget.isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  "Add Expense",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
        ),
      ),
    );
  }
}