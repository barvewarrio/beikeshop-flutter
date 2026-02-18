import 'package:flutter/foundation.dart';
import '../models/address_model.dart';
import '../api/api_service.dart';

class AddressProvider extends ChangeNotifier {
  List<Address> _addresses = [];
  bool _isLoading = false;
  String? _error;

  AddressProvider() {
    loadAddresses();
  }

  List<Address> get addresses => _addresses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Address? get defaultAddress {
    if (_addresses.isEmpty) return null;
    try {
      return _addresses.firstWhere((a) => a.isDefault);
    } catch (_) {
      return _addresses.first;
    }
  }

  Future<void> loadAddresses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _addresses = await ApiService().getAddresses();
    } catch (e) {
      debugPrint('Error loading addresses: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAddress(Address address) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newAddress = await ApiService().addAddress(address);
      _addresses.add(newAddress);

      // If the new address is default, refresh list or update local state
      if (newAddress.isDefault) {
        _updateLocalDefault(newAddress.id);
      }
    } catch (e) {
      debugPrint('Error adding address: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateAddress(Address address) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedAddress = await ApiService().updateAddress(address);
      final index = _addresses.indexWhere((a) => a.id == updatedAddress.id);
      if (index != -1) {
        _addresses[index] = updatedAddress;
        if (updatedAddress.isDefault) {
          _updateLocalDefault(updatedAddress.id);
        }
      }
    } catch (e) {
      debugPrint('Error updating address: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeAddress(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final addressToDelete = _addresses.firstWhere(
        (a) => a.id == id,
        orElse: () => Address(
          id: '',
          name: '',
          phone: '',
          country: '',
          province: '',
          city: '',
          addressLine: '',
          zipCode: '',
        ),
      );
      await ApiService().deleteAddress(id);

      if (addressToDelete.isDefault) {
        // Reload to get new default assigned by backend
        // We set _isLoading false here because loadAddresses will handle its own loading state
        // and we want to avoid double finally execution issues if we just called it
        await loadAddresses();
      } else {
        _addresses.removeWhere((a) => a.id == id);
      }
    } catch (e) {
      debugPrint('Error deleting address: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _updateLocalDefault(String defaultId) {
    for (var i = 0; i < _addresses.length; i++) {
      if (_addresses[i].id != defaultId && _addresses[i].isDefault) {
        _addresses[i] = _addresses[i].copyWith(isDefault: false);
      }
    }
  }

  // Helper to ensure single default locally
  void setDefaultAddress(String id) {
    try {
      final address = _addresses.firstWhere((a) => a.id == id);
      updateAddress(address.copyWith(isDefault: true));
    } catch (e) {
      debugPrint('Address not found: $id');
    }
  }
}
