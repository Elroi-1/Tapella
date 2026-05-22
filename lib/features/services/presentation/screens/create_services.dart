import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/app_scaffold.dart';
import 'package:tapella/core/widgets/bottom_navbar.dart';
import 'package:go_router/go_router.dart';
import 'package:tapella/core/widgets/app_bar.dart';
import 'package:tapella/core/theme/app_colors.dart';
import '../providers/listings_provider.dart';

class CreateServiceBody extends ConsumerStatefulWidget {
  const CreateServiceBody({super.key});

  @override
  ConsumerState<CreateServiceBody> createState() => _CreateServiceBodyState();
}

class _CreateServiceBodyState extends ConsumerState<CreateServiceBody> {
  bool isCallEnabled = false;
  String? selectedCategory;
  final serviceTitleController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    serviceTitleController.dispose();
    phoneNumberController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    super.dispose();
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
      await ref.read(createListingProvider.notifier).createListing({
        'title': serviceTitleController.text.trim(),
        'description': descriptionController.text.trim(),
        'category': selectedCategory,
        'phone': phoneNumberController.text.trim(),
        'location': locationController.text.trim().isEmpty
            ? 'Addis Ababa'
            : locationController.text.trim(),
        'priceEtb': 0,
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Listing saved')));
        context.go('/business/home');
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
    return AppScaffold(
      extendBody: true,
      appBar: CustomAppBar(
        onMenuPressed: () => context.pop(),
        leading: const Icon(Icons.arrow_back, color: Color(0xFFADC6FF)),
        title: 'Create New Service',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 26),
            const Text(
              'New Listing',
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
                    : const Icon(Icons.file_upload_outlined),
                label: Text(_saving ? 'Saving...' : 'Save Listing'),
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
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 3,
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
          borderSide: const BorderSide(color: Colors.grey, width: 0.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        border: Border.all(color: Colors.grey, width: 0.3),
        borderRadius: BorderRadius.circular(25),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: const TextStyle(color: Colors.white24)),
          isExpanded: true,
          dropdownColor: AppColors.backgroundAlt,
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
