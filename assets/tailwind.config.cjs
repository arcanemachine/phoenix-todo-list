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
          primary: "#2563EB",
          secondary: "#D1D5DB",
          accent: "#8B5CF6",
          neutral: "#312E81",
          "base-100": "#F6F6FF",
          info: "#7DD3FC",
          success: "#25A762",
          warning: "#FACC15",
          error: "#DC2626",
        },
      },
      "forest",
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
