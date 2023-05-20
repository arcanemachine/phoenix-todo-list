import { check } from "k6";
import http from "k6/http";
import { parseHTML } from "k6/html";

const urlLogin = `${__ENV.URL}/users/login`;
const urlLoginSuccess = `${__ENV.URL}/todos/live`;

export default function () {
  console.log(`\x1b[96mUsing login URL '${urlLogin}'...\x1b[39m`);

  const email = __ENV.EMAIL || "user@example.com";
  console.log(`\x1b[96mUsing email '${email}'...\x1b[39m`);
  if (!__ENV.EMAIL)
    console.log(
      "To set a custom email address, set the 'EMAIL' environment variable."
    );

  const password = __ENV.PASSWORD || "password";
  console.log(`\x1b[96mUsing password '${password}'...\x1b[39m`);
  if (!__ENV.PASSWORD)
    console.log(
      "To set a custom password, set the 'PASSWORD' environment variable."
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

  // FIXME: render the response
  console.log(response.request.body);

  check(response, {
    "redirects to expected URL": (res) => res.url === urlLoginSuccess,
  });
}
