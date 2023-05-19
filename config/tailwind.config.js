const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      backgroundColor: {
        primary: '#333333',
        secondary: '#000000',
        'btn-primary': '#00B600'
      },
      colors: {
        primary: '#00B600',
        secondary: '#A3A3A3',
      },
      animation: {
        fade: 'fadeOut 5s ease-in-out',
        heart: 'heartPing .5s ease-in-out',
      },
      keyframes: {
        fadeOut: {
          '0%': { opacity: 100 },
          '100%': { opacity: 0 },
        },
        heartPing: {
          '0%, 100%': { transform: 'scale(1)' },
          '50%': { transform: 'scale(1.3)' },
        },
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
