import { useState } from 'react';
import { UserPlus } from 'lucide-react';
import { User, mockUsers } from './Login';

interface RegistrationProps {
  onRegister: () => void;
  onBackToLogin: () => void;
}

export default function Registration({ onRegister, onBackToLogin }: RegistrationProps) {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    password: '',
    confirmPassword: '',
    matricNo: '',
    role: 'customer' as 'customer' | 'staff'
  });
  const [error, setError] = useState('');
  const [success, setSuccess] = useState(false);

  const handleRegister = () => {
    setError('');

    // Validation
    if (!formData.name || !formData.email || !formData.password || !formData.matricNo) {
      setError('All fields are required');
      return;
    }

    if (formData.password !== formData.confirmPassword) {
      setError('Passwords do not match');
      return;
    }

    if (formData.password.length < 3) {
      setError('Password must be at least 3 characters');
      return;
    }

    // Check if user already exists
    const existingUser = mockUsers.find(u => 
      u.email === formData.email || 
      u.matricNo === formData.matricNo
    );

    if (existingUser) {
      setError('User with this email or matric number already exists');
      return;
    }

    // Create new user (in real app, this would be saved to database)
    const newUser: User = {
      id: (mockUsers.length + 1).toString(),
      name: formData.name,
      email: formData.email,
      password: formData.password,
      role: formData.role,
      matricNo: formData.matricNo
    };

    mockUsers.push(newUser);
    setSuccess(true);

    // Redirect to login after 2 seconds
    setTimeout(() => {
      onRegister();
    }, 2000);
  };

  if (success) {
    return (
      <div className="w-full min-h-screen bg-[#1C1B1F] px-4 py-8 flex flex-col items-center justify-center max-w-md mx-auto">
        <div className="text-center">
          <div className="w-20 h-20 bg-[#A8DAB5] rounded-full flex items-center justify-center mx-auto mb-4">
            <svg width="40" height="40" viewBox="0 0 24 24" fill="none">
              <path d="M9 12L11 14L15 10M21 12C21 16.971 16.971 21 12 21C7.029 21 3 16.971 3 12C3 7.029 7.029 3 12 3C16.971 3 21 7.029 21 12Z" stroke="#1F3823" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
            </svg>
          </div>
          <h2 className="text-[#E6E1E5] mb-2">Registration Successful!</h2>
          <p className="text-[#CAC4D0] text-sm">Redirecting to login...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="w-full min-h-screen bg-[#1C1B1F] px-4 py-8 max-w-md mx-auto">
      {/* Header */}
      <div className="text-center mb-8">
        <div className="w-20 h-20 bg-gradient-to-br from-[#6750A4] to-[#D0BCFF] rounded-3xl flex items-center justify-center mx-auto mb-4">
          <UserPlus className="w-10 h-10 text-white" />
        </div>
        <h1 className="text-[#E6E1E5] mb-2">Create Account</h1>
        <p className="text-[#CAC4D0] text-sm">Join Cafe Click today</p>
      </div>

      {/* Registration Form */}
      <div className="space-y-4 mb-6">
        {/* Full Name */}
        <div>
          <label className="block text-[#CAC4D0] text-sm mb-2">
            Full Name *
          </label>
          <input
            type="text"
            value={formData.name}
            onChange={(e) => setFormData({ ...formData, name: e.target.value })}
            placeholder="Ahmad bin Abdullah"
            className="w-full px-4 py-3 bg-[#2B2930] rounded-xl border border-[#49454F] text-[#E6E1E5] placeholder:text-[#938F99] focus:outline-none focus:border-[#D0BCFF]"
          />
        </div>

        {/* Email */}
        <div>
          <label className="block text-[#CAC4D0] text-sm mb-2">
            Email *
          </label>
          <input
            type="email"
            value={formData.email}
            onChange={(e) => setFormData({ ...formData, email: e.target.value })}
            placeholder="student@iium.edu.my"
            className="w-full px-4 py-3 bg-[#2B2930] rounded-xl border border-[#49454F] text-[#E6E1E5] placeholder:text-[#938F99] focus:outline-none focus:border-[#D0BCFF]"
          />
        </div>

        {/* Matric/Staff Number */}
        <div>
          <label className="block text-[#CAC4D0] text-sm mb-2">
            Matric / Staff Number *
          </label>
          <input
            type="text"
            value={formData.matricNo}
            onChange={(e) => setFormData({ ...formData, matricNo: e.target.value })}
            placeholder="2012345 or STF001"
            className="w-full px-4 py-3 bg-[#2B2930] rounded-xl border border-[#49454F] text-[#E6E1E5] placeholder:text-[#938F99] focus:outline-none focus:border-[#D0BCFF]"
          />
        </div>

        {/* Password */}
        <div>
          <label className="block text-[#CAC4D0] text-sm mb-2">
            Password *
          </label>
          <input
            type="password"
            value={formData.password}
            onChange={(e) => setFormData({ ...formData, password: e.target.value })}
            placeholder="Minimum 3 characters"
            className="w-full px-4 py-3 bg-[#2B2930] rounded-xl border border-[#49454F] text-[#E6E1E5] placeholder:text-[#938F99] focus:outline-none focus:border-[#D0BCFF]"
          />
        </div>

        {/* Confirm Password */}
        <div>
          <label className="block text-[#CAC4D0] text-sm mb-2">
            Confirm Password *
          </label>
          <input
            type="password"
            value={formData.confirmPassword}
            onChange={(e) => setFormData({ ...formData, confirmPassword: e.target.value })}
            placeholder="Re-enter password"
            className="w-full px-4 py-3 bg-[#2B2930] rounded-xl border border-[#49454F] text-[#E6E1E5] placeholder:text-[#938F99] focus:outline-none focus:border-[#D0BCFF]"
          />
        </div>

        {/* Error Message */}
        {error && (
          <div className="bg-[#601410] text-[#F2B8B5] px-4 py-3 rounded-xl text-sm">
            {error}
          </div>
        )}
      </div>

      {/* Register Button */}
      <button
        onClick={handleRegister}
        className="w-full bg-[#D0BCFF] text-[#381E72] py-4 rounded-full hover:bg-[#E8DEF8] transition-colors mb-4"
      >
        Create Account
      </button>

      {/* Back to Login */}
      <button
        onClick={onBackToLogin}
        className="w-full text-[#D0BCFF] text-sm hover:text-[#E8DEF8] transition-colors"
      >
        Already have an account? Sign in
      </button>
    </div>
  );
}
