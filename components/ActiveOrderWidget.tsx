import { Clock, PackageCheck } from 'lucide-react';
import { Order } from '../App';

interface ActiveOrderWidgetProps {
  order: Order;
  onClick: () => void;
}

export default function ActiveOrderWidget({ order, onClick }: ActiveOrderWidgetProps) {
  const getStatusText = () => {
    switch (order.status) {
      case 'sent': return 'Order Sent...';
      case 'preparing': return 'Order is Preparing...';
      case 'ready': return 'Order Ready for Pickup!';
      default: return 'Processing...';
    }
  };

  return (
    <button
      onClick={onClick}
      className="fixed bottom-20 left-4 right-4 bg-[#E8DEF8] text-[#381E72] rounded-full py-4 px-6 flex items-center gap-3 shadow-lg hover:bg-[#D0BCFF] transition-colors max-w-md mx-auto z-20 animate-slide-up"
    >
      {order.status === 'ready' ? (
        <PackageCheck className="w-5 h-5 flex-shrink-0 animate-bounce" />
      ) : (
        <Clock className="w-5 h-5 flex-shrink-0 animate-pulse" />
      )}
      <div className="flex-1 text-left">
        <p className="text-sm">Order #{order.id}</p>
        <p className="text-xs text-[#381E72]/80">{getStatusText()}</p>
      </div>
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" className="flex-shrink-0">
        <path d="M9 6L15 12L9 18" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
      </svg>
    </button>
  );
}