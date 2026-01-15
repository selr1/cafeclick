import 'package:flutter/material.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> with SingleTickerProviderStateMixin {
  bool _isScanning = true;
  bool _scanSuccess = false;
  final _codeController = TextEditingController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleSimulateScan() {
    setState(() {
      _isScanning = false;
      _scanSuccess = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  void _handleManualSubmit() {
    if (_codeController.text.isNotEmpty) {
      _handleSimulateScan();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_scanSuccess) {
      return Scaffold(
        backgroundColor: const Color(0xFF1C1B1F),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color(0xFFA8DAB5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, size: 60, color: Color(0xFF1F3823)),
              ),
              const SizedBox(height: 24),
              const Text(
                'Scan Successful!',
                style: TextStyle(color: Color(0xFFE6E1E5), fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Order verified',
                style: TextStyle(color: Color(0xFFCAC4D0)),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2930),
        title: const Text('Scan Customer QR', style: TextStyle(color: Color(0xFFE6E1E5))),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFFE6E1E5)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isScanning ? _buildScannerView() : _buildManualEntryView(),
    );
  }

  Widget _buildScannerView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Camera View Simulation
        Center(
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              color: const Color(0xFF2B2930),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(Icons.camera_alt, size: 100, color: Color(0xFFCAC4D0)),
                ),
                // Scanning Frame
                Center(
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFD0BCFF), width: 4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                // Scanning Line
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Positioned(
                      top: 25 + (250 * _animationController.value),
                      left: 25,
                      right: 25,
                      child: Container(
                        height: 2,
                        color: const Color(0xFFD0BCFF),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFD0BCFF).withOpacity(0.5),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        const Text('Position QR code within frame', style: TextStyle(color: Color(0xFFE6E1E5), fontSize: 16)),
        const Text('Camera will scan automatically', style: TextStyle(color: Color(0xFFCAC4D0), fontSize: 12)),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleSimulateScan,
              child: const Text('Simulate Scan (Demo)'),
            ),
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _isScanning = false),
          child: const Text('Enter code manually', style: TextStyle(color: Color(0xFFD0BCFF))),
        ),
      ],
    );
  }

  Widget _buildManualEntryView() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Manual Code Entry', style: TextStyle(color: Color(0xFFE6E1E5), fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          TextField(
            controller: _codeController,
            decoration: const InputDecoration(
              labelText: 'Verification Code',
              hintText: 'PICKUP-XXXX-XXXXX',
            ),
            style: const TextStyle(color: Color(0xFFE6E1E5), fontFamily: 'monospace'),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleManualSubmit,
              child: const Text('Verify Code'),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => setState(() => _isScanning = true),
            child: const Text('Back to scanning', style: TextStyle(color: Color(0xFFCAC4D0))),
          ),
        ],
      ),
    );
  }
}
