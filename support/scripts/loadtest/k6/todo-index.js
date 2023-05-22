import http from "k6/http";

import login from "./login.js";

export default function () {
  const url = `${__ENV.BASE_URL}/todos`;

  // setup
  login();

  // make request
  const response = http.get(url);

  // response returns expected result
  check(response, {
    "status is 200": (res) => res.status === 200,
  });
}
