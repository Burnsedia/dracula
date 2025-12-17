import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/database_helper.dart';

class CategoryManagementScreen extends StatefulWidget {
  @override
  _CategoryManagementScreenState createState() =>
      _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  List<Category> categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoading = true);
    final cats = await DatabaseHelper.instance.readAllCategories();
    setState(() {
      categories = cats;
      _isLoading = false;
    });
  }

  void _addCategory() {
    _showCategoryDialog();
  }

  void _editCategory(Category category) {
    _showCategoryDialog(category: category);
  }

  void _deleteCategory(Category category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text(
            'Delete "${category.name}"? This will remove all associated entries.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (confirmed == true && category.id != null) {
      await DatabaseHelper.instance.deleteCategory(category.id!);
      await _loadCategories();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category deleted')),
        );
      }
    }
  }

  void _showCategoryDialog({Category? category}) {
    final nameController = TextEditingController(text: category?.name ?? '');
    final unitController = TextEditingController(text: category?.unit ?? '');
    String selectedType = category?.type ?? 'numeric';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category == null ? 'Add Category' : 'Edit Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Category Name'),
            ),
            TextField(
              controller: unitController,
              decoration: const InputDecoration(labelText: 'Unit (optional)'),
            ),
            DropdownButtonFormField<String>(
              value: selectedType,
              decoration: const InputDecoration(labelText: 'Type'),
              items: const [
                DropdownMenuItem(value: 'numeric', child: Text('Numeric')),
                DropdownMenuItem(value: 'text', child: Text('Text')),
              ],
              onChanged: (value) => selectedType = value ?? 'numeric',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final name = nameController.text.trim();
              final unit = unitController.text.trim().isEmpty
                  ? null
                  : unitController.text.trim();

              if (name.isNotEmpty) {
                final newCategory = Category(
                  id: category?.id,
                  name: name,
                  unit: unit,
                  type: selectedType,
                );

                if (category == null) {
                  await DatabaseHelper.instance.createCategory(newCategory);
                } else {
                  await DatabaseHelper.instance.updateCategory(newCategory);
                }

                await _loadCategories();
                Navigator.pop(context);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(category == null
                            ? 'Category added'
                            : 'Category updated')),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addCategory,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : categories.isEmpty
              ? const Center(
                  child: Text(
                    'No custom categories yet.\nTap + to add one.',
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return ListTile(
                      title: Text(category.name),
                      subtitle: Text(
                          '${category.type}${category.unit != null ? ' (${category.unit})' : ''}'),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _editCategory(category);
                          } else if (value == 'delete') {
                            _deleteCategory(category);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                              value: 'edit', child: Text('Edit')),
                          const PopupMenuItem(
                              value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
