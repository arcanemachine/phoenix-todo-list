import helpers from "./helpers";

// assign default theme
if (helpers.darkModeEnabled) {
  document.querySelector("html").dataset.theme = "dark";
  document.documentElement.classList.add("dark");
}
