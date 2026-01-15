import { useState } from 'react';
import { Star, Send } from 'lucide-react';
import { Order, Mahallah } from '../App';

interface ReviewScreenProps {
  order: Order;
  mahallah: Mahallah;
  onSubmit: () => void;
}

export default function ReviewScreen({ order, mahallah, onSubmit }: ReviewScreenProps) {
  const [rating, setRating] = useState(0);
  const [hoveredRating, setHoveredRating] = useState(0);
  const [feedback, setFeedback] = useState('');
  const [submitted, setSubmitted] = useState(false);

  const handleSubmit = () => {
    if (rating === 0) {
      alert('Please select a rating before submitting');
      return;
    }

    // In a real app, this would save to database
    console.log('Review submitted:', { rating, feedback, orderId: order.id });
    setSubmitted(true);

    // Navigate back after showing success message
    setTimeout(() => {
      onSubmit();
    }, 2000);
  };

  if (submitted) {
    return (
      <div className="w-full min-h-screen bg-[#1C1B1F] px-4 py-8 flex flex-col items-center justify-center max-w-md mx-auto">
        <div className="text-center">
          <div className="w-20 h-20 bg-[#A8DAB5] rounded-full flex items-center justify-center mx-auto mb-4">
            <svg width="40" height="40" viewBox="0 0 24 24" fill="none">
              <path d="M9 12L11 14L15 10M21 12C21 16.971 16.971 21 12 21C7.029 21 3 16.971 3 12C3 7.029 7.029 3 12 3C16.971 3 21 7.029 21 12Z" stroke="#1F3823" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
            </svg>
          </div>
          <h2 className="text-[#E6E1E5] mb-2">Thank You!</h2>
          <p className="text-[#CAC4D0] text-sm">Your feedback helps us improve</p>
        </div>
      </div>
    );
  }

  return (
    <div className="w-full min-h-screen bg-[#1C1B1F] px-4 py-6 max-w-md mx-auto">
      {/* Header */}
      <div className="text-center mb-8">
        <div className="w-20 h-20 bg-[#4A4458] rounded-full flex items-center justify-center mx-auto mb-4">
          <Star className="w-10 h-10 text-[#D0BCFF]" />
        </div>
        <h1 className="text-[#E6E1E5] mb-2">How was your experience?</h1>
        <p className="text-[#CAC4D0] text-sm">Order #{order.id} from {mahallah.name}</p>
      </div>

      {/* Order Summary */}
      <div className="bg-[#2B2930] rounded-2xl p-4 mb-6">
        <h3 className="text-[#E6E1E5] text-sm mb-3">Order Summary</h3>
        <div className="space-y-2">
          {order.items.map((item, index) => (
            <div key={index} className="flex justify-between text-sm">
              <span className="text-[#CAC4D0]">
                {item.quantity}x {item.name}
              </span>
            </div>
          ))}
        </div>
      </div>

      {/* Rating Component */}
      <div className="bg-[#2B2930] rounded-2xl p-6 mb-6">
        <h3 className="text-[#E6E1E5] text-center mb-4">Rate your order *</h3>
        <div className="flex justify-center gap-3 mb-2">
          {[1, 2, 3, 4, 5].map((star) => (
            <button
              key={star}
              onClick={() => setRating(star)}
              onMouseEnter={() => setHoveredRating(star)}
              onMouseLeave={() => setHoveredRating(0)}
              className="transition-transform hover:scale-110"
            >
              <Star
                className={`w-10 h-10 transition-colors ${
                  star <= (hoveredRating || rating)
                    ? 'fill-[#FFD700] text-[#FFD700]'
                    : 'text-[#49454F]'
                }`}
              />
            </button>
          ))}
        </div>
        {rating > 0 && (
          <p className="text-center text-[#D0BCFF] text-sm">
            {rating === 1 && 'Poor'}
            {rating === 2 && 'Fair'}
            {rating === 3 && 'Good'}
            {rating === 4 && 'Very Good'}
            {rating === 5 && 'Excellent'}
          </p>
        )}
      </div>

      {/* Feedback Text Area */}
      <div className="bg-[#2B2930] rounded-2xl p-4 mb-6">
        <label className="block text-[#E6E1E5] mb-3">
          Share your feedback (Optional)
        </label>
        <textarea
          value={feedback}
          onChange={(e) => setFeedback(e.target.value)}
          placeholder="Tell us about your experience..."
          rows={5}
          className="w-full px-4 py-3 bg-[#211F26] rounded-xl border border-[#49454F] text-[#E6E1E5] placeholder:text-[#938F99] focus:outline-none focus:border-[#D0BCFF] resize-none"
        />
      </div>

      {/* Submit Button */}
      <button
        onClick={handleSubmit}
        className="w-full bg-[#D0BCFF] text-[#381E72] py-4 rounded-full hover:bg-[#E8DEF8] transition-colors flex items-center justify-center gap-2"
      >
        <Send className="w-5 h-5" />
        <span>Submit Review</span>
      </button>

      {/* Skip Button */}
      <button
        onClick={onSubmit}
        className="w-full text-[#CAC4D0] text-sm mt-4 hover:text-[#E6E1E5] transition-colors"
      >
        Skip for now
      </button>
    </div>
  );
}
