class MockData {
  static const String adminUser = 'admin';
  static const String adminPass = 'admin';

  static final Map<String, dynamic> userProfile = {
    'name': 'Alex Barista',
    'role': 'Store Manager',
    'avatarUrl': 'https://i.pravatar.cc/150?img=11',
  };

  static final List<Map<String, dynamic>> dashboardStats = [
    {'title': 'Total Orders', 'value': '124', 'icon': 0xe59c}, // local_cafe
    {'title': 'Revenue', 'value': '\$1,240', 'icon': 0xe227}, // attach_money
    {'title': 'Pending', 'value': '12', 'icon': 0xef64}, // pending_actions
  ];

  static final List<Map<String, dynamic>> recentOrders = [
    {'id': '#1001', 'item': 'Latte', 'status': 'Completed', 'amount': 4.50},
    {'id': '#1002', 'item': 'Cappuccino', 'status': 'Processing', 'amount': 5.00},
    {'id': '#1003', 'item': 'Espresso', 'status': 'Pending', 'amount': 3.00},
    {'id': '#1004', 'item': 'Mocha', 'status': 'Completed', 'amount': 5.50},
    {'id': '#1005', 'item': 'Americano', 'status': 'Cancelled', 'amount': 3.50},
  ];
}
