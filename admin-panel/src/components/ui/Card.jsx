export default function Card({ children, className = '' }) {
  return (
    <div className={`bg-white rounded-2xl shadow-[0_5px_15px_rgba(0,0,0,0.15)] p-6 ${className}`}>
      {children}
    </div>
  );
}