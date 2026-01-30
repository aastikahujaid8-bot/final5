import { useState } from 'react';
import { useAuth } from './contexts/AuthContext';
import { LoginPage } from './components/Auth/LoginPage';
import { SignupPage } from './components/Auth/SignupPage';
import { ForgotPasswordPage } from './components/Auth/ForgotPasswordPage';
import { Navigation } from './components/Navigation';
import { Dashboard } from './components/Dashboard';
import { VulnerabilityLabs } from './components/VulnerabilityLabs';
import { VulnerableStore } from './components/VulnerableStore';
import { SecurityTools } from './components/SecurityTools';
import { LearningPath } from './components/LearningPath';
import { Progress } from './components/Progress';
import { AIAssistant } from './components/AIAssistant';
import { ToolPage } from './components/ToolPage';
import { VoiceGuide } from './components/VoiceGuide';

function App() {
  const { user, loading } = useAuth();
  const [authMode, setAuthMode] = useState<'login' | 'signup' | 'forgot-password'>('login');
  const [activeTab, setActiveTab] = useState('labs');
  const [selectedLab, setSelectedLab] = useState<string | null>(null);
  const [selectedTool, setSelectedTool] = useState<string | null>(null);
  const [showVoiceGuide, setShowVoiceGuide] = useState(true);

  const handleLabSelect = (labType: string) => {
    setSelectedLab(labType);
  };

  const handleCloseStore = () => {
    setSelectedLab(null);
  };

  const handleToolSelect = (toolId: string) => {
    setSelectedTool(toolId);
  };

  const handleCloseToolPage = () => {
    setSelectedTool(null);
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-emerald-500 via-teal-600 to-blue-600 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-16 w-16 border-b-4 border-white mx-auto"></div>
          <p className="mt-4 text-white text-xl font-semibold">Loading CyberSec Academy...</p>
        </div>
      </div>
    );
  }

  if (!user) {
    if (authMode === 'login') {
      return (
        <LoginPage
          onSwitchToSignup={() => setAuthMode('signup')}
          onSwitchToForgotPassword={() => setAuthMode('forgot-password')}
        />
      );
    } else if (authMode === 'signup') {
      return <SignupPage onSwitchToLogin={() => setAuthMode('login')} />;
    } else {
      return <ForgotPasswordPage onBack={() => setAuthMode('login')} />;
    }
  }
 
  

  return (
    <div className="min-h-screen bg-gray-100 relative">
      <Navigation activeTab={activeTab} onTabChange={setActiveTab} />

      <main className="max-w-7xl mx-auto px-4 py-8">
        {activeTab === 'labs' && (
          <>
            <Dashboard />
            <div className="mt-8">
              <VulnerabilityLabs onLabSelect={handleLabSelect} />
            </div>
          </>
        )}

        {activeTab === 'tools' && <SecurityTools onToolSelect={handleToolSelect} />}
        {activeTab === 'learn' && <LearningPath />}
        {activeTab === 'progress' && <Progress />}
        {activeTab === 'assistant' && <AIAssistant />}
      </main>

      {selectedLab && (
        <VulnerableStore
          vulnerabilityType={selectedLab}
          onClose={handleCloseStore}
        />
      )}

      {selectedTool && (
        <ToolPage
          toolId={selectedTool}
          onClose={handleCloseToolPage}
        />
      )}

      {showVoiceGuide && (
        <VoiceGuide onClose={() => setShowVoiceGuide(false)} />
      )}

      <div className="fixed bottom-4 right-4 text-xs text-gray-500 opacity-60 hover:opacity-100 transition-opacity">
        <p>Made by Aastik Ahuja BCACyber</p>
      </div>
    </div>
  );
}

export default App;



