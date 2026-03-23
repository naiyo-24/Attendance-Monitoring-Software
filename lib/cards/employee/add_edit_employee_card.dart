import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class AddEditEmployeeCard extends StatefulWidget {
  final Map<String, dynamic>? employee;
  final void Function(Map<String, dynamic> emp) onSave;
  const AddEditEmployeeCard({
    super.key,
    this.employee,
    required this.onSave,
  });

  @override
  State<AddEditEmployeeCard> createState() => _AddEditEmployeeCardState();
}

class _AddEditEmployeeCardState extends State<AddEditEmployeeCard> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _bankNameController;
  late TextEditingController _branchNameController;
  late TextEditingController _accountNoController;
  late TextEditingController _ifscController;
  late TextEditingController _designationController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee?['name'] ?? '');
    _phoneController = TextEditingController(text: widget.employee?['phone'] ?? '');
    _emailController = TextEditingController(text: widget.employee?['email'] ?? '');
    _passwordController = TextEditingController(text: widget.employee?['password'] ?? '');
    _bankNameController = TextEditingController(text: widget.employee?['bankName'] ?? '');
    _branchNameController = TextEditingController(text: widget.employee?['branchName'] ?? '');
    _accountNoController = TextEditingController(text: widget.employee?['accountNo'] ?? '');
    _ifscController = TextEditingController(text: widget.employee?['ifsc'] ?? '');
    _designationController = TextEditingController(text: widget.employee?['designation'] ?? '');
    _addressController = TextEditingController(text: widget.employee?['address'] ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bankNameController.dispose();
    _branchNameController.dispose();
    _accountNoController.dispose();
    _ifscController.dispose();
    _designationController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.employee == null ? 'Onboard New Employee' : 'Edit Employee',
                style: kHeaderTextStyle(context),
              ),
              const SizedBox(height: 18),
              _buildTextField(_nameController, 'Name'),
              const SizedBox(height: 12),
              _buildTextField(_phoneController, 'Phone No.'),
              const SizedBox(height: 12),
              _buildTextField(_emailController, 'Email'),
              const SizedBox(height: 12),
              _buildTextField(_passwordController, 'Password', obscure: true),
              const SizedBox(height: 12),
              _buildTextField(_bankNameController, 'Bank Name'),
              const SizedBox(height: 12),
              _buildTextField(_branchNameController, 'Branch Name'),
              const SizedBox(height: 12),
              _buildTextField(_accountNoController, 'Account No.'),
              const SizedBox(height: 12),
              _buildTextField(_ifscController, 'IFSC Code'),
              const SizedBox(height: 12),
              _buildTextField(_designationController, 'Designation'),
              const SizedBox(height: 12),
              _buildTextField(_addressController, 'Address'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: kPremiumButtonStyle(context),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onSave({
                        'name': _nameController.text,
                        'phone': _phoneController.text,
                        'email': _emailController.text,
                        'password': _passwordController.text,
                        'bankName': _bankNameController.text,
                        'branchName': _branchNameController.text,
                        'accountNo': _accountNoController.text,
                        'ifsc': _ifscController.text,
                        'designation': _designationController.text,
                        'address': _addressController.text,
                        'profilePhoto': null,
                      });
                    }
                  },
                  child: Text(widget.employee == null ? 'Onboard' : 'Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool obscure = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
    );
  }
}
