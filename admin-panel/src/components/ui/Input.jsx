export default function Input({ label, className = '', ...props }) {
  return (
    <div className="mb-3 w-full">
      {label && <label className="block text-sm font-medium text-gray-700 mb-1">{label}</label>}
      <input
        className={`w-full bg-gray-50 text-black placeholder-gray-400 px-4 py-2 text-sm rounded-md border border-gray-300 outline-none focus:ring-2 focus:ring-primary ${className}`}
        {...props}
      />
    </div>
  );
}