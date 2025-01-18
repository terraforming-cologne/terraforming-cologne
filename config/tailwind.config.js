const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  content: [
    "./public/*.html",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*.{erb,haml,html,slim}",
  ],
  theme: {
    container: {
      screens: {
        xl: "1024px",
        "2xl": "1024px",
      },
    },
    extend: {
      fontFamily: {
        sans: ["Lato", ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    // require("@tailwindcss/typography"),
    // require('@tailwindcss/container-queries'),
  ],
};
