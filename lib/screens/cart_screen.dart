import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String _paymentMethod = 'online';

  double _calculateSubtotal(List<CartItem> cart) {
    return cart.fold(0, (sum, item) {
      double itemTotal = item.price * item.quantity;
      if (item.customizations['addEgg'] == true) {
        itemTotal += 1.00 * item.quantity;
      }
      return sum + itemTotal;
    });
  }

  void _handlePlaceOrder() {
    context.read<AppState>().placeOrder();
    Navigator.of(context).pushReplacementNamed('/order-tracking');
  }

  @override
  Widget build(BuildContext context) {
    final mahallah = context.watch<AppState>().selectedMahallah;
    final cart = context.watch<AppState>().cart;
    final subtotal = _calculateSubtotal(cart);
    const serviceFee = 0.50;
    final total = subtotal + serviceFee;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1B1F),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFCAC4D0)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Cart & Checkout', style: TextStyle(color: Color(0xFFE6E1E5))),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location Alert
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A4458),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Color(0xFFD0BCFF)),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Picking up from:', style: TextStyle(color: Color(0xFFD0BCFF), fontWeight: FontWeight.bold)),
                            Text(mahallah?.name ?? 'Unknown', style: const TextStyle(color: Color(0xFFEADDFF))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Order Items
                  const Text('Order Items', style: TextStyle(color: Color(0xFFE6E1E5), fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ...cart.map((item) => _buildCartItem(item)),
                  const SizedBox(height: 24),

                  // Payment Method
                  const Text('Payment Method', style: TextStyle(color: Color(0xFFE6E1E5), fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildPaymentOption('online', 'Online Banking / QR', Icons.smartphone),
                  const SizedBox(height: 8),
                  _buildPaymentOption('cash', 'Cash on Pickup', Icons.credit_card),
                  const SizedBox(height: 24),

                  // Order Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B2930),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Order Summary', style: TextStyle(color: Color(0xFFE6E1E5), fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        _buildSummaryRow('Subtotal', subtotal),
                        _buildSummaryRow('Service Fee', serviceFee),
                        const Divider(color: Color(0xFF49454F), height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total', style: TextStyle(color: Color(0xFFE6E1E5), fontSize: 16, fontWeight: FontWeight.bold)),
                            Text('RM ${total.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFFD0BCFF), fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF211F26),
              border: Border(top: BorderSide(color: Color(0xFF36343B))),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: cart.isEmpty ? null : _handlePlaceOrder,
                child: Text('Place Order - RM ${total.toStringAsFixed(2)}'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    double itemTotal = item.price * item.quantity;
    if (item.customizations['addEgg'] == true) {
      itemTotal += 1.00 * item.quantity;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF2B2930),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                item.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => 
                  Container(width: 80, height: 80, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(color: Color(0xFFE6E1E5), fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  if (item.customizations['addEgg'] == true)
                    const Text('• Add Egg', style: TextStyle(color: Color(0xFFCAC4D0), fontSize: 12)),
                  if (item.customizations['spicyLevel'] != null)
                    Text('• ${item.customizations['spicyLevel']} spicy', style: const TextStyle(color: Color(0xFFCAC4D0), fontSize: 12)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Qty: ${item.quantity}', style: const TextStyle(color: Color(0xFF938F99), fontSize: 14)),
                      Text('RM ${itemTotal.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFFD0BCFF), fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String value, String label, IconData icon) {
    final isSelected = _paymentMethod == value;
    return InkWell(
      onTap: () => setState(() => _paymentMethod = value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2B2930) : const Color(0xFF1C1B1F),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFD0BCFF) : const Color(0xFF49454F),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? const Color(0xFFD0BCFF) : const Color(0xFF938F99),
                  width: 2,
                ),
                shape: BoxShape.circle,
              ),
              child: isSelected
                  ? Center(child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFFD0BCFF), shape: BoxShape.circle)))
                  : null,
            ),
            const SizedBox(width: 12),
            Icon(icon, color: const Color(0xFFCAC4D0)),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(color: Color(0xFFE6E1E5))),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFFCAC4D0))),
          Text('RM ${amount.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFFCAC4D0))),
        ],
      ),
    );
  }
}
