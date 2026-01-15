import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class LocationSelectionScreen extends StatelessWidget {
  const LocationSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mahallahs = [
      Mahallah(id: '1', name: 'Mahallah Asiah', status: 'open', queueLevel: 'low', distance: 0.2),
      Mahallah(id: '2', name: 'Mahallah Faruq', status: 'open', queueLevel: 'high', distance: 0.5),
      Mahallah(id: '3', name: 'Mahallah Siddiq', status: 'open', queueLevel: 'medium', distance: 1.2),
      Mahallah(id: '4', name: 'Mahallah Bilal', status: 'open', queueLevel: 'low', distance: 0.8),
      Mahallah(id: '5', name: 'Mahallah Uthman', status: 'closed', queueLevel: 'low', distance: 4.5),
      Mahallah(id: '6', name: 'Mahallah Aminah', status: 'open', queueLevel: 'medium', distance: 0.3),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const SizedBox(height: 16),
              Text(
                'Where are you eating today?',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: const Color(0xFFE6E1E5),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Search Bar
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Search Mahallah...',
                  prefixIcon: Icon(Icons.search, color: Color(0xFFCAC4D0)),
                  filled: true,
                  fillColor: Color(0xFF2B2930),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                ),
                style: TextStyle(color: Color(0xFFE6E1E5)),
              ),
              const SizedBox(height: 24),

              // Mahallah List
              Expanded(
                child: ListView.separated(
                  itemCount: mahallahs.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final mahallah = mahallahs[index];
                    return _buildMahallahCard(context, mahallah);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMahallahCard(BuildContext context, Mahallah mahallah) {
    final isOpen = mahallah.status == 'open';

    return InkWell(
      onTap: () {
        context.read<AppState>().selectMahallah(mahallah);
        Navigator.of(context).pushReplacementNamed('/home');
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2B2930),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFF4A4458),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on,
                color: Color(0xFFD0BCFF),
              ),
            ),
            const SizedBox(height: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mahallah.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFFE6E1E5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isOpen ? const Color(0xFF1F3823) : const Color(0xFF36343B),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isOpen ? 'Open' : 'Closed',
                          style: TextStyle(
                            color: isOpen ? const Color(0xFFA8DAB5) : const Color(0xFFCAC4D0),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      if (isOpen) ...[
                        const SizedBox(width: 8),
                        Text(
                          '${_getQueueEmoji(mahallah.queueLevel)} ${_getQueueText(mahallah.queueLevel)}',
                          style: const TextStyle(color: Color(0xFFCAC4D0), fontSize: 12),
                        ),
                        const SizedBox(width: 8),
                        const Text('•', style: TextStyle(color: Color(0xFF49454F), fontSize: 10)),
                        const SizedBox(width: 8),
                        Text(
                          '${_getDistanceEmoji(mahallah.distance)} ${mahallah.distance} km',
                          style: const TextStyle(color: Color(0xFFCAC4D0), fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Arrow
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF938F99),
            ),
          ],
        ),
      ),
    );
  }

  String _getQueueEmoji(String level) {
    switch (level) {
      case 'low': return '🟢';
      case 'medium': return '🟡';
      case 'high': return '🔴';
      default: return '⚪';
    }
  }

  String _getQueueText(String level) {
    switch (level) {
      case 'low': return 'Low Queue';
      case 'medium': return 'Medium Queue';
      case 'high': return 'High Queue';
      default: return '';
    }
  }

  String _getDistanceEmoji(double dist) {
    if (dist < 1.0) return '🟢';
    if (dist < 3.0) return '🟡';
    return '🔴';
  }
}
