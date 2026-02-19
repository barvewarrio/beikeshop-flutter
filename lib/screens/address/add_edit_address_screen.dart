import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beikeshop_flutter/l10n/app_localizations.dart';
import '../../providers/address_provider.dart';
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

  Future<void> _saveAddress() async {
    final l10n = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate()) {
      if (_selectedCountryId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a country')),
        );
        return;
      }

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
        id: widget.address?.id ?? '',
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

      final provider = context.read<AddressProvider>();

      try {
        if (widget.address == null) {
          await provider.addAddress(newAddress);
        } else {
          await provider.updateAddress(newAddress);
        }

        if (!mounted) return;

        if (provider.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(provider.error!)),
          );
        } else {
          Navigator.pop(context, newAddress);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: Text(
          widget.address == null ? l10n.addAddress : l10n.editAddress,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSection(
                      title: l10n.contactInfo,
                      children: [
                        _buildTextField(
                          controller: _nameController,
                          label: l10n.fullName,
                          icon: Icons.person_outline,
                        ),
                        const Divider(height: 1, indent: 48),
                        _buildTextField(
                          controller: _phoneController,
                          label: l10n.phoneNumber,
                          keyboardType: TextInputType.phone,
                          icon: Icons.phone_outlined,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildSection(
                      title: l10n.shippingAddress,
                      children: [
                        _buildDropdown(
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
                          icon: Icons.public,
                        ),
                        const Divider(height: 1, indent: 48),
                        _buildDropdown(
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
                          icon: Icons.map_outlined,
                        ),
                        const Divider(height: 1, indent: 48),
                        _buildTextField(
                          controller: _cityController,
                          label: l10n.city,
                          icon: Icons.location_city_outlined,
                        ),
                        const Divider(height: 1, indent: 48),
                        _buildTextField(
                          controller: _zipCodeController,
                          label: l10n.zipCode,
                          keyboardType: TextInputType.number,
                          icon: Icons.numbers_outlined,
                        ),
                        const Divider(height: 1, indent: 48),
                        _buildTextField(
                          controller: _addressLineController,
                          label: l10n.address,
                          maxLines: 2,
                          icon: Icons.home_outlined,
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
                            blurRadius: 8,
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
                            color: AppColors.textPrimary,
                          ),
                        ),
                        secondary: const Icon(
                          Icons.check_circle_outline,
                          color: AppColors.textSecondary,
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
                    const SizedBox(height: 24),
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
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF5000), Color(0xFFE02020)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Consumer<AddressProvider>(
                  builder: (context, provider, child) {
                    return ElevatedButton(
                      onPressed: provider.isLoading ? null : _saveAddress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
                        disabledBackgroundColor: Colors.grey,
                      ),
                      child: provider.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              l10n.save,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({String? title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    int maxLines = 1,
    IconData? icon,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.textSecondary),
          border: InputBorder.none,
          icon: icon != null
              ? Icon(icon, color: AppColors.textHint, size: 20)
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          isDense: true,
        ),
        validator: (value) => value!.isEmpty ? l10n.requiredField : null,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required int? value,
    required List<DropdownMenuItem<int>> items,
    required ValueChanged<int?> onChanged,
    bool isLoading = false,
    IconData? icon,
  }) {
    final l10n = AppLocalizations.of(context)!;
    // Ensure value is null if items is empty or value not in items
    final effectiveValue =
        (items.isEmpty || !items.any((item) => item.value == value))
        ? null
        : value;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: DropdownButtonFormField<int>(
        key: ValueKey(effectiveValue),
        initialValue: effectiveValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.textSecondary),
          border: InputBorder.none,
          icon: icon != null
              ? Icon(icon, color: AppColors.textHint, size: 20)
              : null,
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
        validator: (val) =>
            val == null && items.isNotEmpty ? l10n.requiredField : null,
        icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
        style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
        isExpanded: true,
      ),
    );
  }
}
