import { useState } from 'react';
import { X, Plus, Minus } from 'lucide-react';
import { MenuItem, CartItem } from '../App';
import { ImageWithFallback } from './figma/ImageWithFallback';

interface MenuCustomizationProps {
  item: MenuItem;
  onAddToCart: (item: CartItem) => void;
  onClose: () => void;
}

export default function MenuCustomization({ item, onAddToCart, onClose }: MenuCustomizationProps) {
  const [quantity, setQuantity] = useState(1);
  const [addEgg, setAddEgg] = useState(false);
  const [spicyLevel, setSpicyLevel] = useState<'mild' | 'medium' | 'hot'>('mild');

  const calculateTotal = () => {
    let total = item.price * quantity;
    if (addEgg) total += 1.00 * quantity;
    return total;
  };

  const handleAddToCart = () => {
    const cartItem: CartItem = {
      ...item,
      quantity,
      customizations: {
        addEgg,
        spicyLevel
      }
    };
    onAddToCart(cartItem);
  };

  return (
    <div className="fixed inset-0 bg-black/70 z-50 flex items-end justify-center max-w-md mx-auto">
      <div className="bg-[#1C1B1F] rounded-t-3xl w-full max-h-[90vh] overflow-y-auto animate-slide-up">
        {/* Header */}
        <div className="sticky top-0 bg-[#1C1B1F] z-10 px-6 py-4 border-b border-[#36343B] flex items-center justify-between">
          <h3 className="text-[#E6E1E5]">Customize Order</h3>
          <button
            onClick={onClose}
            className="w-8 h-8 rounded-full hover:bg-[#2B2930] flex items-center justify-center"
          >
            <X className="w-5 h-5 text-[#CAC4D0]" />
          </button>
        </div>

        {/* Content */}
        <div className="px-6 py-6">
          {/* Item Image */}
          <ImageWithFallback
            src={item.image}
            alt={item.name}
            className="w-full h-48 rounded-2xl object-cover mb-6"
          />

          {/* Item Info */}
          <div className="mb-6">
            <h2 className="text-[#E6E1E5] mb-2">{item.name}</h2>
            <p className="text-[#D0BCFF]">RM {item.price.toFixed(2)}</p>
          </div>

          {/* Quantity */}
          <div className="mb-6">
            <h4 className="text-[#E6E1E5] mb-3">Quantity</h4>
            <div className="flex items-center gap-4">
              <button
                onClick={() => setQuantity(Math.max(1, quantity - 1))}
                disabled={quantity <= 1}
                className="w-10 h-10 rounded-full bg-[#4A4458] flex items-center justify-center disabled:opacity-50 disabled:cursor-not-allowed"
              >
                <Minus className="w-5 h-5 text-[#D0BCFF]" />
              </button>
              <span className="text-[#E6E1E5] min-w-[40px] text-center">{quantity}</span>
              <button
                onClick={() => setQuantity(quantity + 1)}
                className="w-10 h-10 rounded-full bg-[#4A4458] flex items-center justify-center"
              >
                <Plus className="w-5 h-5 text-[#D0BCFF]" />
              </button>
            </div>
          </div>

          {/* Add-ons */}
          {item.category !== 'drinks' && (
            <div className="mb-6">
              <h4 className="text-[#E6E1E5] mb-3">Add-ons</h4>
              <button
                onClick={() => setAddEgg(!addEgg)}
                className={`w-full flex items-center justify-between p-4 rounded-xl border-2 transition-colors ${
                  addEgg
                    ? 'border-[#D0BCFF] bg-[#2B2930]'
                    : 'border-[#49454F] bg-[#1C1B1F]'
                }`}
              >
                <div className="flex items-center gap-3">
                  <div className={`w-5 h-5 rounded-full border-2 flex items-center justify-center ${
                    addEgg ? 'border-[#D0BCFF] bg-[#D0BCFF]' : 'border-[#938F99]'
                  }`}>
                    {addEgg && (
                      <svg width="12" height="12" viewBox="0 0 12 12" fill="none">
                        <path d="M2 6L5 9L10 3" stroke="#381E72" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                      </svg>
                    )}
                  </div>
                  <span className="text-[#E6E1E5]">Add Egg</span>
                </div>
                <span className="text-[#D0BCFF]">+RM 1.00</span>
              </button>
            </div>
          )}

          {/* Spicy Level */}
          {(item.category === 'rice' || item.category === 'noodles') && (
            <div className="mb-6">
              <h4 className="text-[#E6E1E5] mb-3">Spicy Level</h4>
              <div className="grid grid-cols-3 gap-2">
                {['mild', 'medium', 'hot'].map((level) => (
                  <button
                    key={level}
                    onClick={() => setSpicyLevel(level as 'mild' | 'medium' | 'hot')}
                    className={`py-3 px-4 rounded-xl border-2 transition-colors ${
                      spicyLevel === level
                        ? 'border-[#D0BCFF] bg-[#2B2930] text-[#D0BCFF]'
                        : 'border-[#49454F] bg-[#1C1B1F] text-[#938F99]'
                    }`}
                  >
                    {level === 'mild' && '🌶️ Mild'}
                    {level === 'medium' && '🌶️🌶️ Medium'}
                    {level === 'hot' && '🌶️🌶️🌶️ Hot'}
                  </button>
                ))}
              </div>
            </div>
          )}
        </div>

        {/* Sticky Add to Basket Button */}
        <div className="sticky bottom-0 bg-[#1C1B1F] border-t border-[#36343B] px-6 py-4">
          <button
            onClick={handleAddToCart}
            className="w-full bg-[#D0BCFF] text-[#381E72] py-4 rounded-full hover:bg-[#E8DEF8] transition-colors"
          >
            Add to Basket - RM {calculateTotal().toFixed(2)}
          </button>
        </div>
      </div>
    </div>
  );
}