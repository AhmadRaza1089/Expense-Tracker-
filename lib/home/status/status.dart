import 'package:flutter/material.dart';
import 'package:track/home/status/chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Status extends StatelessWidget {
  const Status({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('expenses').snapshots(),
      builder: (context, snapshot) {
        // Calculate total expenses and count
        double totalExpenses = 0;
        int expenseCount = 0;
        
        if (snapshot.hasData) {
          for (var doc in snapshot.data!.docs) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            double amount = 0.0;
            
            // Parse amount from various formats
            if (data['amount'] is double) {
              amount = data['amount'];
            } else if (data['amount'] is int) {
              amount = (data['amount'] as int).toDouble();
            } else if (data['amount'] is String) {
              amount = double.tryParse(data['amount']) ?? 0.0;
            }
            
            totalExpenses += amount;
            expenseCount++;
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with title and summary
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              margin: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row with icon
                  Row(
                    children: [
                      Icon(
                        Icons.bar_chart_rounded,
                        color: const Color(0xFF0077B6),
                        size: 28,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Expense Statistics",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0077B6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Summary cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Total expenses summary
                      _SummaryCard(
                        title: "Total Spent",
                        value: "\$${totalExpenses.toStringAsFixed(2)}",
                        icon: Icons.account_balance_wallet,
                        color: const Color(0xFF4CAF50),
                      ),
                      
                      // Expense count summary
                      _SummaryCard(
                        title: "Transactions",
                        value: "$expenseCount",
                        icon: Icons.receipt_long,
                        color: const Color(0xFF2196F3),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Chart section
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Category Breakdown",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      child: MyChart(),
                    ),
                  ],
                ),
              ),
            ),
            
            // Footer with time period selector
            Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _PeriodButton(
                    label: "Week",
                    isSelected: true,
                    onTap: () {
                      // Implement period filtering
                    },
                  ),
                  _PeriodButton(
                    label: "Month",
                    isSelected: false,
                    onTap: () {
                      // Implement period filtering
                    },
                  ),
                  _PeriodButton(
                    label: "Year",
                    isSelected: false,
                    onTap: () {
                      // Implement period filtering
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// Helper widget for summary cards
class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

// Helper widget for period selection buttons
class _PeriodButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PeriodButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0077B6) : Colors.transparent,
          border: Border.all(
            color: isSelected ? const Color(0xFF0077B6) : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }
}