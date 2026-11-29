/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: 'var(--primary-color)',
          hover: 'var(--primary-hover)',
        },
        accent: 'var(--accent-color)',
        background: 'var(--bg-color)',
        surface: 'var(--surface-color)',
        text: {
          DEFAULT: 'var(--text-main)',
          muted: 'var(--text-muted)',
        }
      },
      fontFamily: {
        sans: ['Instrument Sans', 'sans-serif'],
        serif: ['Newsreader', 'serif'],
      }
    },
  },
  plugins: [],
}