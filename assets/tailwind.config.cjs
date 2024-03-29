// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin");

module.exports = {
  content: ["./js/**/*.js", "../lib/*_web.ex", "../lib/*_web/**/*.*ex"],
  theme: {
    extend: {
      colors: {
        brand: "#FD4F00",
      },
    },
    // listStyleType: {
    //   dash: "- ",
    // },
  },
  daisyui: {
    logs: false,
    themes: [
      {
        default: {
          primary: "#116FFD",
          secondary: "#5E656C",
          accent: "#116FFD",
          neutral: "#3B68AB",
          "base-100": "#EEF5FF",
          info: "#97C0FE",
          success: "#198754",
          warning: "#FFC107",
          error: "#DC3545",
        },
        dark: {
          primary: "#116FFD",
          secondary: "#5E656C",
          accent: "#116FFD",
          neutral: "#3B68AB",
          "base-100": "#001026",
          info: "#97C0FE",
          success: "#198754",
          warning: "#FFC107",
          error: "#DC3545",
        },
      },
    ],
  },
  plugins: [
    // require("@tailwindcss/forms"),
    require("@tailwindcss/typography"),
    plugin(({ addVariant }) =>
      addVariant("phx-no-feedback", [".phx-no-feedback&", ".phx-no-feedback &"])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-click-loading", [
        ".phx-click-loading&",
        ".phx-click-loading &",
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-submit-loading", [
        ".phx-submit-loading&",
        ".phx-submit-loading &",
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-change-loading", [
        ".phx-change-loading&",
        ".phx-change-loading &",
      ])
    ),
    require("daisyui"),
  ],
};
