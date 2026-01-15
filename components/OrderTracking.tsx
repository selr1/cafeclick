import { CheckCircle2, Clock, PackageCheck, MapPin, QrCode } from 'lucide-react';
import { Order, Mahallah } from '../App';
import { useState, useEffect } from 'react';
import { toast } from 'sonner';

interface OrderTrackingProps {
  order: Order;
  mahallah: Mahallah;
  onBackToHome: () => void;
  onPickupComplete?: () => void;
}

export default function OrderTracking({ order, mahallah, onBackToHome, onPickupComplete }: OrderTrackingProps) {
  const [isNearby, setIsNearby] = useState(false);
  const [showQR, setShowQR] = useState(false);
  const [qrCode, setQrCode] = useState('');
  const [distanceToMahallah, setDistanceToMahallah] = useState(0.8); // km
  const [hasNotified, setHasNotified] = useState(false);

  // Simulate geofencing - check if user is within 500m (0.5km)
  useEffect(() => {
    // Simulate distance changing over time
    const interval = setInterval(() => {
      setDistanceToMahallah(prev => {
        const newDistance = Math.max(0.05, prev - 0.1);
        const nearby = newDistance <= 0.5;
        
        // Show notification when entering geofence for first time
        if (nearby && !isNearby && !hasNotified && order.status === 'ready') {
          toast.success('You\'re near the cafe!', {
            description: 'Tap "I\'m Here" to generate your pickup QR code',
            duration: 5000,
          });
          setHasNotified(true);
        }
        
        setIsNearby(nearby);
        return newDistance;
      });
    }, 3000);

    return () => clearInterval(interval);
  }, [isNearby, hasNotified, order.status]);

  // Generate QR code when user says "I'm Here"
  const handleImHere = () => {
    const code = `PICKUP-${order.id}-${Date.now()}`;
    setQrCode(code);
    setShowQR(true);

    // Auto refresh QR every 60 seconds
    const refreshInterval = setInterval(() => {
      const newCode = `PICKUP-${order.id}-${Date.now()}`;
      setQrCode(newCode);
    }, 60000);

    return () => clearInterval(refreshInterval);
  };

  const getStatusStep = () => {
    switch (order.status) {
      case 'sent': return 1;
      case 'preparing': return 2;
      case 'ready': return 3;
      default: return 1;
    }
  };

  const currentStep = getStatusStep();

  // QR Code Display Modal
  if (showQR) {
    return (
      <div className="w-full min-h-screen bg-[#1C1B1F] px-4 py-6 max-w-md mx-auto flex flex-col items-center justify-center">
        <div className="bg-[#2B2930] rounded-3xl p-8 w-full">
          <div className="text-center mb-6">
            <h2 className="text-[#E6E1E5] mb-2">Show QR to Staff</h2>
            <p className="text-[#CAC4D0] text-sm">Order #{order.id}</p>
          </div>

          {/* QR Code Display */}
          <div className="bg-white rounded-2xl p-8 mb-6 flex items-center justify-center">
            <QrCode className="w-48 h-48 text-[#1C1B1F]" />
          </div>

          {/* QR Code Text */}
          <div className="bg-[#211F26] rounded-xl p-4 mb-4">
            <p className="text-[#938F99] text-xs text-center mb-1">Verification Code</p>
            <p className="text-[#D0BCFF] text-center font-mono break-all">{qrCode}</p>
          </div>

          {/* Auto-refresh notice */}
          <div className="text-center mb-6">
            <p className="text-[#CAC4D0] text-xs">Code refreshes every 60 seconds</p>
          </div>

          {/* Pickup Complete Button */}
          <button
            onClick={() => {
              setShowQR(false);
              if (onPickupComplete) {
                onPickupComplete();
              }
            }}
            className="w-full bg-[#D0BCFF] text-[#381E72] py-4 rounded-full hover:bg-[#E8DEF8] transition-colors mb-3"
          >
            Order Collected
          </button>

          {/* Manual Code Entry */}
          <button
            onClick={() => setShowQR(false)}
            className="w-full text-[#CAC4D0] text-sm hover:text-[#E6E1E5] transition-colors"
          >
            Back to Order Details
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="w-full min-h-screen bg-[#1C1B1F] px-4 py-6 max-w-md mx-auto">
      {/* Header */}
      <div className="text-center mb-8">
        <div className="w-20 h-20 bg-[#4A4458] rounded-full flex items-center justify-center mx-auto mb-4">
          {order.status === 'ready' ? (
            <PackageCheck className="w-10 h-10 text-[#D0BCFF]" />
          ) : (
            <Clock className="w-10 h-10 text-[#D0BCFF]" />
          )}
        </div>
        <h1 className="text-[#E6E1E5] mb-2">
          {order.status === 'ready' ? 'Order Ready!' : 'Preparing Your Order'}
        </h1>
        <p className="text-[#CAC4D0]">Order #{order.id}</p>
      </div>

      {/* Geofencing Proximity Alert */}
      {order.status === 'ready' && (
        <div className={`rounded-2xl p-4 mb-6 ${
          isNearby 
            ? 'bg-[#1F3823] border-2 border-[#A8DAB5]' 
            : 'bg-[#2B2930]'
        }`}>
          <div className="flex items-center gap-3 mb-3">
            <MapPin className={`w-5 h-5 ${isNearby ? 'text-[#A8DAB5]' : 'text-[#CAC4D0]'}`} />
            <div className="flex-1">
              <h4 className={`text-sm ${isNearby ? 'text-[#A8DAB5]' : 'text-[#E6E1E5]'}`}>
                {isNearby ? '📍 You\'re near the cafe!' : '📍 Distance to cafe'}
              </h4>
              <p className="text-xs text-[#CAC4D0]">
                {distanceToMahallah.toFixed(2)} km away
              </p>
            </div>
          </div>
          
          {isNearby ? (
            <>
              <div className="bg-[#A8DAB5] text-[#1F3823] px-3 py-2 rounded-lg text-sm mb-3 text-center animate-pulse">
                ✓ Within pickup range
              </div>
              <button
                onClick={handleImHere}
                className="w-full bg-[#D0BCFF] text-[#381E72] py-3 rounded-full hover:bg-[#E8DEF8] transition-colors flex items-center justify-center gap-2"
              >
                <QrCode className="w-5 h-5" />
                <span>I'm Here - Show QR Code</span>
              </button>
            </>
          ) : (
            <div className="bg-[#211F26] text-[#938F99] px-3 py-2 rounded-lg text-xs text-center">
              Get within 500m to enable pickup
            </div>
          )}
        </div>
      )}

      {/* Order Status Progress */}
      <div className="bg-[#2B2930] rounded-2xl p-6 mb-6">
        <div className="space-y-6">
          {/* Step 1: Order Sent */}
          <div className="flex items-start gap-4">
            <div className="flex flex-col items-center">
              <div className={`w-10 h-10 rounded-full flex items-center justify-center ${
                currentStep >= 1 ? 'bg-[#D0BCFF]' : 'bg-[#49454F]'
              }`}>
                <CheckCircle2 className={`w-6 h-6 ${
                  currentStep >= 1 ? 'text-[#381E72]' : 'text-[#938F99]'
                }`} />
              </div>
              {currentStep >= 1 && (
                <div className={`w-0.5 h-12 mt-2 ${
                  currentStep >= 2 ? 'bg-[#D0BCFF]' : 'bg-[#49454F]'
                }`} />
              )}
            </div>
            <div className="flex-1 pt-2">
              <h4 className={`mb-1 ${
                currentStep >= 1 ? 'text-[#E6E1E5]' : 'text-[#938F99]'
              }`}>Order Sent</h4>
              <p className="text-sm text-[#CAC4D0]">
                {currentStep >= 1 ? 'Your order has been received' : 'Waiting...'}
              </p>
            </div>
          </div>

          {/* Step 2: Preparing */}
          <div className="flex items-start gap-4">
            <div className="flex flex-col items-center">
              <div className={`w-10 h-10 rounded-full flex items-center justify-center relative ${
                currentStep >= 2 ? 'bg-[#D0BCFF]' : 'bg-[#49454F]'
              }`}>
                {currentStep === 2 ? (
                  <>
                    <Clock className="w-6 h-6 text-[#381E72] animate-pulse" />
                    <div className="absolute inset-0 rounded-full border-2 border-[#D0BCFF] animate-ping" />
                  </>
                ) : (
                  <CheckCircle2 className={`w-6 h-6 ${
                    currentStep >= 2 ? 'text-[#381E72]' : 'text-[#938F99]'
                  }`} />
                )}
              </div>
              {currentStep >= 2 && (
                <div className={`w-0.5 h-12 mt-2 ${
                  currentStep >= 3 ? 'bg-[#D0BCFF]' : 'bg-[#49454F]'
                }`} />
              )}
            </div>
            <div className="flex-1 pt-2">
              <h4 className={`mb-1 ${
                currentStep >= 2 ? 'text-[#E6E1E5]' : 'text-[#938F99]'
              }`}>Preparing</h4>
              <p className="text-sm text-[#CAC4D0]">
                {currentStep >= 2 ? 'The cafe is preparing your food' : 'Not started yet'}
              </p>
              {currentStep === 2 && (
                <div className="mt-2 text-sm text-[#D0BCFF]">
                  Estimated time: 10-15 minutes
                </div>
              )}
            </div>
          </div>

          {/* Step 3: Ready for Pickup */}
          <div className="flex items-start gap-4">
            <div className="flex flex-col items-center">
              <div className={`w-10 h-10 rounded-full flex items-center justify-center ${
                currentStep >= 3 ? 'bg-[#D0BCFF]' : 'bg-[#49454F]'
              }`}>
                <PackageCheck className={`w-6 h-6 ${
                  currentStep >= 3 ? 'text-[#381E72]' : 'text-[#938F99]'
                }`} />
              </div>
            </div>
            <div className="flex-1 pt-2">
              <h4 className={`mb-1 ${
                currentStep >= 3 ? 'text-[#E6E1E5]' : 'text-[#938F99]'
              }`}>Ready for Pickup</h4>
              <p className="text-sm text-[#CAC4D0]">
                {currentStep >= 3 ? 'Your order is ready to collect!' : 'Almost there...'}
              </p>
            </div>
          </div>
        </div>
      </div>

      {/* Pickup Location */}
      <div className="bg-[#2B2930] rounded-2xl p-4 mb-6">
        <h4 className="text-[#E6E1E5] mb-3">Pickup Location</h4>
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 bg-[#4A4458] rounded-full flex items-center justify-center">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none">
              <path d="M12 2C8.13 2 5 5.13 5 9C5 14.25 12 22 12 22C12 22 19 14.25 19 9C19 5.13 15.87 2 12 2ZM12 11.5C10.62 11.5 9.5 10.38 9.5 9C9.5 7.62 10.62 6.5 12 6.5C13.38 6.5 14.5 7.62 14.5 9C14.5 10.38 13.38 11.5 12 11.5Z" fill="#D0BCFF"/>
            </svg>
          </div>
          <div>
            <p className="text-[#E6E1E5]">{mahallah.name}</p>
            <p className="text-sm text-[#CAC4D0]">Cafeteria Counter</p>
          </div>
        </div>
      </div>

      {/* Order Summary */}
      <div className="bg-[#2B2930] rounded-2xl p-4 mb-6">
        <h4 className="text-[#E6E1E5] mb-3">Order Summary</h4>
        <div className="space-y-2">
          {order.items.map((item, index) => (
            <div key={index} className="flex justify-between text-sm">
              <span className="text-[#CAC4D0]">
                {item.quantity}x {item.name}
              </span>
              <span className="text-[#E6E1E5]">
                RM {(item.price + (item.customizations?.addEgg ? 1.00 : 0)) * item.quantity}
              </span>
            </div>
          ))}
          <div className="border-t border-[#49454F] pt-2 mt-2 flex justify-between">
            <span className="text-[#E6E1E5]">Total</span>
            <span className="text-[#D0BCFF]">RM {order.total.toFixed(2)}</span>
          </div>
        </div>
      </div>

      {/* Action Button */}
      {order.status === 'ready' ? (
        <div className="space-y-3">
          {!isNearby && (
            <div className="text-center bg-[#2B2930] rounded-xl p-4">
              <p className="text-sm text-[#CAC4D0] mb-2">
                Head to the cafe to collect your order
              </p>
              <p className="text-xs text-[#938F99]">
                QR code will be available when you arrive
              </p>
            </div>
          )}
          <button
            onClick={onBackToHome}
            className="w-full bg-[#49454F] text-[#CAC4D0] py-4 rounded-full hover:bg-[#36343B] transition-colors"
          >
            Back to Home
          </button>
        </div>
      ) : (
        <div className="text-center">
          <p className="text-sm text-[#CAC4D0]">
            We'll notify you when your order is ready
          </p>
        </div>
      )}
    </div>
  );
}