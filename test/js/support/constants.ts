import process from "process";

export const baseUrl = process.env.SERVER_URL_HTTP_TEST;

export const urls = {
  base: {
    index: new URL(baseUrl + "/"),
  },
  accounts: {
    delete: new URL(baseUrl + "/users/profile/delete"),
    login: new URL(baseUrl + "/users/login"),
    logout: new URL(baseUrl + "/users/logout"),
    register: new URL(baseUrl + "/users/register"),
    profile: new URL(baseUrl + "/users/profile"),
    update: new URL(baseUrl + "/users/profile/update"),
    updateEmail: new URL(baseUrl + "/users/profile/update/email"),
    updatePassword: new URL(baseUrl + "/users/profile/update/password"),
  },
  todos: {
    todosLive: new URL(baseUrl + "/todos/live"),
  },
};

export const phoenix = {
  sessionValidityDuration: 1000 * 60 * 60 * 24 * 60, // 60 days
};

export const emailInvalid = "emailInvalid";

export const errors = {
  email: {
    isTaken: "This email address is already in use.",
    isInvalid: "This is not a valid email address.",
  },
  password: {
    isTooShort: "Must have 8 or more character(s)",
  },
  passwordConfirmation: {
    doesNotMatch: "The passwords do not match.",
  },
};

export const testUserEmail = "test_user@example.com";
export const passwordInvalid = "passwordInvalid";
export const passwordValid = "passwordValid";
