// See the Electron documentation for details on how to use preload scripts:
// https://www.electronjs.org/docs/latest/tutorial/process-model#preload-scripts

import { contextBridge, ipcRenderer } from 'electron';

// Simple in-memory token store in preload. It's safer than exposing direct
// access to localStorage and lets the preload inject Authorization headers
// automatically into `http` calls.
let _authToken: string | null = null;

contextBridge.exposeInMainWorld('appNav', {
  toHome: () => ipcRenderer.invoke('nav:toHome'),
  toLogin: () => ipcRenderer.invoke('nav:toLogin'),
});

contextBridge.exposeInMainWorld('auth', {
  setToken: (token: string) => { _authToken = token; return true; },
  clearToken: () => { _authToken = null; return true; },
  getToken: () => _authToken,
});

contextBridge.exposeInMainWorld('http', {
  get: (url: string, options?: any) => {
    const headers = Object.assign({}, options?.headers || {});
    if (_authToken) headers['Authorization'] = `Bearer ${_authToken}`;
    return ipcRenderer.invoke('http:get', url, { ...options, headers });
  },
  post: (url: string, body: any, options?: any) => {
    const headers = Object.assign({ 'Content-Type': 'application/json' }, options?.headers || {});
    if (_authToken) headers['Authorization'] = `Bearer ${_authToken}`;
    return ipcRenderer.invoke('http:post', url, body, { ...options, headers });
  },
});