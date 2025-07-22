// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:inventory/models/product.dart';
// import 'package:inventory/providers/app_theme.dart';
//
// class AddProductScreen extends StatefulWidget {
//   final bool isEditMode;
//   final Product? product;
//   final Function(String route)? onNavigate;
//
//   const AddProductScreen({
//     super.key,
//     this.isEditMode = false,
//     this.onNavigate,
//     this.product,
//   });
//
//   @override
//   State<AddProductScreen> createState() => _AddProductScreenState();
// }
//
// class _AddProductScreenState extends State<AddProductScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _brandController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _imageUrlController = TextEditingController();
//   final _stockController = TextEditingController();
//   final _lowStockController = TextEditingController();
//   final _referenceProductIdController = TextEditingController();
//   final _organizationIdController = TextEditingController();
//   final _categoryIdController = TextEditingController();
//   final _warehouseIdController = TextEditingController();
//   final _supplierIdController = TextEditingController();
//
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.isEditMode && widget.product != null) {
//       _loadForm(widget.product!);
//     }
//   }
//
//   void _loadForm(Product product) {
//     _nameController.text = product.productName ?? '';
//     _brandController.text = product.productCode ?? '';
//     _descriptionController.text = product.description ?? '';
//     _imageUrlController.text = product.productImage ?? '';
//     _stockController.text = product.stock?.toString() ?? '';
//     _lowStockController.text = product.lowStock?.toString() ?? '';
//     _referenceProductIdController.text = product.referenceProductId ?? '';
//     _organizationIdController.text = product.organizationId ?? '';
//     _categoryIdController.text = product.categoryId ?? '';
//     _warehouseIdController.text = product.wareHouseId ?? '';
//     _supplierIdController.text = product.supplierId ?? '';
//   }
//
//   Future<void> _addProduct() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     final productData = {
//       "productName": _nameController.text.trim(),
//       "productCode": _brandController.text.trim(),
//       "description": _descriptionController.text.trim(),
//       "productImage": _imageUrlController.text.trim(),
//       "stock": int.tryParse(_stockController.text.trim()) ?? 0,
//       "lowStock": int.tryParse(_lowStockController.text.trim()) ?? 0,
//       "referenceProductId":
//           _referenceProductIdController.text.trim().isEmpty
//               ? null
//               : _referenceProductIdController.text.trim(),
//       "organizationId": _organizationIdController.text.trim(),
//       "categoryId": _categoryIdController.text.trim(),
//       "wareHouseId": _warehouseIdController.text.trim(),
//       "supplierId": _supplierIdController.text.trim(),
//     };
//
//     final isEdit = widget.isEditMode && widget.product != null;
//     final url =
//         isEdit
//             ? 'http://192.168.0.160:8080/api/v1/product/${widget.product!.productId}'
//             : 'http://192.168.0.160:8080/api/v1/product/add';
//
//     try {
//       final response =
//           isEdit
//               ? await http.put(
//                 Uri.parse(url),
//                 headers: {'Content-Type': 'application/json'},
//                 body: jsonEncode(productData),
//               )
//               : await http.post(
//                 Uri.parse(url),
//                 headers: {'Content-Type': 'application/json'},
//                 body: jsonEncode(productData),
//               );
//
//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               isEdit
//                   ? 'Product updated successfully!'
//                   : 'Product added successfully!',
//             ),
//             backgroundColor: Colors.green,
//           ),
//         );
//
//         if (widget.onNavigate != null) {
//           widget.onNavigate!('/product/list');
//         }
//       } else {
//         throw Exception('Failed to ${isEdit ? 'update' : 'add'} product.');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: const EdgeInsets.all(24),
//         margin: const EdgeInsets.all(24),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 4,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Add New Product',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: AppTheme.darkGray,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 TextFormField(
//                   controller: _nameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Product Name',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator:
//                       (value) =>
//                           value == null || value.isEmpty
//                               ? 'Please enter product name'
//                               : null,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _brandController,
//                   decoration: const InputDecoration(
//                     labelText: 'Product Code',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator:
//                       (value) =>
//                           value == null || value.isEmpty
//                               ? 'Please enter product code'
//                               : null,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _imageUrlController,
//                   decoration: const InputDecoration(
//                     labelText: 'Product Image URL',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _stockController,
//                   decoration: const InputDecoration(
//                     labelText: 'Stock Quantity',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.number,
//                   validator:
//                       (value) =>
//                           value == null || int.tryParse(value) == null
//                               ? 'Please enter valid stock'
//                               : null,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _lowStockController,
//                   decoration: const InputDecoration(
//                     labelText: 'Low Stock Threshold',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _descriptionController,
//                   maxLines: 3,
//                   decoration: const InputDecoration(
//                     labelText: 'Description',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator:
//                       (value) =>
//                           value == null || value.isEmpty
//                               ? 'Please enter description'
//                               : null,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _referenceProductIdController,
//                   decoration: const InputDecoration(
//                     labelText: 'Reference Product ID',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _organizationIdController,
//                   decoration: const InputDecoration(
//                     labelText: 'Organization ID',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _categoryIdController,
//                   decoration: const InputDecoration(
//                     labelText: 'Category ID',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _warehouseIdController,
//                   decoration: const InputDecoration(
//                     labelText: 'Warehouse ID',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _supplierIdController,
//                   decoration: const InputDecoration(
//                     labelText: 'Supplier ID',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 ElevatedButton(
//                   onPressed: _isLoading ? null : _addProduct,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppTheme.primaryBlue,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 32,
//                       vertical: 12,
//                     ),
//                   ),
//                   child: Text(
//                     widget.isEditMode ? 'Update Product' : 'Add Product',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:inventory/models/product.dart';
import 'package:inventory/providers/app_theme.dart';

class AddProductScreen extends StatefulWidget {
  final bool isEditMode;
  final Product? product;
  final Function(String route)? onNavigate;

  const AddProductScreen({
    super.key,
    this.isEditMode = false,
    this.onNavigate,
    this.product,
  });

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stockController = TextEditingController();
  final _lowStockController = TextEditingController();
  final _referenceProductIdController = TextEditingController();
  final _organizationIdController = TextEditingController();
  final _categoryIdController = TextEditingController();
  final _warehouseIdController = TextEditingController();
  final _supplierIdController = TextEditingController();

  File? _selectedImage;
  Uint8List? _webImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.product != null) {
      _loadForm(widget.product!);
    }
  }

  void _loadForm(Product product) {
    _nameController.text = product.productName ?? '';
    _brandController.text = product.productCode ?? '';
    _descriptionController.text = product.description ?? '';
    _stockController.text = product.stock?.toString() ?? '';
    _lowStockController.text = product.lowStock?.toString() ?? '';
    _referenceProductIdController.text = product.referenceProductId ?? '';
    _organizationIdController.text = product.organizationId ?? '';
    _categoryIdController.text = product.categoryId ?? '';
    _warehouseIdController.text = product.wareHouseId ?? '';
    _supplierIdController.text = product.supplierId ?? '';
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
          _selectedImage = null;
        });
      } else {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _webImage = null;
        });
      }
    }
  }

  void _removeImage() {
    setState(() {
      _webImage = null;
      _selectedImage = null;
    });
  }

  Future<void> _addProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    String? base64Image;
    if (_webImage != null) {
      base64Image = base64Encode(_webImage!);
    } else if (_selectedImage != null) {
      final bytes = await _selectedImage!.readAsBytes();
      base64Image = base64Encode(bytes);
    }

    final productData = {
      "productName": _nameController.text.trim(),
      "productCode": _brandController.text.trim(),
      "description": _descriptionController.text.trim(),
      "productImage": base64Image ?? '',
      "stock": int.tryParse(_stockController.text.trim()) ?? 0,
      "lowStock": int.tryParse(_lowStockController.text.trim()) ?? 0,
      "referenceProductId": _referenceProductIdController.text.trim().isEmpty
          ? null
          : _referenceProductIdController.text.trim(),
      "organizationId": _organizationIdController.text.trim(),
      "categoryId": _categoryIdController.text.trim(),
      "wareHouseId": _warehouseIdController.text.trim(),
      "supplierId": _supplierIdController.text.trim(),
    };

    final isEdit = widget.isEditMode && widget.product != null;
    final url = isEdit
        ? 'http://192.168.0.160:8080/api/v1/product/${widget.product!.productId}'
        : 'http://192.168.0.160:8080/api/v1/product/add';

    try {
      final response = isEdit
          ? await http.put(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(productData))
          : await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(productData));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              isEdit ? 'Product updated successfully!' : 'Product added successfully!'),
          backgroundColor: Colors.green,
        ));

        if (widget.onNavigate != null) {
          widget.onNavigate!('/product/list');
        }
      } else {
        throw Exception('Failed to ${isEdit ? 'update' : 'add'} product.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.all(24),
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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add New Product',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkGray,
                  ),
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter product name' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _brandController,
                  decoration: const InputDecoration(
                    labelText: 'Product Code',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter product code' : null,
                ),
                const SizedBox(height: 16),

                const Text(
                  'Product Image',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Choose File'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _selectedImage != null
                            ? _selectedImage!.path.split('/').last
                            : _webImage != null
                            ? 'image selected'
                            : 'No file chosen',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                if (_webImage != null || _selectedImage != null) ...[
                  const SizedBox(height: 12),
                  Stack(
                    children: [
                      kIsWeb
                          ? Image.memory(_webImage!, height: 150)
                          : Image.file(_selectedImage!, height: 150),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: InkWell(
                          onTap: _removeImage,
                          child: const CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.red,
                            child: Icon(Icons.close, size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),

                TextFormField(
                  controller: _stockController,
                  decoration: const InputDecoration(
                    labelText: 'Stock Quantity',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                  value == null || int.tryParse(value) == null ? 'Enter valid stock' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _lowStockController,
                  decoration: const InputDecoration(
                    labelText: 'Low Stock Threshold',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter description' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _referenceProductIdController,
                  decoration: const InputDecoration(
                    labelText: 'Reference Product ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _organizationIdController,
                  decoration: const InputDecoration(
                    labelText: 'Organization ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _categoryIdController,
                  decoration: const InputDecoration(
                    labelText: 'Category ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _warehouseIdController,
                  decoration: const InputDecoration(
                    labelText: 'Warehouse ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _supplierIdController,
                  decoration: const InputDecoration(
                    labelText: 'Supplier ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _isLoading ? null : _addProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: Text(widget.isEditMode ? 'Update Product' : 'Add Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
