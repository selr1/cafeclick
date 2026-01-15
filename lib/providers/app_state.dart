import 'package:flutter/material.dart';

// Data Models
class Mahallah {
  final String id;
  final String name;
  final String status; // 'open' | 'closed'
  final String queueLevel; // 'low' | 'medium' | 'high'
  final double distance;

  Mahallah({
    required this.id,
    required this.name,
    required this.status,
    required this.queueLevel,
    required this.distance,
  });
}

class MenuItem {
  final String id;
  final String name;
  final double price;
  final String category;
  final String image;
  final bool popular;
  final bool isAvailable;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.image,
    this.popular = false,
    this.isAvailable = true,
  });
}

class CartItem extends MenuItem {
  final int quantity;
  final Map<String, dynamic> customizations;

  CartItem({
    required String id,
    required String name,
    required double price,
    required String category,
    required String image,
    required this.quantity,
    required this.customizations,
  }) : super(
          id: id,
          name: name,
          price: price,
          category: category,
          image: image,
        );
}

class Order {
  final String id;
  final List<CartItem> items;
  final double total;
  final String status; // 'sent' | 'preparing' | 'ready' | 'completed'
  final DateTime timestamp;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.status,
    required this.timestamp,
  });
}

class User {
  final String id;
  final String name;
  final String email;
  final String role; // 'customer' | 'staff'
  final String? matricNo;
  final String? staffNo;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.matricNo,
    this.staffNo,
  });
}

class AppState extends ChangeNotifier {
  // User State
  User? _currentUser;
  bool get isLoggedIn => _currentUser != null;
  User? get currentUser => _currentUser;
  bool get isStaff => _currentUser?.role == 'staff';

  // Location State
  Mahallah? _selectedMahallah;
  Mahallah? get selectedMahallah => _selectedMahallah;

  // Cart State
  final List<CartItem> _cart = [];
  List<CartItem> get cart => _cart;
  int get cartItemCount => _cart.fold(0, (sum, item) => sum + item.quantity);

  // Order State
  final List<Order> _activeOrders = [];
  List<Order> get activeOrders => _activeOrders;

  // Actions
  bool login(String identifier, String password) {
    // Mock Login Logic
    if (identifier == 'admin' && password == 'admin') {
      _currentUser = User(
        id: '2',
        name: 'Cafe Staff',
        email: 'staff@iium.edu.my',
        role: 'staff',
        staffNo: 'STF001',
      );
      notifyListeners();
      return true;
    }
    
    if (identifier == 'student' && password == '123') {
       _currentUser = User(
        id: '1',
        name: 'Ahmad Student',
        email: 'student@iium.edu.my',
        role: 'customer',
        matricNo: '2012345',
      );
      notifyListeners();
      return true;
    }

    // Check mock users from mock_data if needed, but for now simple check
    return false;
  }

  void logout() {
    _currentUser = null;
    _selectedMahallah = null;
    _cart.clear();
    _activeOrders.clear();
    notifyListeners();
  }

  void selectMahallah(Mahallah mahallah) {
    _selectedMahallah = mahallah;
    notifyListeners();
  }

  void addToCart(CartItem item) {
    _cart.add(item);
    notifyListeners();
  }

  void removeFromCart(int index) {
    _cart.removeAt(index);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void placeOrder() {
    if (_cart.isEmpty) return;

    if (_cart.isEmpty) return;

    // Calculate total properly
    double calculatedTotal = 0;
    for (var item in _cart) {
       double itemTotal = item.price * item.quantity;
       if (item.customizations['addEgg'] == true) {
         itemTotal += 1.00 * item.quantity;
       }
       calculatedTotal += itemTotal;
    }
    calculatedTotal += 0.50; // Service fee

    final newOrder = Order(
      id: (1000 + _activeOrders.length + 1).toString(),
      items: List.from(_cart),
      total: calculatedTotal,
      status: 'sent',
      timestamp: DateTime.now(),
    );

    _activeOrders.add(newOrder);
    _cart.clear();
    notifyListeners();

    // Simulate order progression
    Future.delayed(const Duration(seconds: 5), () {
      updateOrderStatus(newOrder.id, 'preparing');
    });
    Future.delayed(const Duration(seconds: 15), () {
      updateOrderStatus(newOrder.id, 'ready');
    });
  }

  void updateOrderStatus(String orderId, String status) {
    final index = _activeOrders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _activeOrders[index] = Order(
        id: _activeOrders[index].id,
        items: _activeOrders[index].items,
        total: _activeOrders[index].total,
        status: status,
        timestamp: _activeOrders[index].timestamp,
      );
      notifyListeners();
    }
  }
}
