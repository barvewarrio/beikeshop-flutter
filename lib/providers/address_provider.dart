import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/address_model.dart';

class AddressProvider extends ChangeNotifier {
  List<Address> _addresses = [];
  bool _isLoading = true;

  AddressProvider() {
    _loadAddresses();
  }

  List<Address> get addresses => _addresses;
  bool get isLoading => _isLoading;
  Address? get defaultAddress => _addresses.isEmpty 
      ? null 
      : _addresses.firstWhere((a) => a.isDefault, orElse: () => _addresses.first);

  Future<void> _loadAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? addressesJson = prefs.getString('user_addresses');
      
      if (addressesJson != null) {
        final List<dynamic> decodedList = jsonDecode(addressesJson);
        _addresses = decodedList.map((item) => Address.fromJson(item)).toList();
      }
    } catch (e) {
      print('Error loading addresses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String addressesJson = jsonEncode(_addresses.map((item) => item.toJson()).toList());
      await prefs.setString('user_addresses', addressesJson);
    } catch (e) {
      print('Error saving addresses: $e');
    }
  }

  void addAddress(Address address) {
    if (address.isDefault) {
      // If new address is default, unset previous default
      for (var i = 0; i < _addresses.length; i++) {
        if (_addresses[i].isDefault) {
          _addresses[i] = _addresses[i].copyWith(isDefault: false);
        }
      }
    } else if (_addresses.isEmpty) {
      // If it's the first address, make it default automatically
      address = address.copyWith(isDefault: true);
    }
    
    _addresses.add(address);
    _saveAddresses();
    notifyListeners();
  }

  void updateAddress(Address updatedAddress) {
    final index = _addresses.indexWhere((a) => a.id == updatedAddress.id);
    if (index >= 0) {
      if (updatedAddress.isDefault) {
        // Unset other defaults
        for (var i = 0; i < _addresses.length; i++) {
          if (_addresses[i].id != updatedAddress.id && _addresses[i].isDefault) {
            _addresses[i] = _addresses[i].copyWith(isDefault: false);
          }
        }
      }
      
      _addresses[index] = updatedAddress;
      _saveAddresses();
      notifyListeners();
    }
  }

  void removeAddress(String id) {
    final removedAddress = _addresses.firstWhere((a) => a.id == id);
    _addresses.removeWhere((a) => a.id == id);
    
    // If we removed the default address and there are others left, make the first one default
    if (removedAddress.isDefault && _addresses.isNotEmpty) {
      _addresses[0] = _addresses[0].copyWith(isDefault: true);
    }
    
    _saveAddresses();
    notifyListeners();
  }

  void setDefaultAddress(String id) {
    bool changed = false;
    for (var i = 0; i < _addresses.length; i++) {
      if (_addresses[i].id == id) {
        if (!_addresses[i].isDefault) {
          _addresses[i] = _addresses[i].copyWith(isDefault: true);
          changed = true;
        }
      } else {
        if (_addresses[i].isDefault) {
          _addresses[i] = _addresses[i].copyWith(isDefault: false);
          changed = true;
        }
      }
    }
    
    if (changed) {
      _saveAddresses();
      notifyListeners();
    }
  }
}
