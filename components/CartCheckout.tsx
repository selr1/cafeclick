import { useState } from 'react';
import { ArrowLeft, MapPin, CreditCard, Smartphone } from 'lucide-react';
import { Mahallah, CartItem } from '../App';
import { ImageWithFallback } from './figma/ImageWithFallback';

interface CartCheckoutProps {
  mahallah: Mahallah;
  cart: CartItem[];
  onBack: () => void;
  onPlaceOrder: () => void;
}

export default function CartCheckout({ mahallah, cart, onBack, onPlaceOrder }: CartCheckoutProps) {
  const [paymentMethod, setPaymentMethod] = useState<'online' | 'cash'>('online');

  const calculateSubtotal = () => {
    return cart.reduce((sum, item) => {
      let itemTotal = item.price * item.quantity;
      if (item.customizations?.addEgg) itemTotal += 1.00 * item.quantity;
      return sum + itemTotal;
    }, 0);
  };

  const subtotal = calculateSubtotal();
  const serviceFee = 0.50;
  const total = subtotal + serviceFee;

  return (
    <div className="w-full min-h-screen bg-[#1C1B1F] max-w-md mx-auto">
      {/* Header */}
      <div className="sticky top-0 bg-[#1C1B1F] z-10 px-4 py-4 border-b border-[#36343B] flex items-center gap-4">
        <button
          onClick={onBack}
          className="w-10 h-10 rounded-full hover:bg-[#2B2930] flex items-center justify-center"
        >
          <ArrowLeft className="w-5 h-5 text-[#CAC4D0]" />
        </button>
        <h2 className="text-[#E6E1E5]">Cart & Checkout</h2>
      </div>

      {/* Content */}
      <div className="px-4 py-4 pb-32">
        {/* Location Alert */}
        <div className="bg-[#4A4458] rounded-2xl p-4 mb-6 flex items-start gap-3">
          <MapPin className="w-5 h-5 text-[#D0BCFF] flex-shrink-0 mt-0.5" />
          <div>
            <h4 className="text-[#D0BCFF] mb-1">Picking up from:</h4>
            <p className="text-[#EADDFF]">{mahallah.name}</p>
          </div>
        </div>

        {/* Cart Items */}
        <div className="mb-6">
          <h3 className="text-[#E6E1E5] mb-3">Order Items</h3>
          <div className="space-y-3">
            {cart.map((item, index) => (
              <div key={index} className="bg-[#2B2930] rounded-2xl p-4 flex gap-3">
                <ImageWithFallback
                  src={item.image}
                  alt={item.name}
                  className="w-20 h-20 rounded-xl object-cover"
                />
                <div className="flex-1">
                  <h4 className="text-[#E6E1E5] mb-1">{item.name}</h4>
                  <div className="text-xs text-[#CAC4D0] mb-2">
                    {item.customizations?.addEgg && <span>• Add Egg</span>}
                    {item.customizations?.spicyLevel && (
                      <span className="ml-2">• {item.customizations.spicyLevel} spicy</span>
                    )}
                  </div>
                  <div className="flex items-center justify-between">
                    <span className="text-[#938F99] text-sm">Qty: {item.quantity}</span>
                    <span className="text-[#D0BCFF]">
                      RM {(item.price + (item.customizations?.addEgg ? 1.00 : 0)) * item.quantity}
                    </span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Payment Method */}
        <div className="mb-6">
          <h3 className="text-[#E6E1E5] mb-3">Payment Method</h3>
          <div className="space-y-2">
            <button
              onClick={() => setPaymentMethod('online')}
              className={`w-full flex items-center gap-3 p-4 rounded-xl border-2 transition-colors ${
                paymentMethod === 'online'
                  ? 'border-[#D0BCFF] bg-[#2B2930]'
                  : 'border-[#49454F] bg-[#1C1B1F]'
              }`}
            >
              <div className={`w-5 h-5 rounded-full border-2 flex items-center justify-center ${
                paymentMethod === 'online' ? 'border-[#D0BCFF]' : 'border-[#938F99]'
              }`}>
                {paymentMethod === 'online' && (
                  <div className="w-3 h-3 rounded-full bg-[#D0BCFF]" />
                )}
              </div>
              <Smartphone className="w-5 h-5 text-[#CAC4D0]" />
              <span className="text-[#E6E1E5]">Online Banking / QR</span>
            </button>

            <button
              onClick={() => setPaymentMethod('cash')}
              className={`w-full flex items-center gap-3 p-4 rounded-xl border-2 transition-colors ${
                paymentMethod === 'cash'
                  ? 'border-[#D0BCFF] bg-[#2B2930]'
                  : 'border-[#49454F] bg-[#1C1B1F]'
              }`}
            >
              <div className={`w-5 h-5 rounded-full border-2 flex items-center justify-center ${
                paymentMethod === 'cash' ? 'border-[#D0BCFF]' : 'border-[#938F99]'
              }`}>
                {paymentMethod === 'cash' && (
                  <div className="w-3 h-3 rounded-full bg-[#D0BCFF]" />
                )}
              </div>
              <CreditCard className="w-5 h-5 text-[#CAC4D0]" />
              <span className="text-[#E6E1E5]">Cash on Pickup</span>
            </button>
          </div>
        </div>

        {/* Order Summary */}
        <div className="bg-[#2B2930] rounded-2xl p-4">
          <h3 className="text-[#E6E1E5] mb-3">Order Summary</h3>
          <div className="space-y-2 mb-4">
            <div className="flex justify-between text-[#CAC4D0]">
              <span>Subtotal</span>
              <span>RM {subtotal.toFixed(2)}</span>
            </div>
            <div className="flex justify-between text-[#CAC4D0]">
              <span>Service Fee</span>
              <span>RM {serviceFee.toFixed(2)}</span>
            </div>
          </div>
          <div className="border-t border-[#49454F] pt-3 flex justify-between">
            <span className="text-[#E6E1E5]">Total</span>
            <span className="text-[#D0BCFF]">RM {total.toFixed(2)}</span>
          </div>
        </div>
      </div>

      {/* Sticky Place Order Button */}
      <div className="fixed bottom-0 left-0 right-0 bg-[#211F26] border-t border-[#36343B] px-4 py-4 max-w-md mx-auto">
        <button
          onClick={onPlaceOrder}
          disabled={cart.length === 0}
          className="w-full bg-[#D0BCFF] text-[#381E72] py-4 rounded-full hover:bg-[#E8DEF8] transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
        >
          Place Order - RM {total.toFixed(2)}
        </button>
      </div>
    </div>
  );
}