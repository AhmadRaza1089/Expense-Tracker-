
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track/bloc/delete_expense_bloc/delete_expense_bloc_bloc.dart';
import 'package:track/firebase2/src/model/expense.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:track/home/view/credit_card_widget.dart';
import 'package:track/home/view/expense_util.dart';
import 'package:track/firebase2/src/firebase_expense.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.expenses});
  final List<Expense> expenses; // Keep this for initial data or fallback

  // Function to show delete confirmation dialog
  void _showDeleteConfirmation(BuildContext context, String expenseId, String category) {
    // Create a local instance of the DeleteExpenseBlocBloc for this dialog
    final deleteBloc = DeleteExpenseBlocBloc(FirebaseExpense());
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Expense'),
        content: Text('Are you sure you want to delete this $category expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              // Use the local bloc instance
              deleteBloc.add(DeleteExpenseEvent(expenseId: expenseId));
              Navigator.pop(dialogContext); // Close dialog

              // Show feedback to user
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Expense deleted successfully'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Provide DeleteExpenseBlocBloc directly in this widget to ensure it's available
    return BlocProvider(
      create: (context) => DeleteExpenseBlocBloc(FirebaseExpense()),
      child: BlocListener<DeleteExpenseBlocBloc, DeleteExpenseBlocState>(
        listener: (context, state) {
          // Handle different states from the DeleteExpenseBloc
          if (state is DeleteExpenseBlocError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to delete expense'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Enhanced profile header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Row(
                  children: [
                    // Profile avatar with better visual style
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFFFC107), Color(0xFFFFD54F)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.person, color: Colors.white, size: 24),
                      ],
                    ),
                    SizedBox(width: 12),

                    // Welcome text with improved styling
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome back,",
                          style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                        ),
                        Text(
                          "Ahmed Raza",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),

                    // Settings button with improved visual style
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[100],
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.settings_outlined),
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),

              // Enhanced Credit Card - Now using the separate widget
              CreditCardWidget(
                bankName: 'UBL',
                cardNumber: '•••• •••• •••• 4567',
                cardholderName: 'AHMED RAZA',
                expiryDate: '04/28',
                balance: 'Rs:10,000',
                cardType: 'PLATINUM',
              ),
              
              SizedBox(height: 16), // Add space after the card

              // Income & Expense Summary
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Income summary
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green.withOpacity(0.2),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_downward,
                              size: 18.0,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Income",
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Rs:20,000",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Divider
                    Container(height: 40, width: 1, color: Colors.grey[200]),

                    // Expense summary
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red.withOpacity(0.2),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_upward,
                              size: 18.0,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Expenses",
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Rs:15,000",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Transactions header with improved design
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recent Transactions",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // View all transactions
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Color(0xFF0077B6),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 8.0,
                        ),
                      ),
                      child: Text(
                        "View All",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),

              // Transaction List using StreamBuilder with Swipe-to-Delete
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('expenses').orderBy('date', descending: true).snapshots(),
                builder: (context, snapshot) {
                  // Show loading indicator while data is loading
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  
                  // Show error if there's an error
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Error loading transactions'),
                      ),
                    );
                  }
                  
                  // Show empty message if there's no data
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('No transactions found'),
                      ),
                    );
                  }
                  
                  // Convert Firestore documents to Expense objects
                  List<Expense> expensesList = snapshot.data!.docs.map((doc) {
                    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                    
                    // Convert Timestamp to DateTime if needed
                    DateTime date;
                    if (data['date'] is Timestamp) {
                      date = (data['date'] as Timestamp).toDate();
                    } else {
                      // Fallback if date is stored differently
                      date = DateTime.now();
                    }
                    
                    return Expense(
                      expenseId: doc.id,
                      amount: data['amount'] ?? 0.0,
                      category: data['category'] ?? 'Unknown',
                      date: date,
                      icon: data['icon'],
                      color: data['color'], 
                    );
                  }).toList();
                  
                  // Build ListView with the fetched expenses and swipe-to-delete functionality
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: expensesList.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(bottom: 16),
                    itemBuilder: (listContext, index) {
                      // Get a bloc reference from the provider
                      final deleteBloc = context.read<DeleteExpenseBlocBloc>();
                      
                      // Parse color from the expense color string
                      Color itemColor = ExpenseUtils.getColorFromString(expensesList[index].color);
                      // Get icon data from the expense icon string
                      IconData iconData = ExpenseUtils.getIconData(expensesList[index].icon);
                      
                      // Wrap the transaction item with Dismissible for swipe-to-delete
                      return Dismissible(
                        key: Key(expensesList[index].expenseId),
                        background: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.red,
                          ),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          // Show confirmation dialog
                          bool? result;
                          await showDialog(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              title: Text('Delete Expense'),
                              content: Text('Are you sure you want to delete this ${expensesList[index].category} expense?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(dialogContext, false),
                                  child: Text('Cancel', style: TextStyle(color: Colors.grey)),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(dialogContext, true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          ).then((value) => result = value);
                          
                          return result ?? false;
                        },
                        onDismissed: (direction) {
                          // Delete the expense through the bloc
                          deleteBloc.add(
                            DeleteExpenseEvent(expenseId: expensesList[index].expenseId),
                          );
                          
                          // Show a snackbar confirmation
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${expensesList[index].category} expense deleted'),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              action: SnackBarAction(
                                label: 'UNDO',
                                onPressed: () {
                                  // In a real app, you'd implement undo functionality here
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Undo functionality not implemented'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onLongPress: () => _showDeleteConfirmation(
                              context, 
                              expensesList[index].expenseId,
                              expensesList[index].category,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 12.0,
                              ),
                              child: Row(
                                children: [
                                  // Leading icon with the expense's color
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: itemColor.withOpacity(0.2),
                                    ),
                                    child: Icon(
                                      iconData,
                                      color: itemColor,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(width: 12),

                                  // Title and subtitle
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          expensesList[index].category,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          DateFormat("yyyy-MM-dd").format(expensesList[index].date),
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Amount
                                  Text(
                                    "Rs:${expensesList[index].amount}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),

                                  // Add delete icon
                                  SizedBox(width: 8),
                                  Builder(
                                    builder: (innerContext) => InkWell(
                                      onTap: () => _showDeleteConfirmation(
                                        context, 
                                        expensesList[index].expenseId,
                                        expensesList[index].category,
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red.withOpacity(0.1),
                                        ),
                                        child: Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}