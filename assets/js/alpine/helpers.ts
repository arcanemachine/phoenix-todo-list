const helpers = {
  get darkModeSavedPreferenceExists() {
    return localStorage.getItem("darkModeEnabled") !== null;
  },
};

export default helpers;
