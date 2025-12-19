import 'package:flutter/material.dart';
import '../../models/grocery.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  static const defaultName = 'New grocery';
  static const defaultQuantity = 1;
  static const defaultCategory = GroceryCategory.fruit;

  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  GroceryCategory _selectedCategory = defaultCategory;

  @override
  void initState() {
    super.initState();
    _nameController.text = defaultName;
    _quantityController.text = defaultQuantity.toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void onReset() {}

  void onAdd() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final grocery = Grocery(
      id: DateTime.now().toString(),
      name: _nameController.text.trim(),
      quantity: int.parse(_quantityController.text),
      category: _selectedCategory,
    );

    Navigator.pop(context, grocery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a new item')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // NAME
              TextFormField(
                controller: _nameController,
                maxLength: 50,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 10),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // QUANTITY
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(labelText: 'Quantity'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Quantity is required';
                        }
                        final number = int.tryParse(value);
                        if (number == null || number <= 0) {
                          return 'Enter a valid number';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(width: 8),

                  // CATEGORY
                  Expanded(
                    child: DropdownButtonFormField<GroceryCategory>(
                      value: _selectedCategory,
                      items: GroceryCategory.values.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Row(
                            children: [
                              Container(
                                width: 15,
                                height: 15,
                                color: category.color,
                              ),
                              const SizedBox(width: 8),
                              Text(category.label),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: onReset, child: const Text('Reset')),
                  ElevatedButton(
                    onPressed: onAdd,
                    child: const Text('Add Item'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
