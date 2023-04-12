export const urls = {
  base: {
    index: "/",
  },
  accounts: {
    delete: "/users/profile/delete",
    login: "/users/login",
    logout: "/users/logout",
    register: "/users/register",
    profile: "/users/profile",
    update: "/users/profile/update",
    updateEmail: "/users/profile/update/email",
    updatePassword: "/users/profile/update/password",
  },
  todos: {
    todosLive: "/todos/live",
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
export const passwordValid = "passwordValid";
