import { check } from "k6";
import { parseHTML } from "k6/html";
import http from "k6/http";

function csrfTokenGet(response) {
  // if no response passed in, get a response by making a generic GET request
  if (!response) {
    response = http.get(__ENV.BASE_URL);
  }

  // get the CSRF token by parsing the <head> tag
  const doc = parseHTML(response.body);
  const csrfToken = doc
    .find("head meta")
    .toArray()
    .filter((tag) => tag.attr("name") === "csrf-token")[0]
    .attr("content");

  return csrfToken;
}

export default function () {
  const url = `${__ENV.BASE_URL}/users/login`;
  const urlSuccess = `${__ENV.BASE_URL}/todos/live`;

  console.log(`Using login URL '${url}'...`);

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

  // submit GET request to base URL so we can get a session cookie + CSRF token
  let response = http.get(url);
  check(response, {
    "status is 200": (res) => res.status === 200,
  });

  // get CSRF token
  const csrfToken = csrfTokenGet(response);

  // post successful login form data
  response = http.post(url, {
    _csrf_token: csrfToken,
    "user[email]": email,
    "user[password]": password,
    "user[remember_me]": "false",
  });

  // response returns expected result
  const allTestsDidPass = check(response, {
    "redirects to different URL after successful login": (res) =>
      res.url === urlSuccess,
  });

  // error handling
  if (!allTestsDidPass) {
    throw `\x1b[91m*** Could not authenticate user. Has this user been registered? ***\x1b[39m`;
  }
}
