import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyChart extends StatelessWidget {
  const MyChart({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('expenses').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No expense data available"));
        }

        // Process data for the chart
        Map<String, double> categoryTotals = {};
        
        for (var doc in snapshot.data!.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          
          String category = data['category'] ?? 'Other';
          double amount = 0.0;
          
          if (data['amount'] is double) {
            amount = data['amount'];
          } else if (data['amount'] is int) {
            amount = (data['amount'] as int).toDouble();
          } else if (data['amount'] is String) {
            amount = double.tryParse(data['amount'] ?? '0') ?? 0.0;
          }
          
          categoryTotals[category] = (categoryTotals[category] ?? 0) + amount;
        }
        
        // Prepare the pie chart sections
        List<PieChartSectionData> sections = [];
        
        // Define colors for categories
        List<Color> colors = [
          const Color(0xFF0077B6),  // Blue
          const Color(0xFF4CAF50),  // Green
          const Color(0xFFFFC107),  // Amber
          const Color(0xFFFF5722),  // Deep Orange
          const Color(0xFF9C27B0),  // Purple
          const Color(0xFFE91E63),  // Pink
          const Color(0xFF795548),  // Brown
          const Color(0xFF607D8B),  // Blue Grey
        ];
        
        // Calculate total for percentage calculation
        double total = categoryTotals.values.reduce((a, b) => a + b);
        
        int colorIndex = 0;
        categoryTotals.forEach((category, amount) {
          // Calculate the percentage and ensure it's not displaying as 0.1%
          double percentage = (amount / total) * 100;
          String percentageText = percentage < 1 ? '<1%' : '${percentage.toStringAsFixed(0)}%';
          
          sections.add(
            PieChartSectionData(
              color: colors[colorIndex % colors.length],
              value: amount,
              title: percentageText,
              radius: 50,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          );
          colorIndex++;
        });

        // Return a container with fixed height for the chart
        return Container(
          padding: const EdgeInsets.all(16),
          // Use a fixed height or constrain the size to avoid overflow
          height: 220, // Adjust this value as needed
          child: Column(
            children: [
              // Chart section - take available space but not more than needed
              Expanded(
                child: PieChart(
                  PieChartData(
                    sections: sections,
                    centerSpaceRadius: 40,
                    sectionsSpace: 2,
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        // Handle touch events if needed
                      },
                    ),
                  ),
                ),
              ),
              
              // Category legend - shows what each color represents
              // Wrap in an Expanded to prevent overflow
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: List.generate(
                    categoryTotals.length,
                    (index) {
                      String category = categoryTotals.keys.elementAt(index);
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: colors[index % colors.length],
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            category,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}