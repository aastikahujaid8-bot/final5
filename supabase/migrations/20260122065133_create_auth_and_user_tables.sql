/*
  # Authentication and User Management System

  ## Overview
  This migration sets up a complete authentication system with user profiles,
  progress tracking, and lab completion records.

  ## New Tables

  ### `user_profiles`
  - `id` (uuid, primary key) - References auth.users
  - `username` (text, unique) - User's display name
  - `email` (text, unique) - User's email address
  - `full_name` (text) - User's full name
  - `avatar_url` (text, nullable) - Profile picture URL
  - `bio` (text, nullable) - User biography
  - `skill_level` (text) - Current skill level (Beginner/Intermediate/Advanced)
  - `total_points` (integer) - Total points earned
  - `current_streak` (integer) - Current daily streak
  - `longest_streak` (integer) - Longest streak achieved
  - `created_at` (timestamptz) - Account creation timestamp
  - `updated_at` (timestamptz) - Last update timestamp

  ### `labs_completed`
  - `id` (uuid, primary key) - Unique identifier
  - `user_id` (uuid) - References user_profiles(id)
  - `lab_id` (text) - Lab identifier (sql-injection, xss, etc.)
  - `lab_name` (text) - Human-readable lab name
  - `difficulty` (text) - Lab difficulty level
  - `points_earned` (integer) - Points awarded for completion
  - `completion_time` (integer) - Time taken in seconds
  - `completed_at` (timestamptz) - Completion timestamp

  ### `modules_completed`
  - `id` (uuid, primary key) - Unique identifier
  - `user_id` (uuid) - References user_profiles(id)
  - `module_name` (text) - Module name
  - `module_level` (text) - Module difficulty level
  - `points_earned` (integer) - Points awarded
  - `completed_at` (timestamptz) - Completion timestamp

  ### `user_achievements`
  - `id` (uuid, primary key) - Unique identifier
  - `user_id` (uuid) - References user_profiles(id)
  - `achievement_id` (text) - Achievement identifier
  - `achievement_name` (text) - Achievement name
  - `description` (text) - Achievement description
  - `points` (integer) - Points awarded
  - `earned_at` (timestamptz) - When earned

  ### `daily_streaks`
  - `id` (uuid, primary key) - Unique identifier
  - `user_id` (uuid) - References user_profiles(id)
  - `activity_date` (date) - Date of activity
  - `labs_completed` (integer) - Labs completed that day
  - `modules_completed` (integer) - Modules completed that day
  - `points_earned` (integer) - Points earned that day

  ## Security
  - Enable RLS on all tables
  - Users can only read/write their own data
  - Profiles are publicly readable but only user can update their own
  - Automatic user profile creation on signup via trigger

  ## Important Notes
  - Uses Supabase Auth for authentication
  - Profiles automatically created when user signs up
  - All sensitive data protected by RLS
  - Indexes added for performance
*/

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- USER PROFILES TABLE
-- =====================================================

CREATE TABLE IF NOT EXISTS user_profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  username text UNIQUE NOT NULL,
  email text UNIQUE NOT NULL,
  full_name text DEFAULT '',
  avatar_url text,
  bio text,
  skill_level text DEFAULT 'Beginner' CHECK (skill_level IN ('Beginner', 'Intermediate', 'Advanced')),
  total_points integer DEFAULT 0,
  current_streak integer DEFAULT 0,
  longest_streak integer DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;

-- Profiles are publicly readable but only user can update their own
CREATE POLICY "Profiles are viewable by everyone"
  ON user_profiles FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can insert their own profile"
  ON user_profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update their own profile"
  ON user_profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Index for faster lookups
CREATE INDEX IF NOT EXISTS idx_user_profiles_username ON user_profiles(username);
CREATE INDEX IF NOT EXISTS idx_user_profiles_email ON user_profiles(email);

-- =====================================================
-- LABS COMPLETED TABLE
-- =====================================================

CREATE TABLE IF NOT EXISTS labs_completed (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id uuid NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  lab_id text NOT NULL,
  lab_name text NOT NULL,
  difficulty text DEFAULT 'beginner' CHECK (difficulty IN ('beginner', 'intermediate', 'advanced')),
  points_earned integer DEFAULT 100,
  completion_time integer DEFAULT 0,
  completed_at timestamptz DEFAULT now(),
  UNIQUE(user_id, lab_id)
);

ALTER TABLE labs_completed ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own completed labs"
  ON labs_completed FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own completed labs"
  ON labs_completed FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE INDEX IF NOT EXISTS idx_labs_completed_user_id ON labs_completed(user_id);
CREATE INDEX IF NOT EXISTS idx_labs_completed_date ON labs_completed(completed_at DESC);

-- =====================================================
-- MODULES COMPLETED TABLE
-- =====================================================

CREATE TABLE IF NOT EXISTS modules_completed (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id uuid NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  module_name text NOT NULL,
  module_level text NOT NULL,
  points_earned integer DEFAULT 100,
  completed_at timestamptz DEFAULT now(),
  UNIQUE(user_id, module_name)
);

ALTER TABLE modules_completed ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own completed modules"
  ON modules_completed FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own completed modules"
  ON modules_completed FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE INDEX IF NOT EXISTS idx_modules_completed_user_id ON modules_completed(user_id);
CREATE INDEX IF NOT EXISTS idx_modules_completed_date ON modules_completed(completed_at DESC);

-- =====================================================
-- USER ACHIEVEMENTS TABLE
-- =====================================================

CREATE TABLE IF NOT EXISTS user_achievements (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id uuid NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  achievement_id text NOT NULL,
  achievement_name text NOT NULL,
  description text DEFAULT '',
  points integer DEFAULT 50,
  earned_at timestamptz DEFAULT now(),
  UNIQUE(user_id, achievement_id)
);

ALTER TABLE user_achievements ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own achievements"
  ON user_achievements FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own achievements"
  ON user_achievements FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE INDEX IF NOT EXISTS idx_user_achievements_user_id ON user_achievements(user_id);

-- =====================================================
-- DAILY STREAKS TABLE
-- =====================================================

CREATE TABLE IF NOT EXISTS daily_streaks (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id uuid NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
  activity_date date NOT NULL DEFAULT CURRENT_DATE,
  labs_completed integer DEFAULT 0,
  modules_completed integer DEFAULT 0,
  points_earned integer DEFAULT 0,
  UNIQUE(user_id, activity_date)
);

ALTER TABLE daily_streaks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own streaks"
  ON daily_streaks FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own streaks"
  ON daily_streaks FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own streaks"
  ON daily_streaks FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE INDEX IF NOT EXISTS idx_daily_streaks_user_id ON daily_streaks(user_id);
CREATE INDEX IF NOT EXISTS idx_daily_streaks_date ON daily_streaks(activity_date DESC);

-- =====================================================
-- AUTOMATIC PROFILE CREATION TRIGGER
-- =====================================================

-- Function to create user profile automatically
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.user_profiles (id, username, email, full_name)
  VALUES (
    new.id,
    COALESCE(new.raw_user_meta_data->>'username', split_part(new.email, '@', 1)),
    new.email,
    COALESCE(new.raw_user_meta_data->>'full_name', '')
  );
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to create profile on user signup
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- =====================================================
-- UPDATE TIMESTAMP TRIGGER
-- =====================================================

CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS trigger AS $$
BEGIN
  new.updated_at = now();
  RETURN new;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS on_user_profile_updated ON user_profiles;
CREATE TRIGGER on_user_profile_updated
  BEFORE UPDATE ON user_profiles
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();
