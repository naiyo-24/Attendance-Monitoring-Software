import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';

class AddEditEmployeeCard extends StatefulWidget {
  final Map<String, dynamic>? employee;
  final void Function(Map<String, dynamic> emp) onSave;
  const AddEditEmployeeCard({super.key, this.employee, required this.onSave});

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
    _nameController = TextEditingController(
      text: widget.employee?['name'] ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.employee?['phone'] ?? '',
    );
    _emailController = TextEditingController(
      text: widget.employee?['email'] ?? '',
    );
    _passwordController = TextEditingController(
      text: widget.employee?['password'] ?? '',
    );
    _bankNameController = TextEditingController(
      text: widget.employee?['bankName'] ?? '',
    );
    _branchNameController = TextEditingController(
      text: widget.employee?['branchName'] ?? '',
    );
    _accountNoController = TextEditingController(
      text: widget.employee?['accountNo'] ?? '',
    );
    _ifscController = TextEditingController(
      text: widget.employee?['ifsc'] ?? '',
    );
    _designationController = TextEditingController(
      text: widget.employee?['designation'] ?? '',
    );
    _addressController = TextEditingController(
      text: widget.employee?['address'] ?? '',
    );
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
    final isEdit = widget.employee != null;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Align(
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 620,
            maxHeight: MediaQuery.of(context).size.height * 0.92,
          ),
          decoration: BoxDecoration(
            color: kWhite.withAlpha(96),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: kBlack.withAlpha((0.10 * 255).toInt()),
                blurRadius: 40,
                offset: const Offset(0, -6),
              ),
            ],
            border: Border.all(color: kWhiteGrey, width: 1.5),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 22,
              right: 22,
              top: 14,
              bottom: bottomInset + 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: kBlack.withAlpha((0.10 * 255).toInt()),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: kWhiteGrey.withAlpha(140),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: kBlack.withAlpha((0.04 * 255).toInt()),
                        ),
                      ),
                      child: Icon(
                        isEdit ? Iconsax.edit : Iconsax.user_add,
                        color: kBlack,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEdit ? 'Edit Employee' : 'Onboard New Employee',
                            style: kHeaderTextStyle(context).copyWith(
                              fontSize: 20,
                              color: kBlack,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Employee profile, credentials & payroll details',
                            style: kCaptionTextStyle(context).copyWith(
                              color: kBrown.withAlpha((0.75 * 255).toInt()),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => Navigator.of(context).maybePop(),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: kWhiteGrey.withAlpha(140),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: kBlack.withAlpha((0.04 * 255).toInt()),
                            ),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: kBrown,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Form(
                      key: _formKey,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth >= 560;
                          final spacing = 12.0;
                          final fieldWidth = isWide
                              ? (constraints.maxWidth - spacing) / 2
                              : constraints.maxWidth;

                          Widget half(Widget child) =>
                              SizedBox(width: fieldWidth, child: child);

                          return Wrap(
                            spacing: spacing,
                            runSpacing: 12,
                            children: [
                              half(
                                _buildTextField(
                                  _nameController,
                                  'Full Name',
                                  icon: Iconsax.user,
                                  required: true,
                                  keyboardType: TextInputType.name,
                                  textCapitalization: TextCapitalization.words,
                                ),
                              ),
                              half(
                                _buildTextField(
                                  _phoneController,
                                  'Phone No.',
                                  icon: Iconsax.call,
                                  required: true,
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                              half(
                                _buildTextField(
                                  _emailController,
                                  'Email',
                                  icon: Iconsax.sms,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                              half(
                                _buildTextField(
                                  _passwordController,
                                  'Password',
                                  icon: Iconsax.key,
                                  obscure: true,
                                  required: true,
                                ),
                              ),
                              half(
                                _buildTextField(
                                  _designationController,
                                  'Designation',
                                  icon: Iconsax.user_tag,
                                  textCapitalization: TextCapitalization.words,
                                ),
                              ),
                              half(
                                _buildTextField(
                                  _bankNameController,
                                  'Bank Name',
                                  icon: Iconsax.bank,
                                  textCapitalization: TextCapitalization.words,
                                ),
                              ),
                              half(
                                _buildTextField(
                                  _branchNameController,
                                  'Branch Name',
                                  icon: Iconsax.building_3,
                                  textCapitalization: TextCapitalization.words,
                                ),
                              ),
                              half(
                                _buildTextField(
                                  _accountNoController,
                                  'Account No.',
                                  icon: Iconsax.card,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              half(
                                _buildTextField(
                                  _ifscController,
                                  'IFSC Code',
                                  icon: Iconsax.code,
                                  textCapitalization:
                                      TextCapitalization.characters,
                                ),
                              ),
                              SizedBox(
                                width: constraints.maxWidth,
                                child: _buildTextField(
                                  _addressController,
                                  'Address',
                                  icon: Iconsax.location,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  maxLines: 2,
                                ),
                              ),
                              SizedBox(
                                width: constraints.maxWidth,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      style: kPremiumButtonStyle(context)
                                          .copyWith(
                                            backgroundColor:
                                                WidgetStateProperty.all(kGreen),
                                            foregroundColor:
                                                WidgetStateProperty.all(kWhite),
                                            padding: WidgetStateProperty.all(
                                              const EdgeInsets.symmetric(
                                                vertical: 18,
                                              ),
                                            ),
                                            elevation: WidgetStateProperty.all(
                                              12,
                                            ),
                                            shadowColor:
                                                WidgetStateProperty.all(
                                                  kBlack.withAlpha(40),
                                                ),
                                          ),
                                      icon: Icon(
                                        isEdit
                                            ? Iconsax.save_2
                                            : Iconsax.user_add,
                                        size: 20,
                                      ),
                                      label: Text(
                                        isEdit
                                            ? 'Save Changes'
                                            : 'Onboard Employee',
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          widget.onSave({
                                            'name': _nameController.text,
                                            'phone': _phoneController.text,
                                            'email': _emailController.text,
                                            'password':
                                                _passwordController.text,
                                            'bankName':
                                                _bankNameController.text,
                                            'branchName':
                                                _branchNameController.text,
                                            'accountNo':
                                                _accountNoController.text,
                                            'ifsc': _ifscController.text,
                                            'designation':
                                                _designationController.text,
                                            'address': _addressController.text,
                                            'profilePhoto': null,
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    IconData? icon,
    bool obscure = false,
    bool required = false,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      maxLines: obscure ? 1 : maxLines,
      style: kDescriptionTextStyle(
        context,
      ).copyWith(fontSize: 15, color: kBlack, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        prefixIcon: icon != null ? Icon(icon, color: kBrown, size: 20) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: kWhiteGrey.withAlpha(160),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: kBlack.withAlpha(35), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: kBlack.withAlpha(15), width: 1),
        ),
        labelStyle: kTaglineTextStyle(
          context,
        ).copyWith(color: kBlack.withAlpha(80)),
        hintStyle: kCaptionTextStyle(
          context,
        ).copyWith(color: kBlack.withAlpha(60)),
      ),
      validator: (val) {
        if (!required) return null;
        final value = val?.trim() ?? '';
        return value.isEmpty ? 'Required' : null;
      },
    );
  }
}
