export default function Button({ children, variant = 'primary', className = '', ...props }) {
  const base = 'uppercase text-xs py-2 px-6 rounded-md font-semibold tracking-wide transition-all';
  
  const styles = {
    primary: { 
      backgroundColor: 'var(--primary-color)', 
      color: '#ffffff' 
    },
    secondary: { 
      backgroundColor: '#ffffff', 
      color: 'var(--primary-color)', 
      border: '1px solid var(--primary-color)' 
    },
    danger: { 
      backgroundColor: '#dc2626', 
      color: '#ffffff' 
    },
  };

  return (
    <button 
      className={`${base} hover:opacity-90 ${className}`} 
      style={styles[variant]} 
      {...props}
    >
      {children}
    </button>
  );
}