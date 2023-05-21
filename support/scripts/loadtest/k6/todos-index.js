import http from "k6/http";

import login from "./login.js";

export default function () {
  login();

  const url = `${__ENV.BASE_URL}/todos`;
  const response = http.get(url);

  console.log(response.body);
}
