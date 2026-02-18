import 'package:flutter/material.dart';
import 'package:beikeshop_flutter/l10n/app_localizations.dart';
import '../../models/address_model.dart';
import '../../models/region_models.dart';
import '../../api/api_service.dart';
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
  late TextEditingController _cityController;
  late TextEditingController _addressLineController;
  late TextEditingController _zipCodeController;
  bool _isDefault = false;

  List<Country> _countries = [];
  List<Zone> _zones = [];
  int? _selectedCountryId;
  int? _selectedZoneId;
  bool _isLoadingCountries = false;
  bool _isLoadingZones = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.address?.name ?? '');
    _phoneController = TextEditingController(text: widget.address?.phone ?? '');
    _cityController = TextEditingController(text: widget.address?.city ?? '');
    _addressLineController = TextEditingController(
      text: widget.address?.addressLine ?? '',
    );
    _zipCodeController = TextEditingController(
      text: widget.address?.zipCode ?? '',
    );
    _isDefault = widget.address?.isDefault ?? false;

    _selectedCountryId = widget.address?.countryId;
    if (_selectedCountryId == 0) _selectedCountryId = null;

    _selectedZoneId = widget.address?.zoneId;
    if (_selectedZoneId == 0) _selectedZoneId = null;

    _fetchCountries();
  }

  Future<void> _fetchCountries() async {
    setState(() => _isLoadingCountries = true);
    try {
      final countries = await ApiService().getCountries();
      if (mounted) {
        setState(() {
          _countries = countries;
          _isLoadingCountries = false;
        });
      }

      if (_selectedCountryId != null) {
        // Verify if selected country still exists in the list
        if (!_countries.any((c) => c.id == _selectedCountryId)) {
          if (mounted) setState(() => _selectedCountryId = null);
        } else {
          _fetchZones(_selectedCountryId!);
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingCountries = false);
      debugPrint('Error fetching countries: $e');
    }
  }

  Future<void> _fetchZones(int countryId) async {
    setState(() => _isLoadingZones = true);
    try {
      final zones = await ApiService().getZones(countryId);
      if (mounted) {
        setState(() {
          _zones = zones;
          _isLoadingZones = false;
        });

        // Verify if selected zone exists
        if (_selectedZoneId != null &&
            !_zones.any((z) => z.id == _selectedZoneId)) {
          setState(() => _selectedZoneId = null);
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingZones = false);
      debugPrint('Error fetching zones: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _addressLineController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCountryId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a country')),
        );
        return;
      }

      // Some countries might not have zones, so only enforce if zones are available
      if (_zones.isNotEmpty && _selectedZoneId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a province/state')),
        );
        return;
      }

      final countryName = _countries
          .firstWhere(
            (c) => c.id == _selectedCountryId,
            orElse: () => Country(id: 0, name: ''),
          )
          .name;

      String zoneName = '';
      if (_selectedZoneId != null) {
        final zone = _zones.firstWhere(
          (z) => z.id == _selectedZoneId,
          orElse: () => Zone(id: 0, name: '', code: ''),
        );
        zoneName = zone.name;
      }

      final newAddress = Address(
        id: widget.address?.id ?? DateTime.now().toString(),
        name: _nameController.text,
        phone: _phoneController.text,
        country: countryName,
        countryId: _selectedCountryId ?? 0,
        province: zoneName,
        zoneId: _selectedZoneId ?? 0,
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
                        ),
                        const Divider(height: 1),
                        _buildTextField(
                          controller: _phoneController,
                          label: l10n.phoneNumber,
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
                              child: _buildDropdown(
                                label: l10n.country,
                                value: _selectedCountryId,
                                items: _countries
                                    .map(
                                      (c) => DropdownMenuItem(
                                        value: c.id,
                                        child: Text(
                                          c.name,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      _selectedCountryId = val;
                                      _selectedZoneId = null;
                                      _zones = [];
                                    });
                                    _fetchZones(val);
                                  }
                                },
                                isLoading: _isLoadingCountries,
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 24,
                              color: AppColors.border,
                            ),
                            Expanded(
                              child: _buildDropdown(
                                label: l10n.provinceState,
                                value: _selectedZoneId,
                                items: _zones
                                    .map(
                                      (z) => DropdownMenuItem(
                                        value: z.id,
                                        child: Text(
                                          z.name,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) =>
                                    setState(() => _selectedZoneId = val),
                                isLoading: _isLoadingZones,
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
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        isDense: true,
      ),
      validator: (value) => value!.isEmpty ? 'Required' : null,
    );
  }

  Widget _buildDropdown({
    required String label,
    required int? value,
    required List<DropdownMenuItem<int>> items,
    required ValueChanged<int?> onChanged,
    bool isLoading = false,
  }) {
    // Ensure value is null if items is empty or value not in items
    final effectiveValue =
        (items.isEmpty || !items.any((item) => item.value == value))
        ? null
        : value;

    return DropdownButtonFormField<int>(
      value: effectiveValue,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        isDense: true,
        suffixIcon: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : null,
      ),
      items: items,
      onChanged: onChanged,
      validator: (val) => val == null && items.isNotEmpty ? 'Required' : null,
      icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
      style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
      isExpanded: true,
    );
  }
}
