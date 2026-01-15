import { useState } from 'react';
import LocationSelection from './components/LocationSelection';
import HomeScreen from './components/HomeScreen';
import MenuCustomization from './components/MenuCustomization';
import CartCheckout from './components/CartCheckout';
import OrderTracking from './components/OrderTracking';
import ActiveOrderWidget from './components/ActiveOrderWidget';
import Login, { User } from './components/Login';
import Registration from './components/Registration';
import StaffDashboard from './components/StaffDashboard';
import ReviewScreen from './components/ReviewScreen';
import QRScanner from './components/QRScanner';
import { Toaster } from 'sonner';

export interface Mahallah {
  id: string;
  name: string;
  status: 'open' | 'closed';
  queueLevel: 'low' | 'medium' | 'high';
}

export interface MenuItem {
  id: string;
  name: string;
  price: number;
  category: 'rice' | 'noodles' | 'western' | 'drinks';
  image: string;
  popular?: boolean;
}

export interface CartItem extends MenuItem {
  quantity: number;
  customizations?: {
    addEgg?: boolean;
    spicyLevel?: 'mild' | 'medium' | 'hot';
  };
}

export interface Order {
  id: string;
  mahallahId: string;
  items: CartItem[];
  total: number;
  status: 'sent' | 'preparing' | 'ready';
}

type CustomerScreen = 'location' | 'home' | 'menu' | 'cart' | 'tracking' | 'review';
type AuthScreen = 'login' | 'register';
type StaffScreen = 'dashboard' | 'scanner';

export default function App() {
  // Authentication State
  const [currentUser, setCurrentUser] = useState<User | null>(null);
  const [authScreen, setAuthScreen] = useState<AuthScreen>('login');
  
  // Customer State
  const [currentScreen, setCurrentScreen] = useState<CustomerScreen>('location');
  const [selectedMahallah, setSelectedMahallah] = useState<Mahallah | null>(null);
  const [selectedMenuItem, setSelectedMenuItem] = useState<MenuItem | null>(null);
  const [cart, setCart] = useState<CartItem[]>([]);
  const [activeOrder, setActiveOrder] = useState<Order | null>(null);
  const [homeTab, setHomeTab] = useState<'home' | 'menu' | 'orders' | 'profile'>('home');

  // Staff State
  const [staffScreen, setStaffScreen] = useState<StaffScreen>('dashboard');

  // Authentication Handlers
  const handleLogin = (user: User) => {
    setCurrentUser(user);
    if (user.role === 'customer') {
      setCurrentScreen('location');
    } else {
      setStaffScreen('dashboard');
    }
  };

  const handleLogout = () => {
    setCurrentUser(null);
    setAuthScreen('login');
    setCurrentScreen('location');
    setCart([]);
    setActiveOrder(null);
  };

  const handleRegister = () => {
    setAuthScreen('login');
  };

  // Customer Handlers
  const handleSelectMahallah = (mahallah: Mahallah) => {
    setSelectedMahallah(mahallah);
    setCurrentScreen('home');
    setHomeTab('home');
  };

  const handleSwitchMahallah = () => {
    setCurrentScreen('location');
  };

  const handleSelectMenuItem = (item: MenuItem) => {
    setSelectedMenuItem(item);
    setCurrentScreen('menu');
  };

  const handleAddToCart = (item: CartItem) => {
    setCart([...cart, item]);
    setCurrentScreen('home');
    setSelectedMenuItem(null);
  };

  const handleViewCart = () => {
    setCurrentScreen('cart');
  };

  const handlePlaceOrder = () => {
    if (selectedMahallah && cart.length > 0) {
      const total = cart.reduce((sum, item) => {
        let itemTotal = item.price * item.quantity;
        if (item.customizations?.addEgg) itemTotal += 1.00 * item.quantity;
        return sum + itemTotal;
      }, 0);

      const order: Order = {
        id: Math.floor(1000 + Math.random() * 9000).toString(),
        mahallahId: selectedMahallah.id,
        items: cart,
        total,
        status: 'sent'
      };

      setActiveOrder(order);
      setCart([]);
      setCurrentScreen('tracking');

      // Simulate order status updates
      setTimeout(() => {
        setActiveOrder(prev => prev ? { ...prev, status: 'preparing' } : null);
      }, 2000);

      setTimeout(() => {
        setActiveOrder(prev => prev ? { ...prev, status: 'ready' } : null);
      }, 8000);
    }
  };

  const handleNavigateHome = () => {
    setCurrentScreen('home');
    setHomeTab('home');
  };

  const handleNavigateOrders = () => {
    if (activeOrder) {
      setCurrentScreen('tracking');
    } else {
      setCurrentScreen('home');
      setHomeTab('orders');
    }
  };

  const handlePickupComplete = () => {
    // Move to review screen after pickup
    setCurrentScreen('review');
  };

  const handleReviewSubmit = () => {
    // Clear order and go back to home
    setActiveOrder(null);
    setCurrentScreen('home');
    setHomeTab('home');
  };

  // Staff Handlers
  const handleScanQR = () => {
    setStaffScreen('scanner');
  };

  const handleScanSuccess = (code: string) => {
    console.log('Scanned code:', code);
    // In real app, verify order and mark as collected
    setTimeout(() => {
      setStaffScreen('dashboard');
    }, 500);
  };

  // Not logged in - show auth screens
  if (!currentUser) {
    if (authScreen === 'login') {
      return (
        <Login 
          onLogin={handleLogin} 
          onNavigateToRegister={() => setAuthScreen('register')} 
        />
      );
    } else {
      return (
        <Registration 
          onRegister={handleRegister} 
          onBackToLogin={() => setAuthScreen('login')} 
        />
      );
    }
  }

  // Staff Dashboard
  if (currentUser.role === 'staff') {
    if (staffScreen === 'scanner') {
      return (
        <QRScanner
          onClose={() => setStaffScreen('dashboard')}
          onScanSuccess={handleScanSuccess}
        />
      );
    }
    
    return (
      <StaffDashboard
        user={currentUser}
        onLogout={handleLogout}
        onScanQR={handleScanQR}
      />
    );
  }

  // Customer Screens
  return (
    <div className="relative w-full min-h-screen bg-[#1C1B1F]">
      <Toaster theme="dark" position="top-center" />
      
      {currentScreen === 'location' && (
        <LocationSelection onSelectMahallah={handleSelectMahallah} />
      )}

      {currentScreen === 'home' && selectedMahallah && (
        <HomeScreen
          mahallah={selectedMahallah}
          onSwitchMahallah={handleSwitchMahallah}
          onSelectMenuItem={handleSelectMenuItem}
          onViewCart={handleViewCart}
          cartItemCount={cart.length}
          currentTab={homeTab}
          onTabChange={setHomeTab}
          onLogout={handleLogout}
        />
      )}

      {currentScreen === 'menu' && selectedMenuItem && (
        <MenuCustomization
          item={selectedMenuItem}
          onAddToCart={handleAddToCart}
          onClose={() => setCurrentScreen('home')}
        />
      )}

      {currentScreen === 'cart' && selectedMahallah && (
        <CartCheckout
          mahallah={selectedMahallah}
          cart={cart}
          onBack={() => setCurrentScreen('home')}
          onPlaceOrder={handlePlaceOrder}
        />
      )}

      {currentScreen === 'tracking' && activeOrder && selectedMahallah && (
        <OrderTracking
          order={activeOrder}
          mahallah={selectedMahallah}
          onBackToHome={handleNavigateHome}
          onPickupComplete={handlePickupComplete}
        />
      )}

      {currentScreen === 'review' && activeOrder && selectedMahallah && (
        <ReviewScreen
          order={activeOrder}
          mahallah={selectedMahallah}
          onSubmit={handleReviewSubmit}
        />
      )}

      {/* Active Order Floating Widget */}
      {activeOrder && currentScreen === 'home' && (
        <ActiveOrderWidget
          order={activeOrder}
          onClick={handleNavigateOrders}
        />
      )}
    </div>
  );
}