import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int _rating = 0;
  final _feedbackController = TextEditingController();
  bool _submitted = false;

  void _handleSubmit() {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating before submitting')),
      );
      return;
    }

    setState(() => _submitted = true);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // For demo, just use dummy data if no active order
    final orders = context.read<AppState>().activeOrders;
    final orderId = orders.isNotEmpty ? orders.last.id : '1001';
    final mahallahName = context.read<AppState>().selectedMahallah?.name ?? 'Mahallah Asiah';

    if (_submitted) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFFA8DAB5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 40, color: Color(0xFF1F3823)),
              ),
              const SizedBox(height: 16),
              const Text(
                'Thank You!',
                style: TextStyle(color: Color(0xFFE6E1E5), fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your feedback helps us improve',
                style: TextStyle(color: Color(0xFFCAC4D0)),
              ),
            ],
          ),
        ),
      );
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
                child: const Icon(Icons.star, size: 40, color: Color(0xFFD0BCFF)),
              ),
              const SizedBox(height: 16),
              const Text(
                'How was your experience?',
                style: TextStyle(color: Color(0xFFE6E1E5), fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Order #$orderId from $mahallahName',
                style: const TextStyle(color: Color(0xFFCAC4D0)),
              ),
              const SizedBox(height: 32),

              // Rating
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF2B2930),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text('Rate your order *', style: TextStyle(color: Color(0xFFE6E1E5), fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final star = index + 1;
                        return IconButton(
                          onPressed: () => setState(() => _rating = star),
                          icon: Icon(
                            Icons.star,
                            size: 32,
                            color: star <= _rating ? const Color(0xFFFFD700) : const Color(0xFF49454F),
                          ),
                        );
                      }),
                    ),
                    if (_rating > 0) ...[
                      const SizedBox(height: 8),
                      Text(
                        _getRatingText(_rating),
                        style: const TextStyle(color: Color(0xFFD0BCFF)),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Feedback
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2B2930),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Share your feedback (Optional)', style: TextStyle(color: Color(0xFFE6E1E5))),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _feedbackController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: 'Tell us about your experience...',
                        filled: true,
                        fillColor: Color(0xFF211F26),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF49454F)),
                        ),
                      ),
                      style: const TextStyle(color: Color(0xFFE6E1E5)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _handleSubmit,
                  icon: const Icon(Icons.send),
                  label: const Text('Submit Review'),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false),
                child: const Text('Skip for now', style: TextStyle(color: Color(0xFFCAC4D0))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1: return 'Poor';
      case 2: return 'Fair';
      case 3: return 'Good';
      case 4: return 'Very Good';
      case 5: return 'Excellent';
      default: return '';
    }
  }
}
