import { useState } from 'react';
import { Camera, X, CheckCircle } from 'lucide-react';

interface QRScannerProps {
  onClose: () => void;
  onScanSuccess: (code: string) => void;
}

export default function QRScanner({ onClose, onScanSuccess }: QRScannerProps) {
  const [scannedCode, setScannedCode] = useState('');
  const [isScanning, setIsScanning] = useState(true);
  const [scanSuccess, setScanSuccess] = useState(false);

  // Simulate QR scan (in real app, this would use device camera)
  const handleSimulateScan = () => {
    // Generate a mock scanned code
    const mockCode = `PICKUP-${Math.floor(1000 + Math.random() * 9000)}-${Date.now()}`;
    setScannedCode(mockCode);
    setIsScanning(false);
    setScanSuccess(true);

    // Call success callback
    setTimeout(() => {
      onScanSuccess(mockCode);
    }, 1500);
  };

  // Manual code entry
  const handleManualEntry = () => {
    setIsScanning(false);
  };

  const handleManualSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (scannedCode.trim()) {
      setScanSuccess(true);
      setTimeout(() => {
        onScanSuccess(scannedCode);
      }, 1500);
    }
  };

  if (scanSuccess) {
    return (
      <div className="fixed inset-0 bg-[#1C1B1F] z-50 flex items-center justify-center">
        <div className="text-center px-4">
          <div className="w-24 h-24 bg-[#A8DAB5] rounded-full flex items-center justify-center mx-auto mb-4 animate-bounce">
            <CheckCircle className="w-12 h-12 text-[#1F3823]" />
          </div>
          <h2 className="text-[#E6E1E5] mb-2">Scan Successful!</h2>
          <p className="text-[#CAC4D0] text-sm">Order verified</p>
        </div>
      </div>
    );
  }

  return (
    <div className="fixed inset-0 bg-[#1C1B1F] z-50 max-w-md mx-auto">
      {/* Header */}
      <div className="flex items-center justify-between px-4 py-4 bg-[#2B2930]">
        <h2 className="text-[#E6E1E5]">Scan Customer QR</h2>
        <button
          onClick={onClose}
          className="p-2 bg-[#49454F] rounded-lg hover:bg-[#36343B] transition-colors"
        >
          <X className="w-5 h-5 text-[#E6E1E5]" />
        </button>
      </div>

      {isScanning ? (
        <div className="flex flex-col items-center justify-center h-[calc(100vh-80px)] px-4">
          {/* Camera View Simulation */}
          <div className="w-full max-w-sm aspect-square bg-[#2B2930] rounded-3xl relative mb-6 overflow-hidden">
            {/* Scanning Frame */}
            <div className="absolute inset-0 flex items-center justify-center">
              <div className="w-64 h-64 border-4 border-[#D0BCFF] rounded-2xl relative animate-pulse">
                {/* Corner Markers */}
                <div className="absolute top-0 left-0 w-8 h-8 border-t-4 border-l-4 border-[#D0BCFF]" />
                <div className="absolute top-0 right-0 w-8 h-8 border-t-4 border-r-4 border-[#D0BCFF]" />
                <div className="absolute bottom-0 left-0 w-8 h-8 border-b-4 border-l-4 border-[#D0BCFF]" />
                <div className="absolute bottom-0 right-0 w-8 h-8 border-b-4 border-r-4 border-[#D0BCFF]" />
                
                {/* Scanning Line */}
                <div className="absolute inset-x-0 top-0 h-1 bg-[#D0BCFF] animate-scan" />
              </div>
            </div>

            {/* Camera Icon */}
            <div className="absolute inset-0 flex items-center justify-center opacity-20">
              <Camera className="w-32 h-32 text-[#CAC4D0]" />
            </div>
          </div>

          {/* Instructions */}
          <div className="text-center mb-6">
            <p className="text-[#E6E1E5] mb-2">Position QR code within frame</p>
            <p className="text-[#CAC4D0] text-sm">Camera will scan automatically</p>
          </div>

          {/* Demo: Simulate Scan Button */}
          <button
            onClick={handleSimulateScan}
            className="w-full max-w-sm bg-[#D0BCFF] text-[#381E72] py-4 rounded-full hover:bg-[#E8DEF8] transition-colors mb-3"
          >
            Simulate Scan (Demo)
          </button>

          {/* Manual Entry Option */}
          <button
            onClick={handleManualEntry}
            className="text-[#D0BCFF] text-sm hover:text-[#E8DEF8] transition-colors"
          >
            Enter code manually
          </button>
        </div>
      ) : (
        <div className="flex flex-col items-center justify-center h-[calc(100vh-80px)] px-4">
          <div className="w-full max-w-sm">
            <h3 className="text-[#E6E1E5] text-center mb-6">Manual Code Entry</h3>
            
            <form onSubmit={handleManualSubmit} className="space-y-4">
              <div>
                <label className="block text-[#CAC4D0] text-sm mb-2">
                  Verification Code
                </label>
                <input
                  type="text"
                  value={scannedCode}
                  onChange={(e) => setScannedCode(e.target.value)}
                  placeholder="PICKUP-XXXX-XXXXX"
                  className="w-full px-4 py-3 bg-[#2B2930] rounded-xl border border-[#49454F] text-[#E6E1E5] placeholder:text-[#938F99] focus:outline-none focus:border-[#D0BCFF] font-mono"
                />
              </div>

              <button
                type="submit"
                className="w-full bg-[#D0BCFF] text-[#381E72] py-4 rounded-full hover:bg-[#E8DEF8] transition-colors"
              >
                Verify Code
              </button>
            </form>

            <button
              onClick={() => setIsScanning(true)}
              className="w-full text-[#CAC4D0] text-sm mt-4 hover:text-[#E6E1E5] transition-colors"
            >
              Back to scanning
            </button>
          </div>
        </div>
      )}

      {/* Scanning Animation CSS */}
      <style>{`
        @keyframes scan {
          0% {
            top: 0;
          }
          50% {
            top: 100%;
          }
          100% {
            top: 0;
          }
        }
        .animate-scan {
          animation: scan 2s linear infinite;
        }
      `}</style>
    </div>
  );
}
