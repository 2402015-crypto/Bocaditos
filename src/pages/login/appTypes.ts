export interface AppNavigation {
  toHome: () => Promise<{ success: boolean; error?: string }>;
  toLogin: () => Promise<{ success: boolean; error?: string }>;
}

declare global {
  interface Window {
    appNav: AppNavigation;
  }
}

export interface AppNavigation {
  toHome: () => Promise<{ success: boolean; error?: string }>;
  toLogin: () => Promise<{ success: boolean; error?: string }>;
}

export interface Http {
  get: (url: string, options?: any) => Promise<any>;
  post: (url: string, body: any, options?: any) => Promise<any>;
}

declare global {
  interface Window {
    appNav: AppNavigation;
    http: Http;
    auth: {
      setToken: (token: string) => boolean;
      clearToken: () => boolean;
      getToken: () => string | null;
    };
  }
}