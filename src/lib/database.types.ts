export type Database = {
  public: {
    Tables: {
      user_profiles: {
        Row: {
          id: string;
          username: string;
          email: string;
          full_name: string;
          avatar_url: string | null;
          bio: string | null;
          skill_level: string;
          total_points: number;
          current_streak: number;
          longest_streak: number;
          created_at: string;
          updated_at: string;
        };
        Insert: Omit<Database['public']['Tables']['user_profiles']['Row'], 'created_at' | 'updated_at'>;
        Update: Partial<Database['public']['Tables']['user_profiles']['Insert']>;
      };
      labs_completed: {
        Row: {
          id: string;
          user_id: string;
          lab_id: string;
          lab_name: string;
          difficulty: string;
          points_earned: number;
          completion_time: number;
          completed_at: string;
        };
        Insert: Omit<Database['public']['Tables']['labs_completed']['Row'], 'id' | 'completed_at'>;
        Update: Partial<Database['public']['Tables']['labs_completed']['Insert']>;
      };
      modules_completed: {
        Row: {
          id: string;
          user_id: string;
          module_name: string;
          module_level: string;
          points_earned: number;
          completed_at: string;
        };
        Insert: Omit<Database['public']['Tables']['modules_completed']['Row'], 'id' | 'completed_at'>;
        Update: Partial<Database['public']['Tables']['modules_completed']['Insert']>;
      };
      user_achievements: {
        Row: {
          id: string;
          user_id: string;
          achievement_id: string;
          achievement_name: string;
          description: string;
          points: number;
          earned_at: string;
        };
        Insert: Omit<Database['public']['Tables']['user_achievements']['Row'], 'id' | 'earned_at'>;
        Update: Partial<Database['public']['Tables']['user_achievements']['Insert']>;
      };
      daily_streaks: {
        Row: {
          id: string;
          user_id: string;
          activity_date: string;
          labs_completed: number;
          modules_completed: number;
          points_earned: number;
        };
        Insert: Omit<Database['public']['Tables']['daily_streaks']['Row'], 'id'>;
        Update: Partial<Database['public']['Tables']['daily_streaks']['Insert']>;
      };
      vulnerability_types: {
        Row: {
          id: string;
          name: string;
          description: string;
          difficulty: 'beginner' | 'intermediate' | 'advanced';
          category: string;
          icon: string | null;
          created_at: string;
        };
        Insert: Omit<Database['public']['Tables']['vulnerability_types']['Row'], 'id' | 'created_at'>;
        Update: Partial<Database['public']['Tables']['vulnerability_types']['Insert']>;
      };
      labs: {
        Row: {
          id: string;
          vulnerability_type_id: string | null;
          title: string;
          description: string;
          instructions: string;
          solution: string;
          points: number;
          created_at: string;
        };
        Insert: Omit<Database['public']['Tables']['labs']['Row'], 'id' | 'created_at'>;
        Update: Partial<Database['public']['Tables']['labs']['Insert']>;
      };
      store_products: {
        Row: {
          id: string;
          name: string;
          description: string;
          price: number;
          image_url: string | null;
          stock: number;
          created_at: string;
        };
        Insert: Omit<Database['public']['Tables']['store_products']['Row'], 'id' | 'created_at'>;
        Update: Partial<Database['public']['Tables']['store_products']['Insert']>;
      };
    };
  };
};
