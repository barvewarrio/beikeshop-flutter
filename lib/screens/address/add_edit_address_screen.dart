import 'package:flutter/material.dart';
import '../../models/address_model.dart';
import '../../theme/app_theme.dart';

class AddEditAddressScreen extends StatefulWidget {
  final Address? address;

  const AddEditAddressScreen({Key? key, this.address}) : super(key: key);

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.address == null ? 'Add Address' : 'Edit Address'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _countryController,
                      decoration: const InputDecoration(labelText: 'Country'),
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _provinceController,
                      decoration: const InputDecoration(
                        labelText: 'Province/State',
                      ),
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(labelText: 'City'),
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _zipCodeController,
                      decoration: const InputDecoration(labelText: 'Zip Code'),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressLineController,
                decoration: const InputDecoration(
                  labelText: 'Address Line (Street, Apt, etc.)',
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              SwitchListTile(
                title: const Text('Set as Default Address'),
                value: _isDefault,
                onChanged: (val) => setState(() => _isDefault = val),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Save Address'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
