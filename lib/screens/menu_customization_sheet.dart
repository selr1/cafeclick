import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class MenuCustomizationSheet extends StatefulWidget {
  const MenuCustomizationSheet({super.key});

  @override
  State<MenuCustomizationSheet> createState() => _MenuCustomizationSheetState();
}

class _MenuCustomizationSheetState extends State<MenuCustomizationSheet> {
  int _quantity = 1;
  bool _addEgg = false;
  String _spicyLevel = 'mild';

  double _calculateTotal(MenuItem item) {
    double total = item.price * _quantity;
    if (_addEgg) total += 1.00 * _quantity;
    return total;
  }

  void _handleAddToCart(MenuItem item) {
    final cartItem = CartItem(
      id: item.id,
      name: item.name,
      price: item.price,
      category: item.category,
      image: item.image,
      quantity: _quantity,
      customizations: {
        'addEgg': _addEgg,
        'spicyLevel': _spicyLevel,
      },
    );

    context.read<AppState>().addToCart(cartItem);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context)!.settings.arguments as MenuItem;

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.7),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
          decoration: const BoxDecoration(
            color: Color(0xFF1C1B1F),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Customize Order',
                      style: TextStyle(color: Color(0xFFE6E1E5), fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Color(0xFFCAC4D0)),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFF36343B)),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          item.image,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => 
                            Container(height: 200, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Info
                      Text(
                        item.name,
                        style: const TextStyle(color: Color(0xFFE6E1E5), fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'RM ${item.price.toStringAsFixed(2)}',
                        style: const TextStyle(color: Color(0xFFD0BCFF), fontSize: 18),
                      ),
                      const SizedBox(height: 24),

                      // Quantity
                      const Text('Quantity', style: TextStyle(color: Color(0xFFE6E1E5), fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildQuantityButton(Icons.remove, () => setState(() => _quantity = _quantity > 1 ? _quantity - 1 : 1)),
                          SizedBox(
                            width: 40,
                            child: Text(
                              _quantity.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Color(0xFFE6E1E5), fontSize: 18),
                            ),
                          ),
                          _buildQuantityButton(Icons.add, () => setState(() => _quantity++)),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Add-ons
                      if (item.category != 'drinks') ...[
                        const Text('Add-ons', style: TextStyle(color: Color(0xFFE6E1E5), fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: () => setState(() => _addEgg = !_addEgg),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _addEgg ? const Color(0xFF2B2930) : const Color(0xFF1C1B1F),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _addEgg ? const Color(0xFFD0BCFF) : const Color(0xFF49454F),
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: _addEgg ? const Color(0xFFD0BCFF) : Colors.transparent,
                                        border: Border.all(
                                          color: _addEgg ? const Color(0xFFD0BCFF) : const Color(0xFF938F99),
                                          width: 2,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: _addEgg
                                          ? const Icon(Icons.check, size: 14, color: Color(0xFF381E72))
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    const Text('Add Egg', style: TextStyle(color: Color(0xFFE6E1E5))),
                                  ],
                                ),
                                const Text('+RM 1.00', style: TextStyle(color: Color(0xFFD0BCFF))),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Spicy Level
                      if (item.category == 'rice' || item.category == 'noodles') ...[
                        const Text('Spicy Level', style: TextStyle(color: Color(0xFFE6E1E5), fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildSpicyOption('mild', '🌶️ Mild'),
                            const SizedBox(width: 8),
                            _buildSpicyOption('medium', '🌶️🌶️ Medium'),
                            const SizedBox(width: 8),
                            _buildSpicyOption('hot', '🌶️🌶️🌶️ Hot'),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Footer
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color(0xFF1C1B1F),
                  border: Border(top: BorderSide(color: Color(0xFF36343B))),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _handleAddToCart(item),
                    child: Text('Add to Basket - RM ${_calculateTotal(item).toStringAsFixed(2)}'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: Color(0xFF4A4458),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFFD0BCFF)),
      ),
    );
  }

  Widget _buildSpicyOption(String value, String label) {
    final isSelected = _spicyLevel == value;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _spicyLevel = value),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2B2930) : const Color(0xFF1C1B1F),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFFD0BCFF) : const Color(0xFF49454F),
              width: 2,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? const Color(0xFFD0BCFF) : const Color(0xFF938F99),
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
