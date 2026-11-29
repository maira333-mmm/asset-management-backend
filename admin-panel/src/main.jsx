import React from 'react';
import ReactDOM from 'react-dom/client';
import { Provider } from 'react-redux';
import { store } from './app/store';
import App from './App';
import './index.css';
import { Toaster } from 'react-hot-toast';
import ThemeProvider from './ThemeProvider'; // 🌟 Import karein

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <Provider store={store}>
      <ThemeProvider>  {/* 🌟 Wrap karein */}
        <App />
        <Toaster position="top-right" reverseOrder={false} /> 
      </ThemeProvider>
    </Provider>
  </React.StrictMode>
);