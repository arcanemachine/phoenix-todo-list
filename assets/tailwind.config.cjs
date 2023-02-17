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
          primary: "#0D6EFD",
          secondary: "#5E656C",
          accent: "#0254CE",
          neutral: "#01265E",
          "base-100": "#F6F6FF",
          info: "#97C0FE",
          success: "#198754",
          warning: "#FFC107",
          error: "#DC3545",
        },
        dark: {
          primary: "#1C4E80",
          secondary: "#697D88",
          accent: "#682DF4",
          neutral: "#23282E",
          "base-100": "#202020",
          // info: "#0091D5",
          // success: "#6BB187",
          // warning: "#DBAE59",
          // error: "#AC3E31",
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
