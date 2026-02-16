import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/address_provider.dart';
import '../../models/address_model.dart';
import '../../theme/app_theme.dart';
import 'add_edit_address_screen.dart';

class AddressListScreen extends StatelessWidget {
  const AddressListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Addresses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToAddAddress(context),
          ),
        ],
      ),
      body: Consumer<AddressProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.addresses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_off_outlined, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No addresses found', style: AppTextStyles.subheading),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => _navigateToAddAddress(context),
                    child: const Text('Add New Address'),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            itemCount: provider.addresses.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final address = provider.addresses[index];
              return ListTile(
                title: Text(address.name),
                subtitle: Text(
                  '${address.addressLine}, ${address.city}, ${address.province}, ${address.country} ${address.zipCode}\n${address.phone}',
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (address.isDefault)
                      const Icon(Icons.star, color: Colors.amber),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _navigateToEditAddress(context, address),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(context, address),
                    ),
                  ],
                ),
                onTap: () {
                  // If this screen was opened for selection, return the selected address
                  // Navigator.pop(context, address);
                },
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToAddAddress(BuildContext context) async {
    final newAddress = await Navigator.push<Address>(
      context,
      MaterialPageRoute(builder: (_) => const AddEditAddressScreen()),
    );

    if (newAddress != null) {
      context.read<AddressProvider>().addAddress(newAddress);
    }
  }

  void _navigateToEditAddress(BuildContext context, Address address) async {
    final updatedAddress = await Navigator.push<Address>(
      context,
      MaterialPageRoute(builder: (_) => AddEditAddressScreen(address: address)),
    );

    if (updatedAddress != null) {
      context.read<AddressProvider>().updateAddress(updatedAddress);
    }
  }

  void _confirmDelete(BuildContext context, Address address) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Address?'),
        content: const Text('Are you sure you want to remove this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<AddressProvider>().removeAddress(address.id);
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
