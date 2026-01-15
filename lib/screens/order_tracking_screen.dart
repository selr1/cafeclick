import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../providers/app_state.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  bool _isNearby = false;
  bool _showQR = false;
  String _qrCode = '';
  double _distanceToMahallah = 0.8;
  Timer? _locationTimer;
  Timer? _qrTimer;

  @override
  void initState() {
    super.initState();
    // Simulate geofencing
    _locationTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          double newDistance = _distanceToMahallah - 0.1;
          if (newDistance < 0.05) newDistance = 0.05;
          _distanceToMahallah = newDistance;
          _isNearby = newDistance <= 0.5;
        });
      }
    });
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    _qrTimer?.cancel();
    super.dispose();
  }

  void _handleImHere() {
    final order = context.read<AppState>().activeOrders.last;
    setState(() {
      _qrCode = 'PICKUP-${order.id}-${DateTime.now().millisecondsSinceEpoch}';
      _showQR = true;
    });

    _qrTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      if (mounted) {
        setState(() {
          _qrCode = 'PICKUP-${order.id}-${DateTime.now().millisecondsSinceEpoch}';
        });
      }
    });
  }

  void _handlePickupComplete() {
    Navigator.of(context).pushReplacementNamed('/review');
  }

  @override
  Widget build(BuildContext context) {
    // For demo purposes, we just take the last active order
    final orders = context.watch<AppState>().activeOrders;
    if (orders.isEmpty) {
      return const Scaffold(body: Center(child: Text('No active orders')));
    }
    final order = orders.last;
    final mahallah = context.watch<AppState>().selectedMahallah;

    if (_showQR) {
      return _buildQRModal(order);
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header
              const SizedBox(height: 24),
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFF4A4458),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  order.status == 'ready' ? Icons.check_circle : Icons.access_time,
                  size: 40,
                  color: const Color(0xFFD0BCFF),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                order.status == 'ready' ? 'Order Ready!' : 'Preparing Your Order',
                style: const TextStyle(color: Color(0xFFE6E1E5), fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Order #${order.id}',
                style: const TextStyle(color: Color(0xFFCAC4D0)),
              ),
              const SizedBox(height: 32),

              // Geofencing Alert
              if (order.status == 'ready')
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: _isNearby ? const Color(0xFF1F3823) : const Color(0xFF2B2930),
                    borderRadius: BorderRadius.circular(16),
                    border: _isNearby ? Border.all(color: const Color(0xFFA8DAB5), width: 2) : null,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, color: _isNearby ? const Color(0xFFA8DAB5) : const Color(0xFFCAC4D0)),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isNearby ? "📍 You're near the cafe!" : "📍 Distance to cafe",
                                style: TextStyle(color: _isNearby ? const Color(0xFFA8DAB5) : const Color(0xFFE6E1E5), fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${_distanceToMahallah.toStringAsFixed(2)} km away',
                                style: const TextStyle(color: Color(0xFFCAC4D0), fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (_isNearby) ...[
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFA8DAB5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '✓ Within pickup range',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color(0xFF1F3823), fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _handleImHere,
                            icon: const Icon(Icons.qr_code),
                            label: const Text("I'm Here - Show QR Code"),
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF211F26),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Get within 500m to enable pickup',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color(0xFF938F99), fontSize: 12),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

              // Status Progress
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF2B2930),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildStatusStep(1, 'Order Sent', 'Your order has been received', order.status),
                    _buildStatusStep(2, 'Preparing', 'The cafe is preparing your food', order.status),
                    _buildStatusStep(3, 'Ready for Pickup', 'Your order is ready to collect!', order.status, isLast: true),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Pickup Location
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2B2930),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Pickup Location', style: TextStyle(color: Color(0xFFE6E1E5), fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(color: Color(0xFF4A4458), shape: BoxShape.circle),
                          child: const Icon(Icons.store, color: Color(0xFFD0BCFF), size: 20),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(mahallah?.name ?? 'Unknown', style: const TextStyle(color: Color(0xFFE6E1E5))),
                            const Text('Cafeteria Counter', style: TextStyle(color: Color(0xFFCAC4D0), fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
                    const Text('Order Summary', style: TextStyle(color: Color(0xFFE6E1E5), fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${item.quantity}x ${item.name}', style: const TextStyle(color: Color(0xFFCAC4D0))),
                          Text('RM ${(item.price * item.quantity).toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFFE6E1E5))),
                        ],
                      ),
                    )),
                    const Divider(color: Color(0xFF49454F)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total', style: TextStyle(color: Color(0xFFE6E1E5), fontWeight: FontWeight.bold)),
                        Text('RM ${order.total.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFFD0BCFF), fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              if (order.status == 'ready' && !_isNearby)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF49454F),
                      foregroundColor: const Color(0xFFCAC4D0),
                    ),
                    child: const Text('Back to Home'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQRModal(Order order) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF2B2930),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Show QR to Staff', style: TextStyle(color: Color(0xFFE6E1E5), fontSize: 20, fontWeight: FontWeight.bold)),
                Text('Order #${order.id}', style: const TextStyle(color: Color(0xFFCAC4D0))),
                const SizedBox(height: 24),
                Container(
                  width: 200,
                  height: 200,
                  color: Colors.white,
                  child: const Center(
                    child: Icon(Icons.qr_code, size: 150, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF211F26),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text('Verification Code', style: TextStyle(color: Color(0xFF938F99), fontSize: 12)),
                      Text(_qrCode, style: const TextStyle(color: Color(0xFFD0BCFF), fontFamily: 'monospace')),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Code refreshes every 60 seconds', style: TextStyle(color: Color(0xFFCAC4D0), fontSize: 12)),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handlePickupComplete,
                    child: const Text('Order Collected'),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => _showQR = false),
                  child: const Text('Back to Order Details', style: TextStyle(color: Color(0xFFCAC4D0))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusStep(int step, String title, String subtitle, String currentStatus, {bool isLast = false}) {
    int currentStep = 1;
    if (currentStatus == 'preparing') currentStep = 2;
    if (currentStatus == 'ready') currentStep = 3;

    final isActive = currentStep >= step;
    final isCurrent = currentStep == step;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFFD0BCFF) : const Color(0xFF49454F),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCurrent && step == 2 ? Icons.access_time : Icons.check,
                  color: isActive ? const Color(0xFF381E72) : const Color(0xFF938F99),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: currentStep > step ? const Color(0xFFD0BCFF) : const Color(0xFF49454F),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: isActive ? const Color(0xFFE6E1E5) : const Color(0xFF938F99), fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(color: Color(0xFFCAC4D0), fontSize: 12)),
                  if (isCurrent && step == 2)
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text('Estimated time: 10-15 minutes', style: TextStyle(color: Color(0xFFD0BCFF), fontSize: 12)),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
