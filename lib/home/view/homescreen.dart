import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:track/bloc/create_catagory_bloc/bloc_bloc.dart';
import 'package:track/bloc/create_expense_bloc/create_expense_bloc.dart';
import 'package:track/bloc/delete_category_bloc/delete_category_bloc_bloc.dart';
import 'package:track/bloc/delete_expense_bloc/delete_expense_bloc_bloc.dart';
import 'package:track/bloc/get_categories/get_categories_bloc.dart';
import 'package:track/bloc/get_expenses/get_expenses_bloc.dart';
import 'package:track/firebase2/src/firebase_expense.dart';
import 'package:track/home/util/add_expenses/add_expense.dart';
import 'package:track/home/view/appbar.dart';
import 'package:track/home/view/mainscreen.dart';
import 'package:track/home/status/status.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Current page index
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Use MultiBlocProvider to provide all necessary blocs
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  GetExpensesBloc(FirebaseExpense())..add(GetExpenses()),
        ),
        // Add the DeleteExpenseBlocBloc provider here
        BlocProvider<DeleteExpenseBlocBloc>(
          create: (context) => DeleteExpenseBlocBloc(FirebaseExpense()),
        ),
      ],
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return BlocBuilder<GetExpensesBloc, GetExpensesState>(
      builder: (context, state) {
        if (state is GetExpensesLoaded) {
          // Pass the expenses data to MainScreen
          final expenses = state.expense;

          return Scaffold(
            backgroundColor: Color(0xFFF0F0F0),
            appBar: const ProfessionalAppBar(),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              elevation: 3.0,
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: false,
              items: [
                BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  icon: Icon(FontAwesomeIcons.house),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.chartSimple),
                  label: "Status",
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create:
                                  (context) =>
                                      GetCategoriesBloc(FirebaseExpense())
                                        ..add(GetCategories()),
                            ),
                            BlocProvider(
                              create: (context) => BlocBloc(FirebaseExpense()),
                              child: AddExpense(),
                            ),
                            BlocProvider(
                              create:
                                  (context) =>
                                      CreateExpenseBloc(FirebaseExpense()),
                            ),
                            BlocProvider<DeleteCategoryBlocBloc>(
                              create:
                                  (context) => DeleteCategoryBlocBloc(
                                    expenseRepo: FirebaseExpense(),
                                  ),
                            ),
                            BlocProvider<DeleteExpenseBlocBloc>(
                              create:
                                  (context) =>
                                      DeleteExpenseBlocBloc(FirebaseExpense()),
                            ),
                          ],
                          child: AddExpense(),
                        ),
                  ),
                );
              },
              child: Icon(Icons.add),
            ),
            body:
                _selectedIndex == 0
                    ? MainScreen(expenses: expenses) // Pass expenses correctly
                    : Status(),
          );
        } else {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}
