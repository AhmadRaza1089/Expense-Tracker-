import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:track/bloc/create_catagory_bloc/bloc_bloc.dart';
import 'package:track/bloc/get_categories/get_categories_bloc.dart';
import 'package:track/data/data.dart';
import 'package:track/firebase2/src/model/category.dart';
import 'package:uuid/uuid.dart';

Future<Category?> showCreateCategoryDialog(BuildContext context) {
  String? iconSelected = "default_icon";
  Color colorCategory = Colors.blue;
  final blocBloc = BlocProvider.of<BlocBloc>(context);
  final getCategoriesBloc = BlocProvider.of<GetCategoriesBloc>(context);

  return showDialog<Category?>(
    context: context,
    builder: (dialogContext) {
      bool showIconGrid = false;
      TextEditingController categoryNameController = TextEditingController();
      TextEditingController categoryIconController = TextEditingController();
      TextEditingController categoryColorController = TextEditingController();
      
      return StatefulBuilder(
        builder: (dialogContext, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.9,
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Create a Category",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: categoryNameController,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "Category Name",
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: categoryIconController,
                        onTap: () {
                          setState(() {
                            showIconGrid = !showIconGrid;
                          });
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          suffixIcon: Icon(FontAwesomeIcons.caretDown, size: 16),
                          isDense: true,
                          hintText: "Icon",
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, 
                            vertical: 12,
                          ),
                        ),
                      ),
                      if (showIconGrid)
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: GridView.builder(
                            padding: const EdgeInsets.all(8),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 8.0,
                              crossAxisSpacing: 8.0,
                              crossAxisCount: 4,
                              childAspectRatio: 1.0,
                            ),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              String iconName = data[index]["name"]?.toString() ?? "default_icon";
                              
                              return Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    setState(() {
                                      iconSelected = iconName;
                                      categoryIconController.text = iconName;
                                      showIconGrid = false;
                                    });
                                    log("Item $iconName clicked");
                                  },
                                  child: Center(
                                    child: Icon(
                                      data[index]["icon"] as IconData,
                                      size: 24,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: categoryColorController,
                        onTap: () {
                          showDialog(
                            context: dialogContext,
                            builder: (colorDialogContext) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width * 0.8,
                                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            "Select Color",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          ColorPicker(
                                            pickerColor: colorCategory,
                                            onColorChanged: (value) {
                                              setState(() {
                                                colorCategory = value;
                                                categoryColorController.text = "Selected";
                                              });
                                            },
                                            pickerAreaHeightPercent: 0.8,
                                            enableAlpha: false,
                                            labelTypes: const [],
                                          ),
                                          const SizedBox(height: 16),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              backgroundColor: Colors.black,
                                              padding: const EdgeInsets.symmetric(vertical: 12),
                                            ),
                                            onPressed: () {
                                              log("Color Select");
                                              Navigator.pop(colorDialogContext);
                                            },
                                            child: const Text(
                                              "Save",
                                              style: TextStyle(color: Colors.white),
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
                        readOnly: true,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "Color",
                          fillColor: colorCategory,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          // Validation
                          final name = categoryNameController.text.isNotEmpty 
                              ? categoryNameController.text 
                              : "New Category";
                          
                          // Create category
                          Category category = Category(
                            icon: iconSelected,
                            categoryId: const Uuid().v1(),
                            name: name,
                            totalExpense: "0",
                            color: colorCategory.value.toString()
                          );

                          try {
                            blocBloc.add(CreateCategory(category));
                            getCategoriesBloc.add(GetCategories());
                            Navigator.of(dialogContext).pop(category);
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Category created successfully"),
                              ),
                            );
                          } catch (e) {
                            log("Error creating category: $e");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Error creating category: $e"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "Save Category",
                          style: TextStyle(color: Colors.white),
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
  );
}