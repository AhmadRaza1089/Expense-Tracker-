import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:track/data/data.dart';

/// Utility class for expense-related functions
/// Extracts the helper methods from MainScreen to improve separation of concerns
class ExpenseUtils {
  /// Parse a color from a string representation
  /// 
  /// Takes a color string (typically an integer value stored as string)
  /// and converts it to a Flutter Color object
  static Color getColorFromString(String? colorStr) {
    if (colorStr == null || colorStr.isEmpty) {
      return Colors.grey; // Default color
    }

    try {
      // Try to parse the color, assuming it's a valid integer representation
      return Color(int.parse(colorStr));
    } catch (e) {
      log('Color parsing error: $e');
      return Colors.grey; // Default color in case of error
    }
  }

  /// Get the appropriate IconData from an icon name string
  /// 
  /// Looks up the icon in the data list based on the provided name
  /// Returns a default icon if the name doesn't match any entry
  static IconData getIconData(String? iconName) {
    // Handle null or empty iconName
    if (iconName == null || iconName.isEmpty) {
      return Icons.receipt; // Default icon for expenses
    }

    // Find the icon in the data list
    for (var item in data) {
      if (item["name"] == iconName) {
        return item["icon"] as IconData;
      }
    }

    // Return a default icon if not found
    return Icons.receipt;
  }
}