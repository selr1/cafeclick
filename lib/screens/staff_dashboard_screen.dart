import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class StaffDashboardScreen extends StatefulWidget {
  const StaffDashboardScreen({super.key});

  @override
  State<StaffDashboardScreen> createState() => _StaffDashboardScreenState();
}

class _StaffDashboardScreenState extends State<StaffDashboardScreen> {
  bool _isOpen = true;
  // Mock menu items for editing
  final List<MenuItem> _menuItems = [
    MenuItem(id: '1', name: 'Nasi Goreng USA', price: 5.50, category: 'rice', image: '', isAvailable: true),
    MenuItem(id: '2', name: 'Chicken Rice', price: 6.00, category: 'rice', image: '', isAvailable: true),
    MenuItem(id: '3', name: 'Mee Goreng', price: 5.00, category: 'noodles', image: '', isAvailable: true),
    MenuItem(id: '4', name: 'Chicken Chop', price: 8.50, category: 'western', image: '', isAvailable: false),
    MenuItem(id: '5', name: 'Carbonara Pasta', price: 9.00, category: 'western', image: '', isAvailable: true),
    MenuItem(id: '6', name: 'Iced Milo', price: 2.50, category: 'drinks', image: '', isAvailable: true),
  ];

  String? _editingItemId;
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  void _toggleStallStatus() {
    setState(() => _isOpen = !_isOpen);
  }

  void _toggleItemAvailability(String id) {
    setState(() {
      final index = _menuItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        final item = _menuItems[index];
        _menuItems[index] = MenuItem(
          id: item.id,
          name: item.name,
          price: item.price,
          category: item.category,
          image: item.image,
          isAvailable: !item.isAvailable,
        );
      }
    });
  }

  void _startEditing(MenuItem item) {
    setState(() {
      _editingItemId = item.id;
      _nameController.text = item.name;
      _priceController.text = item.price.toString();
    });
  }

  void _saveEdit(String id) {
    setState(() {
      final index = _menuItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        final item = _menuItems[index];
        _menuItems[index] = MenuItem(
          id: item.id,
          name: _nameController.text,
          price: double.tryParse(_priceController.text) ?? item.price,
          category: item.category,
          image: item.image,
          isAvailable: item.isAvailable,
        );
        _editingItemId = null;
      }
    });
  }

  void _deleteItem(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2B2930),
        title: const Text('Delete Item?', style: TextStyle(color: Color(0xFFE6E1E5))),
        content: const Text('Are you sure you want to delete this item?', style: TextStyle(color: Color(0xFFCAC4D0))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFFD0BCFF))),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _menuItems.removeWhere((item) => item.id == id);
              });
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Color(0xFFF2B8B5))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppState>().currentUser;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFF2B2930),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Staff Dashboard', style: TextStyle(color: Color(0xFFE6E1E5), fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(user?.name ?? 'Staff', style: const TextStyle(color: Color(0xFFCAC4D0))),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<AppState>().logout();
                        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                      },
                      icon: const Icon(Icons.logout, color: Color(0xFFD0BCFF)),
                      style: IconButton.styleFrom(backgroundColor: const Color(0xFF4A4458)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Stall Status
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF2B2930),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.power_settings_new, color: _isOpen ? const Color(0xFFA8DAB5) : const Color(0xFF938F99)),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Stall Status', style: TextStyle(color: Color(0xFFE6E1E5), fontWeight: FontWeight.bold)),
                                Text(_isOpen ? 'Open for orders' : 'Closed', style: const TextStyle(color: Color(0xFFCAC4D0), fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                        Switch(
                          value: _isOpen,
                          onChanged: (value) => _toggleStallStatus(),
                          activeThumbColor: const Color(0xFFD0BCFF),
                          activeTrackColor: const Color(0xFF4F378B),
                        ),
                      ],
                    ),
                    if (_isOpen) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F3823),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('✓ Accepting new orders', style: TextStyle(color: Color(0xFFA8DAB5), fontSize: 12)),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Scan QR Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pushNamed('/qr-scanner'),
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Scan Customer QR Code'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD0BCFF), // Gradient not supported directly in styleFrom, using solid color
                    foregroundColor: const Color(0xFF381E72),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Menu Management
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2B2930),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Menu Management', style: TextStyle(color: Color(0xFFE6E1E5), fontWeight: FontWeight.bold)),
                        IconButton(
                          onPressed: () {}, // Add logic
                          icon: const Icon(Icons.add, color: Color(0xFFD0BCFF)),
                          style: IconButton.styleFrom(backgroundColor: const Color(0xFF4A4458)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ..._menuItems.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF211F26),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: _editingItemId == item.id
                            ? Column(
                                children: [
                                  TextField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(hintText: 'Item Name'),
                                    style: const TextStyle(color: Color(0xFFE6E1E5)),
                                  ),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: _priceController,
                                    decoration: const InputDecoration(hintText: 'Price'),
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(color: Color(0xFFE6E1E5)),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () => _saveEdit(item.id),
                                          child: const Text('Save'),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () => setState(() => _editingItemId = null),
                                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF49454F), foregroundColor: const Color(0xFFCAC4D0)),
                                          child: const Text('Cancel'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item.name, style: const TextStyle(color: Color(0xFFE6E1E5), fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text('RM ${item.price.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFFD0BCFF), fontSize: 12)),
                                            const SizedBox(width: 8),
                                            const Text('•', style: TextStyle(color: Color(0xFF938F99), fontSize: 10)),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: item.isAvailable ? const Color(0xFF1F3823) : const Color(0xFF601410),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                item.isAvailable ? 'Available' : 'Out of Stock',
                                                style: TextStyle(color: item.isAvailable ? const Color(0xFFA8DAB5) : const Color(0xFFF2B8B5), fontSize: 10),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => _toggleItemAvailability(item.id),
                                    icon: Icon(item.isAvailable ? Icons.visibility_off : Icons.visibility, size: 20),
                                    color: item.isAvailable ? const Color(0xFFCAC4D0) : const Color(0xFFA8DAB5),
                                  ),
                                  IconButton(
                                    onPressed: () => _startEditing(item),
                                    icon: const Icon(Icons.edit, size: 20, color: Color(0xFFD0BCFF)),
                                  ),
                                  IconButton(
                                    onPressed: () => _deleteItem(item.id),
                                    icon: const Icon(Icons.delete, size: 20, color: Color(0xFFF2B8B5)),
                                  ),
                                ],
                              ),
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2B2930),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Today's Summary", style: TextStyle(color: Color(0xFFE6E1E5), fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF211F26),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total Orders', style: TextStyle(color: Color(0xFFCAC4D0), fontSize: 12)),
                                SizedBox(height: 4),
                                Text('24', style: TextStyle(color: Color(0xFFD0BCFF), fontSize: 24, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF211F26),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Revenue', style: TextStyle(color: Color(0xFFCAC4D0), fontSize: 12)),
                                SizedBox(height: 4),
                                Text('RM 156', style: TextStyle(color: Color(0xFFD0BCFF), fontSize: 24, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
