// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:inventory/models/supplier.dart';
//
// import 'package:flutter/services.dart';
// import 'package:inventory/providers/app_theme.dart';
//
// class AddSupplierScreen extends StatefulWidget {
//   final bool isEditMode;
//   final Supplier? supplier;
//   final Function(String route)? onNavigate;
//
//   const AddSupplierScreen({
//     super.key,
//     this.isEditMode = false,
//     this.supplier,
//     this.onNavigate,
//   });
//
//   @override
//   State<AddSupplierScreen> createState() => _AddSupplierScreenState();
// }
//
// class _AddSupplierScreenState extends State<AddSupplierScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _shopnameController = TextEditingController();
//   final _gstnumberController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _addressController = TextEditingController();
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.isEditMode && widget.supplier != null) {
//       _loadForm(widget.supplier!);
//     }
//   }
//
//   void _loadForm(Supplier supplier) {
//     _shopnameController.text = widget.supplier!.supplierShopName ?? '';
//     _gstnumberController.text = widget.supplier!.supplierGstNo ?? '';
//     _phoneController.text = widget.supplier!.phoneNumber ?? '';
//     _addressController.text = widget.supplier!.locationOrArea ?? '';
//   }
//
//   Future<void> addSupplier() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     final supplierData = {
//       "supplierShopName": _shopnameController.text.trim(),
//       "supplierGstNo": _gstnumberController.text.trim(),
//       "phoneNumber": _phoneController.text.trim(),
//       "locationOrArea": _addressController.text.trim(),
//     };
//
//     final isEdit = widget.isEditMode && widget.supplier != null;
//     final url =
//         isEdit
//             ? 'http://192.168.0.160:8080/api/v1/supplier/${widget.supplier!.supplierId}'
//             : 'http://192.168.0.160:8080/api/v1/supplier/add';
//
//     try {
//       final response =
//           isEdit
//               ? await http.put(
//                 Uri.parse(url),
//                 headers: {'Content-Type': 'application/json'},
//                 body: jsonEncode(supplierData),
//               )
//               : await http.post(
//                 Uri.parse(url),
//                 headers: {'Content-Type': 'application/json'},
//                 body: jsonEncode(supplierData),
//               );
//
//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               isEdit
//                   ? 'Supplier updated successfully!'
//                   : 'Supplier added successfully!',
//             ),
//             backgroundColor: Colors.green,
//           ),
//         );
//
//         if (widget.onNavigate != null) {
//           widget.onNavigate!('/supplier/list');
//         }
//       } else {
//         throw Exception('Failed to ${isEdit ? 'update' : 'add'} supplier.');
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
//   void _clearForm() {
//     _shopnameController.clear();
//     _gstnumberController.clear();
//     _phoneController.clear();
//     _addressController.clear();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isEdit = widget.isEditMode;
//
//     return Padding(
//       padding: const EdgeInsets.all(24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               if (isEdit)
//                 IconButton(
//                   onPressed: () {
//                     if (widget.onNavigate != null) {
//                       widget.onNavigate!('/supplier/list');
//                     }
//                   },
//                   icon: const Icon(
//                     Icons.arrow_back,
//                     color: AppTheme.primaryBlue,
//                   ),
//                 ),
//               Text(
//                 isEdit ? 'Edit Supplier' : 'Add Supplier',
//                 style: const TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: AppTheme.darkGray,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 24),
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.1),
//                     spreadRadius: 1,
//                     blurRadius: 4,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Form(
//                 key: _formKey,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       LayoutBuilder(
//                         builder: (context, constraints) {
//                           return constraints.maxWidth > 600
//                               ? Row(
//                                 children: [
//                                   Expanded(
//                                     child: _buildTextField(
//                                       _shopnameController,
//                                       'Shop Name',
//                                     ),
//                                   ),
//                                   const SizedBox(width: 16),
//                                   Expanded(
//                                     child: _buildTextField(
//                                       _gstnumberController,
//                                       'GST Number',
//                                     ),
//                                   ),
//                                 ],
//                               )
//                               : Column(
//                                 children: [
//                                   _buildTextField(
//                                     _shopnameController,
//                                     'Shop Name',
//                                   ),
//                                   const SizedBox(height: 16),
//                                   _buildTextField(
//                                     _gstnumberController,
//                                     'GST Number',
//                                   ),
//                                 ],
//                               );
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       IntlPhoneField(
//                         controller: _phoneController,
//                         keyboardType: TextInputType.phone,
//                         decoration: InputDecoration(
//                           labelText: "Phone Number",
//                           border: OutlineInputBorder(),
//                         ),
//                         initialCountryCode: 'IN',
//                         validator: (value) {
//                           if (value == null || value.number.isEmpty) {
//                             return 'Please enter Phone Number';
//                           }
//                           return null;
//                         },
//                       ),
//
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         controller: _addressController,
//                         maxLines: 3,
//                         decoration: const InputDecoration(
//                           labelText: 'Address',
//                           border: OutlineInputBorder(),
//                         ),
//                         validator:
//                             (value) =>
//                                 value == null || value.isEmpty
//                                     ? 'Please enter address'
//                                     : null,
//                       ),
//                       const SizedBox(height: 24),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: _isLoading ? null : addSupplier,
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppTheme.primaryBlue,
//                                 foregroundColor: Colors.white,
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 12,
//                                 ),
//                               ),
//                               child:
//                                   _isLoading
//                                       ? const SizedBox(
//                                         width: 20,
//                                         height: 20,
//                                         child: CircularProgressIndicator(
//                                           strokeWidth: 2,
//                                           valueColor:
//                                               AlwaysStoppedAnimation<Color>(
//                                                 Colors.white,
//                                               ),
//                                         ),
//                                       )
//                                       : Text(
//                                         isEdit
//                                             ? 'Update Supplier'
//                                             : 'Add Supplier',
//                                       ),
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           if (isEdit)
//                             OutlinedButton(
//                               onPressed:
//                                   _isLoading
//                                       ? null
//                                       : () {
//                                         widget.isEditMode
//                                             ? widget.onNavigate?.call(
//                                               '/supplier/list',
//                                             )
//                                             : _clearForm();
//                                       },
//                               style: OutlinedButton.styleFrom(
//                                 foregroundColor: AppTheme.primaryBlue,
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 32,
//                                   vertical: 12,
//                                 ),
//                               ),
//                               child: const Text('Cancel'),
//                             )
//                           else
//                             OutlinedButton(
//                               onPressed:
//                                   _isLoading
//                                       ? null
//                                       : () {
//                                         _shopnameController.clear();
//                                         _gstnumberController.clear();
//                                         _phoneController.clear();
//                                         _addressController.clear();
//                                       },
//                               style: OutlinedButton.styleFrom(
//                                 foregroundColor: AppTheme.primaryBlue,
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 32,
//                                   vertical: 12,
//                                 ),
//                               ),
//                               child: const Text('Clear Form'),
//                             ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTextField(
//     TextEditingController controller,
//     String label, {
//     TextInputType? keyboardType,
//     String? Function(String?)? validator,
//     List<TextInputFormatter>? inputFormatters,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: keyboardType,
//       inputFormatters: inputFormatters,
//       decoration: InputDecoration(
//         labelText: label,
//         border: const OutlineInputBorder(),
//       ),
//       validator:
//           validator ??
//           (value) =>
//               value == null || value.isEmpty ? 'Please enter $label' : null,
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:inventory/models/supplier.dart';
import 'package:flutter/services.dart';
import 'package:inventory/providers/app_theme.dart';

class AddSupplierScreen extends StatefulWidget {
  final bool isEditMode;
  final Supplier? supplier;
  final Function(String route)? onNavigate;

  const AddSupplierScreen({
    super.key,
    this.isEditMode = false,
    this.supplier,
    this.onNavigate,
  });

  @override
  State<AddSupplierScreen> createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  final _formKey = GlobalKey<FormState>();
  final _shopnameController = TextEditingController();
  final _gstnumberController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isLoading = false;
  String? _gstError;
  String? _phoneError;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.supplier != null) {
      _loadForm(widget.supplier!);
    }
  }

  void _loadForm(Supplier supplier) {
    _shopnameController.text = supplier.supplierShopName ?? '';
    _gstnumberController.text = supplier.supplierGstNo ?? '';
    _phoneController.text = supplier.phoneNumber ?? '';
    _addressController.text = supplier.locationOrArea ?? '';
  }

  Future<void> addSupplier() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _gstError = null;
      _phoneError = null;
    });

    final supplierData = {
      "supplierShopName": _shopnameController.text.trim(),
      "supplierGstNo": _gstnumberController.text.trim(),
      "phoneNumber": _phoneController.text.trim(),
      "locationOrArea": _addressController.text.trim(),
    };

    final isEdit = widget.isEditMode && widget.supplier != null;
    final url = isEdit
        ? 'http://192.168.0.160:8080/api/v1/supplier/${widget.supplier!.supplierId}'
        : 'http://192.168.0.160:8080/api/v1/supplier/add';

    try {
      final response = await (isEdit
          ? http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(supplierData),
      )
          : http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(supplierData),
      ));

      // --- Handle Duplicate Data (302) ---
      if (response.statusCode == 302) {
        final errorText = response.body.toLowerCase();

        setState(() {
          if (errorText.contains('gst') && errorText.contains('already')) {
            _gstError = 'GST number already exists';
          }
          if (errorText.contains('phone') && errorText.contains('already')) {
            _phoneError = 'Phone number already exists';
          }
        });

        return;
      }

      // --- Handle Success (200 OK) ---
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEdit
                  ? 'Supplier updated successfully!'
                  : 'Supplier added successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );

        if (widget.onNavigate != null) {
          widget.onNavigate!('/supplier/list');
        }
        return;
      }

      // --- Handle Unexpected Error ---
      throw Exception('Failed to ${isEdit ? 'update' : 'add'} supplier.');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearForm() {
    _shopnameController.clear();
    _gstnumberController.clear();
    _phoneController.clear();
    _addressController.clear();
    setState(() {
      _gstError = null;
      _phoneError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.isEditMode;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isEdit)
                IconButton(
                  onPressed: () => widget.onNavigate?.call('/supplier/list'),
                  icon: const Icon(Icons.arrow_back, color: AppTheme.primaryBlue),
                ),
              Text(
                isEdit ? 'Edit Supplier' : 'Add Supplier',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
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
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return constraints.maxWidth > 600
                              ? Row(
                            children: [
                              Expanded(child: _buildTextField(_shopnameController, 'Shop Name')),
                              const SizedBox(width: 16),
                              Expanded(child: _buildGstTextField()),
                            ],
                          )
                              : Column(
                            children: [
                              _buildTextField(_shopnameController, 'Shop Name'),
                              const SizedBox(height: 16),
                              _buildGstTextField(),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildPhoneField(),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _addressController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => value == null || value.isEmpty ? 'Please enter address' : null,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : addSupplier,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryBlue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                                  : Text(isEdit ? 'Update Supplier' : 'Add Supplier'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          OutlinedButton(
                            onPressed: _isLoading ? null : (isEdit ? () => widget.onNavigate?.call('/supplier/list') : _clearForm),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.primaryBlue,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            ),
                            child: Text(isEdit ? 'Cancel' : 'Clear Form'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label, {
        TextInputType? keyboardType,
        String? Function(String?)? validator,
        List<TextInputFormatter>? inputFormatters,
      }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      validator: validator ?? (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
    );
  }

  Widget _buildGstTextField() {
    return TextFormField(
      controller: _gstnumberController,
      decoration: InputDecoration(
        labelText: 'GST Number',
        border: const OutlineInputBorder(),
        errorText: _gstError,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter GST Number';
        return null;
      },
      onChanged: (_) {
        if (_gstError != null) setState(() => _gstError = null);
      },
    );
  }

  Widget _buildPhoneField() {
    return IntlPhoneField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: "Phone Number",
        border: const OutlineInputBorder(),
        errorText: _phoneError,
      ),
      initialCountryCode: 'IN',
      validator: (value) {
        if (value == null || value.number.isEmpty) return 'Please enter Phone Number';
        return null;
      },
      onChanged: (_) {
        if (_phoneError != null) setState(() => _phoneError = null);
      },
    );
  }
}
