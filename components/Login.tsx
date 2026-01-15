import { useState } from 'react';
import { LogIn } from 'lucide-react';

export interface User {
  id: string;
  name: string;
  email: string;
  password: string;
  role: 'customer' | 'staff';
  matricNo?: string;
  staffNo?: string;
}

// Mock user database
export const mockUsers: User[] = [
  {
    id: '1',
    name: 'Ahmad Student',
    email: 'student@iium.edu.my',
    password: '123',
    role: 'customer',
    matricNo: '2012345'
  },
  {
    id: '2',
    name: 'Cafe Staff',
    email: 'staff@iium.edu.my',
    password: '123',
    role: 'staff',
    staffNo: 'STF001'
  }
];

interface LoginProps {
  onLogin: (user: User) => void;
  onNavigateToRegister: () => void;
}

export default function Login({ onLogin, onNavigateToRegister }: LoginProps) {
  const [identifier, setIdentifier] = useState(''); // Email/Matric/Staff No
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');

  const handleLogin = () => {
    setError('');
    
    // Find user by email, matric no, or staff no
    const user = mockUsers.find(u => 
      u.email === identifier || 
      u.matricNo === identifier || 
      u.staffNo === identifier
    );

    if (!user) {
      setError('User not found');
      return;
    }

    if (user.password !== password) {
      setError('Incorrect password');
      return;
    }

    onLogin(user);
  };

  return (
    <div className="w-full min-h-screen bg-[#1C1B1F] px-4 py-8 flex flex-col items-center justify-center max-w-md mx-auto">
      {/* Logo and Header */}
      <div className="text-center mb-8">
        <div className="w-20 h-20 bg-gradient-to-br from-[#6750A4] to-[#D0BCFF] rounded-3xl flex items-center justify-center mx-auto mb-4">
          <LogIn className="w-10 h-10 text-white" />
        </div>
        <h1 className="text-[#E6E1E5] mb-2">Welcome to Cafe Click</h1>
        <p className="text-[#CAC4D0] text-sm">Sign in to continue</p>
      </div>

      {/* Login Form */}
      <div className="w-full space-y-4 mb-6">
        {/* Email/Matric/Staff No Input */}
        <div>
          <label className="block text-[#CAC4D0] text-sm mb-2">
            Email / Matric No / Staff No
          </label>
          <input
            type="text"
            value={identifier}
            onChange={(e) => setIdentifier(e.target.value)}
            placeholder="student@iium.edu.my or 2012345"
            className="w-full px-4 py-3 bg-[#2B2930] rounded-xl border border-[#49454F] text-[#E6E1E5] placeholder:text-[#938F99] focus:outline-none focus:border-[#D0BCFF]"
          />
        </div>

        {/* Password Input */}
        <div>
          <label className="block text-[#CAC4D0] text-sm mb-2">
            Password
          </label>
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            placeholder="Enter your password"
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

      {/* Login Button */}
      <button
        onClick={handleLogin}
        className="w-full bg-[#D0BCFF] text-[#381E72] py-4 rounded-full hover:bg-[#E8DEF8] transition-colors mb-4"
      >
        Sign In
      </button>

      {/* Register Link */}
      <button
        onClick={onNavigateToRegister}
        className="text-[#D0BCFF] text-sm hover:text-[#E8DEF8] transition-colors"
      >
        Don't have an account? Register here
      </button>

      {/* Demo Credentials */}
      <div className="mt-8 p-4 bg-[#2B2930] rounded-xl w-full">
        <p className="text-[#CAC4D0] text-xs mb-2">Demo Credentials:</p>
        <div className="space-y-1 text-xs text-[#938F99]">
          <p>Customer: student / 123</p>
          <p>Staff: staff / 123</p>
        </div>
      </div>
    </div>
  );
}
