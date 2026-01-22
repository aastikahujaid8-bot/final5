import { useState } from 'react';
import { Shield, BookOpen, Wrench, Bot, Trophy, User, LogOut, ChevronDown } from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';

interface NavigationProps {
  activeTab: string;
  onTabChange: (tab: string) => void;
}

export function Navigation({ activeTab, onTabChange }: NavigationProps) {
  const { profile, signOut } = useAuth();
  const [showDropdown, setShowDropdown] = useState(false);

  const tabs = [
    { id: 'labs', label: 'Vulnerability Labs', icon: Shield },
    { id: 'tools', label: 'Security Tools', icon: Wrench },
    { id: 'learn', label: 'Learning Path', icon: BookOpen },
    { id: 'progress', label: 'Progress', icon: Trophy },
    { id: 'assistant', label: 'AI Assistant', icon: Bot },
  ];

  const handleSignOut = async () => {
    await signOut();
    setShowDropdown(false);
  };

  return (
    <nav className="bg-gray-900 text-white shadow-lg">
      <div className="max-w-7xl mx-auto px-4">
        <div className="flex items-center justify-between h-16">
          <div className="flex items-center space-x-2">
            <Shield className="h-8 w-8 text-emerald-400" />
            <span className="text-xl font-bold">CyberSec Academy</span>
          </div>
          <div className="flex items-center space-x-4">
            <div className="flex space-x-1">
              {tabs.map((tab) => {
                const Icon = tab.icon;
                return (
                  <button
                    key={tab.id}
                    onClick={() => onTabChange(tab.id)}
                    className={`flex items-center space-x-2 px-4 py-2 rounded-lg transition-all ${
                      activeTab === tab.id
                        ? 'bg-emerald-600 text-white'
                        : 'text-gray-300 hover:bg-gray-800'
                    }`}
                  >
                    <Icon className="h-5 w-5" />
                    <span className="hidden sm:inline">{tab.label}</span>
                  </button>
                );
              })}
            </div>
            <div className="relative">
              <button
                onClick={() => setShowDropdown(!showDropdown)}
                className="flex items-center space-x-2 px-3 py-2 rounded-lg bg-gray-800 hover:bg-gray-700 transition-all"
              >
                <User className="h-5 w-5" />
                <span className="hidden sm:inline">{profile?.username || 'User'}</span>
                <ChevronDown className="h-4 w-4" />
              </button>
              {showDropdown && (
                <div className="absolute right-0 mt-2 w-56 bg-white rounded-lg shadow-lg py-2 z-50">
                  <div className="px-4 py-3 border-b border-gray-200">
                    <p className="text-sm font-semibold text-gray-900">{profile?.full_name}</p>
                    <p className="text-xs text-gray-600">{profile?.email}</p>
                    <div className="mt-2 flex items-center justify-between">
                      <span className="text-xs text-gray-600">Level:</span>
                      <span className="text-xs font-semibold text-emerald-600">{profile?.skill_level}</span>
                    </div>
                    <div className="flex items-center justify-between">
                      <span className="text-xs text-gray-600">Points:</span>
                      <span className="text-xs font-semibold text-emerald-600">{profile?.total_points}</span>
                    </div>
                  </div>
                  <button
                    onClick={handleSignOut}
                    className="w-full px-4 py-2 text-left text-sm text-red-600 hover:bg-red-50 flex items-center space-x-2"
                  >
                    <LogOut className="h-4 w-4" />
                    <span>Sign Out</span>
                  </button>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </nav>
  );
}
