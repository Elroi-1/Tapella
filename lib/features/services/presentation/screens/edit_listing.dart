import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/app_scaffold.dart';
import 'package:tapella/core/widgets/bottom_navbar.dart';
import 'package:go_router/go_router.dart';
import 'package:tapella/core/widgets/app_bar.dart';
import '../providers/listings_provider.dart';

class EditListingScreen extends ConsumerStatefulWidget {
  final String listingId;
  const EditListingScreen({super.key, required this.listingId});

  @override
  ConsumerState<EditListingScreen> createState() => _EditListingScreenState();
}

class _EditListingScreenState extends ConsumerState<EditListingScreen> {
  String? selectedCategory;
  final serviceTitleController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  bool _saving = false;
  bool _initialized = false;

  @override
  void dispose() {
    serviceTitleController.dispose();
    phoneNumberController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    super.dispose();
  }

  void _initialize(dynamic listing) {
    if (_initialized) return;
    serviceTitleController.text = listing.title;
    descriptionController.text = listing.description;
    phoneNumberController.text = listing.phone ?? '';
    locationController.text = listing.location;
    selectedCategory = listing.category;
    _initialized = true;
  }

  Future<void> _save() async {
    if (selectedCategory == null || serviceTitleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and category required')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await ref
          .read(createListingProvider.notifier)
          .updateListing(widget.listingId, {
            'title': serviceTitleController.text.trim(),
            'description': descriptionController.text.trim(),
            'category': selectedCategory,
            'phone': phoneNumberController.text.trim(),
            'location': locationController.text.trim().isEmpty
                ? 'Addis Ababa'
                : locationController.text.trim(),
          });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Listing updated')));
        context.go('/business/profile');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final listingAsync = ref.watch(listingDetailProvider(widget.listingId));

    return AppScaffold(
      extendBody: true,
      appBar: CustomAppBar(
        onMenuPressed: () => context.pop(),
        leading: const Icon(Icons.arrow_back, color: Color(0xFFADC6FF)),
        title: 'Edit Service',
      ),
      body: listingAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (result) {
          _initialize(result.data);
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 26),
                const Text(
                  'Edit Listing',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontFamily: 'inter',
                    height: 40 / 36,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 20),
                _buildLabel('Service Title'),
                _buildTextField(
                  hint: 'e.g. Premium Identity Design',
                  controller: serviceTitleController,
                ),
                _buildLabel('Category'),
                _buildDropdownField(
                  hint: 'Select Category',
                  value: selectedCategory,
                  items: const [
                    'Plumbing',
                    'Cleaning',
                    'Development',
                    'Design',
                    'Marketing',
                  ],
                  onChanged: (val) => setState(() => selectedCategory = val),
                ),
                _buildLabel('Phone Number'),
                _buildTextField(
                  hint: '0912345678',
                  controller: phoneNumberController,
                ),
                _buildLabel('Location'),
                _buildTextField(
                  hint: 'Bole, Addis Ababa',
                  controller: locationController,
                ),
                _buildLabel('Description'),
                _buildTextField(
                  hint: 'Describe what makes your service unique...',
                  maxLines: 5,
                  controller: descriptionController,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: _saving ? null : _save,
                    icon: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check),
                    label: Text(_saving ? 'Updating...' : 'Update Listing'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0066CC),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/business/home');
            case 1:
              context.go('/business/requests');
            case 2:
              context.go('/business/profile');
          }
        },
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 20),
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFFADC6FF), fontSize: 16),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    int maxLines = 1,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.06),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Colors.grey, width: 0.3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Color(0xFF0066CC)),
        ),
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey, width: 0.3),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: const TextStyle(color: Colors.grey)),
          isExpanded: true,
          dropdownColor: const Color(0xFF0A0F1D),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
          style: const TextStyle(color: Colors.white, fontSize: 16),
          items: items.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
