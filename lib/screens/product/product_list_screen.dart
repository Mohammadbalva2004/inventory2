
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory/models/product.dart';
import 'package:inventory/providers/app_theme.dart';
import '../../common/common_data_table.dart';

class ProductListScreen extends StatefulWidget {
  final Function(String, {Product? product})? onNavigate;
  const ProductListScreen({super.key, this.onNavigate});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = [];
  bool isLoading = true;
  String? errorMessage;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts({String search = ''}) async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final url =
          search.trim().isNotEmpty
              ? 'http://192.168.0.160:8080/api/v1/product/products?search=$search'
              : 'http://192.168.0.160:8080/api/v1/product';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          products = jsonData.map((e) => Product.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load products';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> updateProductStatus(String id, String newStatus) async {
    try {
      final response = await http.patch(
        Uri.parse('http://192.168.0.160:8080/api/v1/product/$id/$newStatus'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status updated to $newStatus'),
            backgroundColor: Colors.green,
          ),
        );
        fetchProducts();
      } else {
        throw Exception(
          'Failed to update status. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      bool? confirmDelete = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Confirm Delete'),
              content: const Text(
                'Are you sure you want to delete this product?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Delete'),
                ),
              ],
            ),
      );

      if (confirmDelete == true) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );

        final response = await http.delete(
          Uri.parse('http://192.168.0.160:8080/api/v1/product/$productId'),
        );

        Navigator.of(context).pop();

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          fetchProducts();
        } else {
          throw Exception(
            'Failed to delete product. Status: ${response.statusCode}',
          );
        }
      }
    } catch (e) {
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting product: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Product List',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) => fetchProducts(search: value),
                    decoration: InputDecoration(
                      hintText: 'Search Products...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          searchController.clear();
                          fetchProducts();
                        },
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => widget.onNavigate?.call('/product/add'),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Product'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage != null
                    ? Center(child: Text("Server error"))
                    : products.isEmpty
                    ? const Center(child: Text('No Product   Found'))
                    : buildDataTable(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDataTable() {
    return Column(
      children: [
        Expanded(
          child:
          CommonDataTable(
            columnTitles: [
              'Product Name',
              'Product Code',
              'Description',
              'Image',
              'Stock',
              // 'Reference ID',
              // 'Organization ID',
              // 'Category ID',
              // 'Warehouse ID',
              // 'Supplier ID',
              'Status',
            ],
            hasActions: true,
            rowCells:
            products.map((product) {
              final isActive = product.status == 'ACTIVE';
              return [
                Text(product.productName ?? ''),
                Text(product.productCode ?? ''),
                Text(product.description ?? ''),
                Text(product.productImage ?? ''),

                Text(product.stock?.toString() ?? '0'),
                // Text(product.referenceProductId ?? ''),
                // Text(product.organizationId ?? ''),
                // Text(product.categoryId ?? ''),
                // Text(product.wareHouseId ?? ''),
                // Text(product.supplierId ?? ''),
                Switch(
                  value: isActive,
                  activeColor: Colors.green,
                  inactiveThumbColor: Colors.red,
                  onChanged: (value) {
                    final newStatus =
                    value ? 'ACTIVE' : 'INACTIVE';
                    updateProductStatus(
                      product.productId ?? '',
                      newStatus,
                    );
                  },
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                      onPressed: () async {
                        try {
                          final response = await http.get(
                            Uri.parse(
                              'http://192.168.0.160:8080/api/v1/product/${product.productId}',
                            ),
                          );
                          if (response.statusCode ==
                              200) {
                            final jsonData = jsonDecode(
                              response.body,
                            );
                            final fullProduct =
                            Product.fromJson(
                              jsonData,
                            );
                            widget.onNavigate?.call(
                              '/product/edit',
                              product: fullProduct,
                            );
                          } else {
                            throw Exception(
                              'Failed to fetch Product',
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            SnackBar(
                              content: Text('Error: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed:
                          () => deleteProduct(
                        product.productId ?? '',
                      ),
                    ),
                  ],
                ),
              ];
            }).toList(),
          ),


        ),
      ],
    );
  }


}
