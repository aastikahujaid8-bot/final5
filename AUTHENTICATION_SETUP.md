# CyberSec Academy - Authentication System

## Overview
A complete authentication system has been integrated into the CyberSec Academy application, featuring user registration, login, profile management, and progress tracking.

## What Was Created

### 1. Database Tables

#### `user_profiles`
Stores user account information and statistics.
- User details (username, email, full name)
- Profile customization (avatar, bio)
- Performance metrics (total points, streaks, skill level)
- Automatically created when user signs up

#### `labs_completed`
Tracks completed vulnerability labs.
- Lab identification and difficulty
- Points earned and completion time
- Timestamp for each completion

#### `modules_completed`
Records completed learning modules.
- Module name and level
- Points earned
- Completion timestamp

#### `user_achievements`
Stores earned achievements and badges.
- Achievement details and points
- Unlock timestamps

#### `daily_streaks`
Tracks daily activity for streak calculation.
- Date-based activity records
- Labs and modules completed per day
- Daily points earned

### 2. Authentication Components

#### Login Page (`src/components/Auth/LoginPage.tsx`)
- Email and password authentication
- Error handling and validation
- Switch to signup option
- Clean, modern UI with gradients

#### Signup Page (`src/components/Auth/SignupPage.tsx`)
- User registration with validation
- Username, email, full name, and password fields
- Password confirmation
- Automatic profile creation

#### Auth Context (`src/contexts/AuthContext.tsx`)
- Centralized authentication state management
- User session handling
- Profile loading and refreshing
- Sign up, sign in, and sign out functions

### 3. Updated Components

#### Navigation (`src/components/Navigation.tsx`)
- User profile dropdown showing:
  - Username and email
  - Current skill level
  - Total points
- Sign out functionality

#### Dashboard (`src/components/Dashboard.tsx`)
- Loads data for authenticated user
- Shows personalized stats
- Uses new database tables

#### Progress (`src/components/Progress.tsx`)
- Tracks user-specific progress
- Displays achievements and streaks
- Uses `modules_completed` and `daily_streaks` tables

#### LearningPath (`src/components/LearningPath.tsx`)
- Saves module completions to database
- Updates user points and streaks
- Tracks learning progress per user

## Database Security

### Row Level Security (RLS)
All tables have RLS enabled with policies ensuring:
- Users can only access their own data
- Profiles are publicly viewable but only editable by owner
- Complete data isolation between users

### Authentication Flow
1. User signs up via Supabase Auth
2. Trigger automatically creates user profile
3. User logs in with email/password
4. Session maintained via Supabase
5. All database queries filtered by user ID

## Key Features

### Automatic Profile Creation
When a user signs up, a database trigger automatically creates their profile in `user_profiles` with default values.

### Progress Tracking
- All lab and module completions tied to user ID
- Points automatically accumulated
- Streaks calculated from daily activity
- Skill level updated based on progress

### Session Management
- Persistent sessions across page refreshes
- Automatic session restoration
- Secure token handling via Supabase

### Data Synchronization
- Real-time profile updates
- Automatic points calculation
- Streak tracking based on daily activity

## How It Works

### User Registration
1. User fills signup form
2. Supabase creates auth account
3. Trigger creates user profile
4. User automatically logged in

### User Login
1. User enters credentials
2. Supabase validates
3. Profile loaded from database
4. User redirected to dashboard

### Progress Saving
1. User completes lab/module
2. Record saved to database with user ID
3. Profile points updated
4. Daily streak record created/updated
5. UI refreshed with new data

### Authentication Check
App checks authentication on every load:
- Loading state shown while checking
- Unauthenticated users see login/signup
- Authenticated users see full app

## Database Structure

```
user_profiles (main profile)
├── labs_completed (vulnerability labs)
├── modules_completed (learning modules)
├── user_achievements (badges/rewards)
└── daily_streaks (activity tracking)
```

## Environment Variables Required

Ensure these are set in your `.env` file:
```
VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
```

## Migration Applied

Migration file: `create_auth_and_user_tables`
- Creates all user-related tables
- Sets up RLS policies
- Creates automatic profile creation trigger
- Adds indexes for performance

## Next Steps

1. Users can now sign up and login
2. Progress is saved per user
3. Each user has isolated data
4. Streaks and points are tracked
5. Profile information is maintained

## Testing

To test the authentication system:
1. Start the development server
2. You'll see the login page
3. Click "Sign up" to create an account
4. Fill in your details and create account
5. You'll be automatically logged in
6. Complete labs and modules to see progress
7. Check Progress tab for your stats
8. Click user dropdown to see profile info
9. Sign out and sign back in to verify persistence

## Important Notes

- All data is now user-specific
- Old "default_user" references have been removed
- Each user has completely isolated data
- RLS ensures data security
- Profile automatically created on signup
- Sessions persist across page refreshes
