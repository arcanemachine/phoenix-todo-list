import { check } from "k6";
import http from "k6/http";
import { parseHTML } from "k6/html";

export default function () {
  const baseUrl = __ENV.BASE_URL || "https://${PHX_HOST}";
  const urlLogin = `${baseUrl}/users/login`;
  const urlLoginSuccess = `${baseUrl}/todos/live`;

  console.log(`Using login URL '${urlLogin}'...`);

  const email = __ENV.EMAIL || "user@example.com";
  console.log(`Using email '${email}'...`);
  if (!__ENV.EMAIL)
    console.log(
      "\x1b[96mTo use a custom email address, set the 'EMAIL' environment variable.\x1b[39m"
    );

  const password = __ENV.PASSWORD || "password";
  console.log(`Using password '${password}'...`);
  if (!__ENV.PASSWORD)
    console.log(
      "\x1b[96mTo use a custom password, set the 'PASSWORD' environment variable.\x1b[39m"
    );

  // submit GET request to loginUrl so we can get a session cookie and
  // CSRF token
  let response = http.get(urlLogin);
  check(response, {
    "status is 200": (res) => res.status === 200,
  });

  // parse the CSRF token from the <head> tag
  const doc = parseHTML(response.body);
  const csrfToken = doc
    .find("head meta")
    .toArray()
    .filter((tag) => tag.attr("name") === "csrf-token")[0]
    .attr("content");

  // post successful login data
  response = http.post(urlLogin, {
    _csrf_token: csrfToken,
    "user[email]": email,
    "user[password]": password,
    "user[remember_me]": "false",
  });

  check(response, {
    "redirects to expected URL": (res) => res.url === urlLoginSuccess,
  });

  if (response.url !== urlLoginSuccess) {
    console.log(
      `\x1b[91m*** Could not authenticate user. Has this user been registered? ***\x1b[39m`
    );
  }
}
