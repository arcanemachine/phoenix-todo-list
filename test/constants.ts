export const urls = {
  users: {
    register: "/users/register",
    login: "/users/login",
    logout: "/users/logout",
    profile: "/users/profile",
    update: "/users/profile/update",
    updateEmail: "/users/profile/update/email",
    updatePassword: "/users/profile/update/password",
    delete: "/users/profile/delete",
  },
};

export const phoenix = {
  sessionValidityDuration: 1000 * 60 * 60 * 24 * 60, // 60 days
};

export const testUserEmail = "test_user@example.com";
export const validPassword = "valid_password";
