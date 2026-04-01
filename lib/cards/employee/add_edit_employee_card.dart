import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
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
      padding: EdgeInsets.only(
        left: 0,
        right: 0,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 12,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          decoration: BoxDecoration(
            color: kWhite.withAlpha(85),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: kBrown.withAlpha(9),
                blurRadius: 32,
                offset: const Offset(0, 12),
              ),
            ],
            border: Border.all(color: kWhiteGrey, width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          widget.employee == null ? Iconsax.user_add : Iconsax.edit,
                          color: kGreen,
                          size: 28,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.employee == null ? 'Onboard New Employee' : 'Edit Employee',
                          style: kHeaderTextStyle(context).copyWith(fontSize: 22),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    _buildTextField(_nameController, 'Name', icon: Iconsax.user),
                    const SizedBox(height: 14),
                    _buildTextField(_phoneController, 'Phone No.', icon: Iconsax.call),
                    const SizedBox(height: 14),
                    _buildTextField(_emailController, 'Email', icon: Iconsax.sms),
                    const SizedBox(height: 14),
                    _buildTextField(_passwordController, 'Password', icon: Iconsax.key, obscure: true),
                    const SizedBox(height: 14),
                    _buildTextField(_bankNameController, 'Bank Name', icon: Iconsax.bank),
                    const SizedBox(height: 14),
                    _buildTextField(_branchNameController, 'Branch Name', icon: Iconsax.building_3),
                    const SizedBox(height: 14),
                    _buildTextField(_accountNoController, 'Account No.', icon: Iconsax.card),
                    const SizedBox(height: 14),
                    _buildTextField(_ifscController, 'IFSC Code', icon: Iconsax.code),
                    const SizedBox(height: 14),
                    _buildTextField(_designationController, 'Designation', icon: Iconsax.user_tag),
                    const SizedBox(height: 14),
                    _buildTextField(_addressController, 'Address', icon: Iconsax.location),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: kPremiumButtonStyle(context).copyWith(
                          backgroundColor: WidgetStateProperty.all(kGreen),
                          foregroundColor: WidgetStateProperty.all(kWhite),
                          padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 18)),
                        ),
                        icon: Icon(widget.employee == null ? Iconsax.user_add : Iconsax.save_2, size: 22),
                        label: Text(widget.employee == null ? 'Onboard' : 'Save'),
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {IconData? icon, bool obscure = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: kDescriptionTextStyle(context).copyWith(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        prefixIcon: icon != null ? Icon(icon, color: kBrown, size: 22) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: kWhiteGrey.withAlpha(7),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        labelStyle: kTaglineTextStyle(context).copyWith(color: kBrown.withAlpha(8)),
        hintStyle: kCaptionTextStyle(context).copyWith(color: kBrown.withAlpha(6)),
      ),
      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
    );
  }
}
