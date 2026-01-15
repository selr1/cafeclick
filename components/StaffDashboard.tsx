import { useState } from 'react';
import { Power, Edit, Trash2, QrCode, LogOut, Plus } from 'lucide-react';
import { User } from './Login';

export interface StallStatus {
  isOpen: boolean;
  mahallahId: string;
}

export interface MenuItemWithAvailability {
  id: string;
  name: string;
  price: number;
  category: string;
  isAvailable: boolean;
}

interface StaffDashboardProps {
  user: User;
  onLogout: () => void;
  onScanQR: () => void;
}

export default function StaffDashboard({ user, onLogout, onScanQR }: StaffDashboardProps) {
  const [stallStatus, setStallStatus] = useState<StallStatus>({
    isOpen: true,
    mahallahId: '1'
  });

  const [menuItems, setMenuItems] = useState<MenuItemWithAvailability[]>([
    { id: '1', name: 'Nasi Goreng USA', price: 5.50, category: 'rice', isAvailable: true },
    { id: '2', name: 'Chicken Rice', price: 6.00, category: 'rice', isAvailable: true },
    { id: '3', name: 'Mee Goreng', price: 5.00, category: 'noodles', isAvailable: true },
    { id: '4', name: 'Chicken Chop', price: 8.50, category: 'western', isAvailable: false },
    { id: '5', name: 'Carbonara Pasta', price: 9.00, category: 'western', isAvailable: true },
    { id: '6', name: 'Iced Milo', price: 2.50, category: 'drinks', isAvailable: true },
  ]);

  const [editingItem, setEditingItem] = useState<string | null>(null);
  const [editForm, setEditForm] = useState({ name: '', price: 0 });

  const toggleStallStatus = () => {
    setStallStatus(prev => ({ ...prev, isOpen: !prev.isOpen }));
  };

  const toggleItemAvailability = (id: string) => {
    setMenuItems(items =>
      items.map(item =>
        item.id === id ? { ...item, isAvailable: !item.isAvailable } : item
      )
    );
  };

  const startEditing = (item: MenuItemWithAvailability) => {
    setEditingItem(item.id);
    setEditForm({ name: item.name, price: item.price });
  };

  const saveEdit = (id: string) => {
    setMenuItems(items =>
      items.map(item =>
        item.id === id ? { ...item, name: editForm.name, price: editForm.price } : item
      )
    );
    setEditingItem(null);
  };

  const deleteItem = (id: string) => {
    if (confirm('Are you sure you want to delete this item?')) {
      setMenuItems(items => items.filter(item => item.id !== id));
    }
  };

  return (
    <div className="w-full min-h-screen bg-[#1C1B1F] pb-6 max-w-md mx-auto">
      {/* Header */}
      <div className="bg-[#2B2930] px-4 py-6 mb-4">
        <div className="flex items-center justify-between mb-2">
          <div>
            <h1 className="text-[#E6E1E5] mb-1">Staff Dashboard</h1>
            <p className="text-[#CAC4D0] text-sm">{user.name}</p>
          </div>
          <button
            onClick={onLogout}
            className="p-2 bg-[#4A4458] rounded-lg hover:bg-[#49454F] transition-colors"
          >
            <LogOut className="w-5 h-5 text-[#D0BCFF]" />
          </button>
        </div>
      </div>

      <div className="px-4 space-y-6">
        {/* Stall Status Toggle */}
        <div className="bg-[#2B2930] rounded-2xl p-6">
          <div className="flex items-center justify-between mb-4">
            <div className="flex items-center gap-3">
              <Power className={`w-6 h-6 ${stallStatus.isOpen ? 'text-[#A8DAB5]' : 'text-[#938F99]'}`} />
              <div>
                <h3 className="text-[#E6E1E5]">Stall Status</h3>
                <p className="text-sm text-[#CAC4D0]">
                  {stallStatus.isOpen ? 'Open for orders' : 'Closed'}
                </p>
              </div>
            </div>
            <button
              onClick={toggleStallStatus}
              className={`relative w-14 h-7 rounded-full transition-colors ${
                stallStatus.isOpen ? 'bg-[#D0BCFF]' : 'bg-[#49454F]'
              }`}
            >
              <div
                className={`absolute top-1 left-1 w-5 h-5 bg-white rounded-full transition-transform ${
                  stallStatus.isOpen ? 'translate-x-7' : ''
                }`}
              />
            </button>
          </div>
          {stallStatus.isOpen && (
            <div className="bg-[#1F3823] text-[#A8DAB5] px-3 py-2 rounded-lg text-sm">
              ✓ Accepting new orders
            </div>
          )}
        </div>

        {/* QR Scanner */}
        <button
          onClick={onScanQR}
          className="w-full bg-gradient-to-r from-[#6750A4] to-[#D0BCFF] text-white py-4 rounded-2xl hover:opacity-90 transition-opacity flex items-center justify-center gap-3"
        >
          <QrCode className="w-6 h-6" />
          <span>Scan Customer QR Code</span>
        </button>

        {/* Menu Management */}
        <div className="bg-[#2B2930] rounded-2xl p-4">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-[#E6E1E5]">Menu Management</h3>
            <button className="p-2 bg-[#4A4458] rounded-lg hover:bg-[#49454F] transition-colors">
              <Plus className="w-5 h-5 text-[#D0BCFF]" />
            </button>
          </div>

          <div className="space-y-2">
            {menuItems.map((item) => (
              <div
                key={item.id}
                className={`bg-[#211F26] rounded-xl p-3 ${
                  !item.isAvailable ? 'opacity-60' : ''
                }`}
              >
                {editingItem === item.id ? (
                  // Edit Mode
                  <div className="space-y-2">
                    <input
                      type="text"
                      value={editForm.name}
                      onChange={(e) => setEditForm({ ...editForm, name: e.target.value })}
                      className="w-full px-3 py-2 bg-[#2B2930] rounded-lg text-[#E6E1E5] border border-[#49454F] focus:outline-none focus:border-[#D0BCFF]"
                    />
                    <input
                      type="number"
                      value={editForm.price}
                      onChange={(e) => setEditForm({ ...editForm, price: parseFloat(e.target.value) })}
                      step="0.50"
                      className="w-full px-3 py-2 bg-[#2B2930] rounded-lg text-[#E6E1E5] border border-[#49454F] focus:outline-none focus:border-[#D0BCFF]"
                    />
                    <div className="flex gap-2">
                      <button
                        onClick={() => saveEdit(item.id)}
                        className="flex-1 bg-[#D0BCFF] text-[#381E72] py-2 rounded-lg hover:bg-[#E8DEF8] transition-colors"
                      >
                        Save
                      </button>
                      <button
                        onClick={() => setEditingItem(null)}
                        className="flex-1 bg-[#49454F] text-[#CAC4D0] py-2 rounded-lg hover:bg-[#36343B] transition-colors"
                      >
                        Cancel
                      </button>
                    </div>
                  </div>
                ) : (
                  // Display Mode
                  <div className="flex items-center justify-between">
                    <div className="flex-1">
                      <h4 className="text-[#E6E1E5] mb-1">{item.name}</h4>
                      <div className="flex items-center gap-2">
                        <p className="text-[#D0BCFF] text-sm">RM {item.price.toFixed(2)}</p>
                        <span className="text-[#938F99] text-xs">•</span>
                        <span className={`text-xs px-2 py-0.5 rounded-full ${
                          item.isAvailable 
                            ? 'bg-[#1F3823] text-[#A8DAB5]' 
                            : 'bg-[#601410] text-[#F2B8B5]'
                        }`}>
                          {item.isAvailable ? 'Available' : 'Out of Stock'}
                        </span>
                      </div>
                    </div>
                    <div className="flex items-center gap-2">
                      {/* Availability Toggle */}
                      <button
                        onClick={() => toggleItemAvailability(item.id)}
                        className={`px-3 py-1.5 rounded-lg text-xs transition-colors ${
                          item.isAvailable
                            ? 'bg-[#49454F] text-[#CAC4D0] hover:bg-[#601410]'
                            : 'bg-[#1F3823] text-[#A8DAB5] hover:bg-[#A8DAB5] hover:text-[#1F3823]'
                        }`}
                      >
                        {item.isAvailable ? 'Mark Out' : 'Mark In'}
                      </button>
                      {/* Edit Button */}
                      <button
                        onClick={() => startEditing(item)}
                        className="p-2 bg-[#4A4458] rounded-lg hover:bg-[#49454F] transition-colors"
                      >
                        <Edit className="w-4 h-4 text-[#D0BCFF]" />
                      </button>
                      {/* Delete Button */}
                      <button
                        onClick={() => deleteItem(item.id)}
                        className="p-2 bg-[#601410] rounded-lg hover:bg-[#8C1D18] transition-colors"
                      >
                        <Trash2 className="w-4 h-4 text-[#F2B8B5]" />
                      </button>
                    </div>
                  </div>
                )}
              </div>
            ))}
          </div>
        </div>

        {/* Recent Orders Summary */}
        <div className="bg-[#2B2930] rounded-2xl p-4">
          <h3 className="text-[#E6E1E5] mb-3">Today's Summary</h3>
          <div className="grid grid-cols-2 gap-3">
            <div className="bg-[#211F26] rounded-xl p-3">
              <p className="text-[#CAC4D0] text-sm mb-1">Total Orders</p>
              <p className="text-[#D0BCFF] text-2xl">24</p>
            </div>
            <div className="bg-[#211F26] rounded-xl p-3">
              <p className="text-[#CAC4D0] text-sm mb-1">Revenue</p>
              <p className="text-[#D0BCFF] text-2xl">RM 156</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
