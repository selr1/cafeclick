import { Search, MapPin } from 'lucide-react';
import { Mahallah } from '../App';

interface LocationSelectionProps {
  onSelectMahallah: (mahallah: Mahallah) => void;
}

// Added 'distance' property to the data
const mahallahs = [
  { id: '1', name: 'Mahallah Asiah', status: 'open', queueLevel: 'low', distance: 0.2 },
  { id: '2', name: 'Mahallah Faruq', status: 'open', queueLevel: 'high', distance: 0.5 },
  { id: '3', name: 'Mahallah Siddiq', status: 'open', queueLevel: 'medium', distance: 1.2 },
  { id: '4', name: 'Mahallah Bilal', status: 'open', queueLevel: 'low', distance: 0.8 },
  { id: '5', name: 'Mahallah Uthman', status: 'closed', queueLevel: 'low', distance: 4.5 },
  { id: '6', name: 'Mahallah Aminah', status: 'open', queueLevel: 'medium', distance: 0.3 },
] as const;

export default function LocationSelection({ onSelectMahallah }: LocationSelectionProps) {
  const getStatusColor = (status: 'open' | 'closed') => {
    return status === 'open' ? 'text-[#A8DAB5] bg-[#1F3823]' : 'text-[#CAC4D0] bg-[#36343B]';
  };

  const getQueueColor = (level: string) => {
    switch (level) {
      case 'low': return '🟢';
      case 'medium': return '🟡';
      case 'high': return '🔴';
      default: return '⚪';
    }
  };

  const getQueueText = (level: string) => {
    switch (level) {
      case 'low': return 'Low Queue';
      case 'medium': return 'Medium Queue';
      case 'high': return 'High Queue';
      default: return '';
    }
  };

  // Logic for Distance Color: Green (<1km), Yellow (<3km), Red (>3km)
  const getDistanceColor = (dist: number) => {
    if (dist < 1.0) return '🟢'; // Green for close
    if (dist < 3.0) return '🟡'; // Yellow for medium
    return '🔴'; // Red for far
  };

  return (
    <div className="w-full min-h-screen bg-[#1C1B1F] px-4 py-6 max-w-md mx-auto">
      {/* Header */}
      <div className="mb-6">
        <h1 className="text-[#E6E1E5] mb-6">
          Where are you eating today?
        </h1>
      </div>

      {/* Search Bar */}
      <div className="relative mb-6">
        <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-[#CAC4D0]" />
        <input
          type="text"
          placeholder="Search Mahallah..."
          className="w-full pl-12 pr-4 py-3 bg-[#2B2930] rounded-full border-none outline-none text-[#E6E1E5] placeholder:text-[#938F99]"
        />
      </div>

      {/* Mahallah List */}
      <div className="space-y-3">
        {mahallahs.map((mahallah) => (
          <button
            key={mahallah.id}
            onClick={() => onSelectMahallah(mahallah as Mahallah)}
            className="w-full bg-[#2B2930] rounded-2xl p-4 flex items-center gap-4 hover:bg-[#36343B] transition-colors"
          >
            {/* Icon */}
            <div className="w-12 h-12 rounded-full bg-[#4A4458] flex items-center justify-center flex-shrink-0">
              <MapPin className="w-6 h-6 text-[#D0BCFF]" />
            </div>

            {/* Content */}
            <div className="flex-1 text-left">
              <h3 className="text-[#E6E1E5] mb-1">
                {mahallah.name}
              </h3>
              
              {/* Status Row */}
              <div className="flex flex-wrap items-center gap-2">
                {/* Open/Closed Badge */}
                <span className={`px-2 py-0.5 rounded-full text-xs ${getStatusColor(mahallah.status)}`}>
                  {mahallah.status === 'open' ? 'Open' : 'Closed'}
                </span>

                {/* Queue & Distance Widgets (Only show if open) */}
                {mahallah.status === 'open' && (
                  <>
                    {/* Queue Widget */}
                    <span className="text-xs text-[#CAC4D0] flex items-center">
                      {getQueueColor(mahallah.queueLevel)} {getQueueText(mahallah.queueLevel)}
                    </span>

                    {/* Separator Dot */}
                    <span className="text-[#49454F] text-[10px]">•</span>

                    {/* Distance Widget */}
                    <span className="text-xs text-[#CAC4D0] flex items-center">
                      {getDistanceColor(mahallah.distance)} {mahallah.distance} km
                    </span>
                  </>
                )}
              </div>
            </div>

            {/* Arrow */}
            <div className="text-[#938F99]">
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
                <path d="M9 6L15 12L9 18" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
              </svg>
            </div>
          </button>
        ))}
      </div>
    </div>
  );
}