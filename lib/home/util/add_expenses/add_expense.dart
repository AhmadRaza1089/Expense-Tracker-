import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/bloc/create_expense_bloc/create_expense_bloc.dart';
import 'package:track/bloc/get_categories/get_categories_bloc.dart';
import 'package:track/firebase2/src/model/expense.dart';
import 'package:track/home/util/add_expenses/expense_form.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  bool isLoading = false;
  late Expense expense;

  @override
  void initState() {
    super.initState();
    expense = Expense.empty();
    
    // Fetch categories when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshCategories();
    });
  }

  // Method to refresh categories
  void _refreshCategories() {
    final getCategoriesBloc = BlocProvider.of<GetCategoriesBloc>(context);
    getCategoriesBloc.add(GetCategories());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateExpenseBloc, CreateExpenseState>(
      listener: (context, state) {
        if (state is CreateExpenseLoaded) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Expense added successfully!"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context);
        } else if (state is CreateExpenseLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is CreateExpenseFailure) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: $state"),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF0077B6)),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "New Expense",
            style: TextStyle(
              color: Color(0xFF0077B6),
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: const Color(0xFFF8F9FA),
        body: BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
          builder: (context, state) {
            if (state is GetCategoriesLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF0077B6),
                ),
              );
            } else if (state is GetCategoriesSuccess) {
              return SafeArea(
                child: ExpenseForm(
                  categories: state.categories,
                  isLoading: isLoading,
                  onExpenseCreated: (newExpense) {
                    setState(() {
                      expense = newExpense;
                      isLoading = true;
                    });
                    
                    context.read<CreateExpenseBloc>().add(
                      CreateExpense(newExpense),
                    );
                  },
                ),
              );
            } else if (state is GetCategoriesFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Error loading categories: $state",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _refreshCategories,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0077B6),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Try Again"),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: Text("No categories available"),
              );
            }
          },
        ),
      ),
    );
  }
}