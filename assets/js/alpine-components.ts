const alpineComponents = {
  helloWorld() {
    return {
      message: "Hello World!",
    };
  },
  // let lightModeToggled: boolean;
  // let darkModePreference = window.matchMedia("(prefers-color-scheme: dark)");

  // init(() => {
  //   const savedDarkModePreferenceExists = localStorage.getItem("darkMode") !== null;

  //   // get initial dark mode setting in order: saved setting, browser settings
  //   if (savedDarkModePreferenceExists)
  //     lightModeToggled = !Boolean(JSON.parse(localStorage.getItem("darkMode") || ""));
  //   else lightModeToggled = !darkModePreference.matches; // use browser preference

  //   lightModeToggled ? darkModeDisable(false) : darkModeEnable(false); // set initial theme

  //   // watch for changes to dark mode preference
  //   darkModePreference.addEventListener("change", (evt) => {
  //     // only change if no preference has been assigned manually
  //     if (!savedDarkModePreferenceExists) {
  //       evt.matches ? darkModeEnable(false) : darkModeDisable(false);
  //     }
  //   });
  // });

  // function darkModeEnable(updateLocalStorage: boolean) {
  //   lightModeToggled = false;
  //   updateLocalStorage && localStorage.setItem("darkMode", "1"); // save data to localStorage
  //   document!.querySelector("html")!.dataset.theme = "luxury"; // set the theme
  // }

  // function darkModeDisable(updateLocalStorage: boolean) {
  //   lightModeToggled = true;
  //   updateLocalStorage && localStorage.setItem("darkMode", "0"); // save data to localStorage
  //   document!.querySelector("html")!.removeAttribute("data-theme"); // remove theme data attribute
  // }

  // function darkModeToggle() {
  //   if (lightModeToggled) darkModeEnable(true);
  //   else darkModeDisable(true);
  // }
};

export default alpineComponents;
