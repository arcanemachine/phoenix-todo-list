import { check } from "k6";
import { parseHTML } from "k6/html";
import http from "k6/http";

import login from "./login.js";

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
  const url = `${__ENV.BASE_URL}/todos`;

  // setup
  login();

  // make request
  const csrfToken = csrfTokenGet();
  const response = http.post(url, {
    _csrf_token: csrfToken,
    "todo[content]": new Date().toISOString(),
    "todo[is_completed]": Math.random() < 0.5, // random boolean
  });

  // response returns expected result
  const allTestsDidPass = check(response, {
    "redirects to new URL": (res) => res.url !== url,
  });

  if (!allTestsDidPass) console.log(`\x1b[91m${response.body}\x1b[39m`);
}
