import 'package:flutter/material.dart';
import 'package:beikeshop_flutter/l10n/app_localizations.dart';
import '../../models/address_model.dart';
import '../../theme/app_theme.dart';

class AddEditAddressScreen extends StatefulWidget {
  final Address? address;

  const AddEditAddressScreen({super.key, this.address});

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _countryController;
  late TextEditingController _provinceController;
  late TextEditingController _cityController;
  late TextEditingController _addressLineController;
  late TextEditingController _zipCodeController;
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.address?.name ?? '');
    _phoneController = TextEditingController(text: widget.address?.phone ?? '');
    _countryController = TextEditingController(
      text: widget.address?.country ?? '',
    );
    _provinceController = TextEditingController(
      text: widget.address?.province ?? '',
    );
    _cityController = TextEditingController(text: widget.address?.city ?? '');
    _addressLineController = TextEditingController(
      text: widget.address?.addressLine ?? '',
    );
    _zipCodeController = TextEditingController(
      text: widget.address?.zipCode ?? '',
    );
    _isDefault = widget.address?.isDefault ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _countryController.dispose();
    _provinceController.dispose();
    _cityController.dispose();
    _addressLineController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      final newAddress = Address(
        id: widget.address?.id ?? DateTime.now().toString(),
        name: _nameController.text,
        phone: _phoneController.text,
        country: _countryController.text,
        province: _provinceController.text,
        city: _cityController.text,
        addressLine: _addressLineController.text,
        zipCode: _zipCodeController.text,
        isDefault: _isDefault,
      );

      Navigator.pop(context, newAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.address == null ? l10n.addAddress : l10n.editAddress,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSection(
                      children: [
                        _buildTextField(
                          controller: _nameController,
                          label: l10n.fullName,
                          icon: Icons.person_outline,
                        ),
                        const Divider(height: 1),
                        _buildTextField(
                          controller: _phoneController,
                          label: l10n.phoneNumber,
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildSection(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _countryController,
                                label: l10n.country,
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 24,
                              color: AppColors.border,
                            ),
                            Expanded(
                              child: _buildTextField(
                                controller: _provinceController,
                                label: l10n.provinceState,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 1),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _cityController,
                                label: l10n.city,
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 24,
                              color: AppColors.border,
                            ),
                            Expanded(
                              child: _buildTextField(
                                controller: _zipCodeController,
                                label: l10n.zipCode,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 1),
                        _buildTextField(
                          controller: _addressLineController,
                          label: l10n.addressLine,
                          icon: Icons.location_on_outlined,
                          maxLines: 2,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: SwitchListTile(
                        title: Text(
                          l10n.setAsDefault,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        value: _isDefault,
                        activeColor: AppColors.primary,
                        onChanged: (val) => setState(() => _isDefault = val),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _saveAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    l10n.save,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(children: children),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon: icon != null
            ? Icon(icon, color: AppColors.textSecondary, size: 20)
            : null,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        isDense: true,
      ),
      validator: (value) => value!.isEmpty ? 'Required' : null,
    );
  }
}
