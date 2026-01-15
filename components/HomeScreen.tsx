import { ChevronDown, Home, FileText, ShoppingBag, User, LogOut } from 'lucide-react';
import { Mahallah, MenuItem } from '../App';
import { ImageWithFallback } from './figma/ImageWithFallback';
import { useState } from 'react';

interface HomeScreenProps {
  mahallah: Mahallah;
  onSwitchMahallah: () => void;
  onSelectMenuItem: (item: MenuItem) => void;
  onViewCart: () => void;
  cartItemCount: number;
  currentTab: 'home' | 'menu' | 'orders' | 'profile';
  onTabChange: (tab: 'home' | 'menu' | 'orders' | 'profile') => void;
  onLogout?: () => void;
}

const menuItems: MenuItem[] = [
  {
    id: '1',
    name: 'Nasi Goreng USA',
    price: 5.50,
    category: 'rice',
    image: '/assets/images/nasigorengusa.jpg',
    popular: true
  },
  {
    id: '2',
    name: 'Chicken Rice',
    price: 6.00,
    category: 'rice',
    image: '/assets/images/chickenrice.jpg',
    popular: true
  },
  {
    id: '3',
    name: 'Mee Goreng',
    price: 5.00,
    category: 'noodles',
    image: '/assets/images/meegoreng.jpg',
    popular: true
  },
  {
    id: '4',
    name: 'Chicken Chop',
    price: 8.50,
    category: 'western',
    image: '/assets/images/chickenchop.jpg',
  },
  {
    id: '5',
    name: 'Carbonara Pasta',
    price: 9.00,
    category: 'western',
    image: '/assets/images/carbonarapasta.jpg',
  },
  {
    id: '6',
    name: 'Juice',
    price: 2.50,
    category: 'drinks',
    image: '/assets/images/juice.jpg',
  },
];

export default function HomeScreen({
  mahallah,
  onSwitchMahallah,
  onSelectMenuItem,
  onViewCart,
  cartItemCount,
  currentTab,
  onTabChange,
  onLogout
}: HomeScreenProps) {
  const [showLogoutConfirm, setShowLogoutConfirm] = useState(false);

  const categories = [
    { id: 'rice', label: 'Rice', emoji: '🍚' },
    { id: 'noodles', label: 'Noodles', emoji: '🍜' },
    { id: 'western', label: 'Western', emoji: '🍔' },
    { id: 'drinks', label: 'Drinks', emoji: '🥤' },
  ];

  const handleLogoutClick = () => {
    if (onLogout) {
      onLogout();
    }
  };

  // Profile Tab Content
  if (currentTab === 'profile') {
    return (
      <div className="w-full min-h-screen bg-[#1C1B1F] pb-24 max-w-md mx-auto">
        {/* Header */}
        <div className="sticky top-0 bg-[#1C1B1F] z-10 px-4 py-4 border-b border-[#36343B]">
          <h2 className="text-[#E6E1E5]">Profile</h2>
        </div>

        <div className="px-4 py-6 space-y-4">
          {/* User Info */}
          <div className="bg-[#2B2930] rounded-2xl p-6">
            <div className="flex items-center gap-4 mb-4">
              <div className="w-16 h-16 bg-[#4A4458] rounded-full flex items-center justify-center">
                <User className="w-8 h-8 text-[#D0BCFF]" />
              </div>
              <div>
                <h3 className="text-[#E6E1E5] mb-1">Ahmad Student</h3>
                <p className="text-[#CAC4D0] text-sm">student@iium.edu.my</p>
              </div>
            </div>
          </div>

          {/* Preferences */}
          <div className="bg-[#2B2930] rounded-2xl p-4">
            <h3 className="text-[#E6E1E5] mb-3">Preferences</h3>
            <div className="space-y-2">
              <button className="w-full text-left px-4 py-3 bg-[#211F26] rounded-xl text-[#CAC4D0] hover:bg-[#36343B] transition-colors">
                Order History
              </button>
              <button className="w-full text-left px-4 py-3 bg-[#211F26] rounded-xl text-[#CAC4D0] hover:bg-[#36343B] transition-colors">
                Saved Addresses
              </button>
              <button className="w-full text-left px-4 py-3 bg-[#211F26] rounded-xl text-[#CAC4D0] hover:bg-[#36343B] transition-colors">
                Payment Methods
              </button>
            </div>
          </div>

          {/* Logout Button */}
          {onLogout && (
            <button
              onClick={handleLogoutClick}
              className="w-full bg-[#601410] text-[#F2B8B5] py-4 rounded-2xl hover:bg-[#8C1D18] transition-colors flex items-center justify-center gap-2"
            >
              <LogOut className="w-5 h-5" />
              <span>Logout</span>
            </button>
          )}
        </div>

        {/* Bottom Navigation */}
        <div className="fixed bottom-0 left-0 right-0 bg-[#211F26] border-t border-[#36343B] px-4 py-2 max-w-md mx-auto">
          <div className="flex items-center justify-around">
            <button
              onClick={() => onTabChange('home')}
              className={`flex flex-col items-center gap-1 px-4 py-2 rounded-full transition-colors ${currentTab === 'home' ? 'bg-[#4A4458]' : ''
                }`}
            >
              <Home className={`w-6 h-6 ${currentTab === 'home' ? 'fill-[#D0BCFF] text-[#D0BCFF]' : 'text-[#CAC4D0]'}`} />
              <span className={`text-xs ${currentTab === 'home' ? 'text-[#D0BCFF]' : 'text-[#CAC4D0]'}`}>Home</span>
            </button>

            <button
              onClick={() => onTabChange('menu')}
              className={`flex flex-col items-center gap-1 px-4 py-2 rounded-full transition-colors ${currentTab === 'menu' ? 'bg-[#4A4458]' : ''
                }`}
            >
              <FileText className={`w-6 h-6 ${currentTab === 'menu' ? 'text-[#D0BCFF]' : 'text-[#CAC4D0]'}`} />
              <span className={`text-xs ${currentTab === 'menu' ? 'text-[#D0BCFF]' : 'text-[#CAC4D0]'}`}>Menu</span>
            </button>

            <button
              onClick={onViewCart}
              className="relative flex flex-col items-center gap-1 px-4 py-2 rounded-full transition-colors"
            >
              <ShoppingBag className="w-6 h-6 text-[#CAC4D0]" />
              {cartItemCount > 0 && (
                <div className="absolute top-1 right-2 w-5 h-5 bg-[#F2B8B5] rounded-full flex items-center justify-center">
                  <span className="text-xs text-[#601410]">{cartItemCount}</span>
                </div>
              )}
              <span className="text-xs text-[#CAC4D0]">Cart</span>
            </button>

            <button
              onClick={() => onTabChange('profile')}
              className={`flex flex-col items-center gap-1 px-4 py-2 rounded-full transition-colors ${currentTab === 'profile' ? 'bg-[#4A4458]' : ''
                }`}
            >
              <User className={`w-6 h-6 ${currentTab === 'profile' ? 'text-[#D0BCFF]' : 'text-[#CAC4D0]'}`} />
              <span className={`text-xs ${currentTab === 'profile' ? 'text-[#D0BCFF]' : 'text-[#CAC4D0]'}`}>Profile</span>
            </button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="w-full min-h-screen bg-[#1C1B1F] pb-24 max-w-md mx-auto">
      {/* Header with Location Switcher */}
      <div className="sticky top-0 bg-[#1C1B1F] z-10 px-4 py-4 border-b border-[#36343B]">
        <button
          onClick={onSwitchMahallah}
          className="flex items-center gap-2 text-[#D0BCFF] hover:bg-[#2B2930] px-3 py-2 rounded-lg transition-colors"
        >
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none">
            <path d="M12 2C8.13 2 5 5.13 5 9C5 14.25 12 22 12 22C12 22 19 14.25 19 9C19 5.13 15.87 2 12 2ZM12 11.5C10.62 11.5 9.5 10.38 9.5 9C9.5 7.62 10.62 6.5 12 6.5C13.38 6.5 14.5 7.62 14.5 9C14.5 10.38 13.38 11.5 12 11.5Z" fill="currentColor" />
          </svg>
          <span className="text-[#D0BCFF]">{mahallah.name}</span>
          <ChevronDown className="w-4 h-4" />
        </button>
      </div>

      {/* Content */}
      <div className="px-4 py-4">
        {/* Welcome Banner */}
        <div className="bg-gradient-to-r from-[#4F378B] to-[#6750A4] rounded-3xl p-6 mb-6 text-white">
          <h2 className="mb-2">Welcome to {mahallah.name.replace('Mahallah ', '')} Cafe</h2>
          <p className="text-sm text-white/90">Today's Special: Nasi Goreng USA with Free Egg!</p>
        </div>

        {/* Quick Filters */}
        <div className="mb-6">
          <h3 className="text-[#E6E1E5] mb-3">Categories</h3>
          <div className="grid grid-cols-4 gap-2">
            {categories.map((category) => (
              <button
                key={category.id}
                className="flex flex-col items-center gap-2 p-3 bg-[#2B2930] rounded-2xl hover:bg-[#4A4458] transition-colors"
              >
                <span className="text-2xl">{category.emoji}</span>
                <span className="text-xs text-[#E6E1E5]">{category.label}</span>
              </button>
            ))}
          </div>
        </div>

        {/* Popular Now */}
        <div className="mb-6">
          <h3 className="text-[#E6E1E5] mb-3">Popular Now</h3>
          <div className="space-y-3">
            {menuItems.filter(item => item.popular).map((item) => (
              <button
                key={item.id}
                onClick={() => onSelectMenuItem(item)}
                className="w-full bg-[#2B2930] rounded-2xl p-3 flex items-center gap-3 hover:bg-[#36343B] transition-all"
              >
                <ImageWithFallback
                  src={item.image}
                  alt={item.name}
                  className="w-20 h-20 rounded-xl object-cover"
                />
                <div className="flex-1 text-left">
                  <h4 className="text-[#E6E1E5] mb-1">{item.name}</h4>
                  <p className="text-[#D0BCFF]">RM {item.price.toFixed(2)}</p>
                </div>
                <div className="text-[#938F99]">
                  <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                    <path d="M9 6L15 12L9 18" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" />
                  </svg>
                </div>
              </button>
            ))}
          </div>
        </div>

        {/* All Menu Items */}
        <div>
          <h3 className="text-[#E6E1E5] mb-3">All Menu</h3>
          <div className="grid grid-cols-2 gap-3">
            {menuItems.map((item) => (
              <button
                key={item.id}
                onClick={() => onSelectMenuItem(item)}
                className="bg-[#2B2930] rounded-2xl overflow-hidden hover:bg-[#36343B] transition-all"
              >
                <ImageWithFallback
                  src={item.image}
                  alt={item.name}
                  className="w-full h-32 object-cover"
                />
                <div className="p-3">
                  <h4 className="text-[#E6E1E5] text-sm mb-1">{item.name}</h4>
                  <p className="text-[#D0BCFF] text-sm">RM {item.price.toFixed(2)}</p>
                </div>
              </button>
            ))}
          </div>
        </div>
      </div>

      {/* Bottom Navigation */}
      <div className="fixed bottom-0 left-0 right-0 bg-[#211F26] border-t border-[#36343B] px-4 py-2 max-w-md mx-auto">
        <div className="flex items-center justify-around">
          <button
            onClick={() => onTabChange('home')}
            className={`flex flex-col items-center gap-1 px-4 py-2 rounded-full transition-colors ${currentTab === 'home' ? 'bg-[#4A4458]' : ''
              }`}
          >
            <Home className={`w-6 h-6 ${currentTab === 'home' ? 'fill-[#D0BCFF] text-[#D0BCFF]' : 'text-[#CAC4D0]'}`} />
            <span className={`text-xs ${currentTab === 'home' ? 'text-[#D0BCFF]' : 'text-[#CAC4D0]'}`}>Home</span>
          </button>

          <button
            onClick={() => onTabChange('menu')}
            className={`flex flex-col items-center gap-1 px-4 py-2 rounded-full transition-colors ${currentTab === 'menu' ? 'bg-[#4A4458]' : ''
              }`}
          >
            <FileText className={`w-6 h-6 ${currentTab === 'menu' ? 'text-[#D0BCFF]' : 'text-[#CAC4D0]'}`} />
            <span className={`text-xs ${currentTab === 'menu' ? 'text-[#D0BCFF]' : 'text-[#CAC4D0]'}`}>Menu</span>
          </button>

          <button
            onClick={onViewCart}
            className="relative flex flex-col items-center gap-1 px-4 py-2 rounded-full transition-colors"
          >
            <ShoppingBag className="w-6 h-6 text-[#CAC4D0]" />
            {cartItemCount > 0 && (
              <div className="absolute top-1 right-2 w-5 h-5 bg-[#F2B8B5] rounded-full flex items-center justify-center">
                <span className="text-xs text-[#601410]">{cartItemCount}</span>
              </div>
            )}
            <span className="text-xs text-[#CAC4D0]">Cart</span>
          </button>

          <button
            onClick={() => onTabChange('profile')}
            className={`flex flex-col items-center gap-1 px-4 py-2 rounded-full transition-colors ${currentTab === 'profile' ? 'bg-[#4A4458]' : ''
              }`}
          >
            <User className={`w-6 h-6 ${currentTab === 'profile' ? 'text-[#D0BCFF]' : 'text-[#CAC4D0]'}`} />
            <span className={`text-xs ${currentTab === 'profile' ? 'text-[#D0BCFF]' : 'text-[#CAC4D0]'}`}>Profile</span>
          </button>
        </div>
      </div>
    </div>
  );
}