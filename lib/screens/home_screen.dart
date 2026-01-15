import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;

    MenuItem(
      id: '1',
      name: 'Nasi Goreng USA',
      price: 5.50,
      category: 'rice',
      image: 'assets/images/nasigorengusa.jpg',
      popular: true,
    ),
    MenuItem(
      id: '2',
      name: 'Chicken Rice',
      price: 6.00,
      category: 'rice',
      image: 'assets/images/chickenrice.jpg',
      popular: true,
    ),
    MenuItem(
      id: '3',
      name: 'Mee Goreng',
      price: 5.00,
      category: 'noodles',
      image: 'assets/images/meegoreng.jpg',
      popular: true,
    ),
    MenuItem(
      id: '4',
      name: 'Chicken Chop',
      price: 8.50,
      category: 'western',
      image: 'assets/images/chickenchop.jpg',
    ),
    MenuItem(
      id: '5',
      name: 'Carbonara Pasta',
      price: 9.00,
      category: 'western',
      image: 'assets/images/carbonarapasta.jpg',
    ),
    MenuItem(
      id: '6',
      name: 'Juice',
      price: 2.50,
      category: 'drinks',
      image: 'assets/images/juice.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final mahallah = context.watch<AppState>().selectedMahallah;

    if (_currentTab == 3) {
      return _buildProfileTab();
    }

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Header
              SliverAppBar(
                backgroundColor: const Color(0xFF1C1B1F),
                floating: true,
                title: InkWell(
                  onTap: () => Navigator.of(context).pushNamed('/location'),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on, color: Color(0xFFD0BCFF), size: 20),
                        const SizedBox(width: 8),
                        Text(
                          mahallah?.name ?? 'Select Location',
                          style: const TextStyle(color: Color(0xFFD0BCFF), fontSize: 16),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down, color: Color(0xFFD0BCFF), size: 20),
                      ],
                    ),
                  ),
                ),
                automaticallyImplyLeading: false,
              ),

              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Welcome Banner
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4F378B), Color(0xFF6750A4)],
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome to ${mahallah?.name.replaceAll('Mahallah ', '') ?? ''} Cafe',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Today's Special: Nasi Goreng USA with Free Egg!",
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Categories
                    const Text(
                      'Categories',
                      style: TextStyle(color: Color(0xFFE6E1E5), fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCategoryItem('🍚', 'Rice'),
                        _buildCategoryItem('🍜', 'Noodles'),
                        _buildCategoryItem('🍔', 'Western'),
                        _buildCategoryItem('🥤', 'Drinks'),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Popular Now
                    const Text(
                      'Popular Now',
                      style: TextStyle(color: Color(0xFFE6E1E5), fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ..._menuItems.where((i) => i.popular).map((item) => _buildPopularItem(item)),
                    const SizedBox(height: 24),

                    // All Menu
                    const Text(
                      'All Menu',
                      style: TextStyle(color: Color(0xFFE6E1E5), fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                  ]),
                ),
              ),

              // Grid for All Menu
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildMenuItemCard(_menuItems[index]),
                    childCount: _menuItems.length,
                  ),
                ),
              ),
            ],
          ),

          // Bottom Navigation
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: const Color(0xFF211F26),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.home, 'Home'),
                  _buildNavItem(1, Icons.description, 'Menu'),
                  _buildNavItem(2, Icons.shopping_bag, 'Cart', 
                    badge: context.watch<AppState>().cartItemCount),
                  _buildNavItem(3, Icons.person, 'Profile'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    final user = context.watch<AppState>().currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Color(0xFFE6E1E5))),
        backgroundColor: const Color(0xFF1C1B1F),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // User Info
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B2930),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4A4458),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, color: Color(0xFFD0BCFF), size: 32),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? 'Guest',
                            style: const TextStyle(color: Color(0xFFE6E1E5), fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            user?.email ?? '',
                            style: const TextStyle(color: Color(0xFFCAC4D0), fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Preferences
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B2930),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Preferences', style: TextStyle(color: Color(0xFFE6E1E5), fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      _buildPreferenceItem('Order History'),
                      const SizedBox(height: 8),
                      _buildPreferenceItem('Saved Addresses'),
                      const SizedBox(height: 8),
                      _buildPreferenceItem('Payment Methods'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Logout
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<AppState>().logout();
                    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF601410),
                    foregroundColor: const Color(0xFFF2B8B5),
                  ),
                ),
              ],
            ),
          ),
          // Bottom Nav
          Container(
            color: const Color(0xFF211F26),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home, 'Home'),
                _buildNavItem(1, Icons.description, 'Menu'),
                _buildNavItem(2, Icons.shopping_bag, 'Cart', 
                  badge: context.watch<AppState>().cartItemCount),
                _buildNavItem(3, Icons.person, 'Profile'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceItem(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF211F26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(title, style: const TextStyle(color: Color(0xFFCAC4D0))),
    );
  }

  Widget _buildCategoryItem(String emoji, String label) {
    return Container(
      width: 80,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2930),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Color(0xFFE6E1E5), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildPopularItem(MenuItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showCustomizationSheet(item),
        borderRadius: BorderRadius.circular(16),
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
                    Text(
                      'RM ${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(color: Color(0xFFD0BCFF)),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF938F99)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItemCard(MenuItem item) {
    return InkWell(
      onTap: () => _showCustomizationSheet(item),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2B2930),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  item.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => 
                    Container(color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color(0xFFE6E1E5), fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'RM ${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(color: Color(0xFFD0BCFF), fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, {int badge = 0}) {
    final isSelected = _currentTab == index;
    return InkWell(
      onTap: () {
        if (index == 2) {
          Navigator.of(context).pushNamed('/cart');
        } else {
          setState(() => _currentTab = index);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF4A4458) : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? const Color(0xFFD0BCFF) : const Color(0xFFCAC4D0),
                ),
              ),
              if (badge > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF2B8B5),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      badge.toString(),
                      style: const TextStyle(color: Color(0xFF601410), fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFFD0BCFF) : const Color(0xFFCAC4D0),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomizationSheet(MenuItem item) {
    Navigator.of(context).pushNamed('/menu-customization', arguments: item);
  }
}
