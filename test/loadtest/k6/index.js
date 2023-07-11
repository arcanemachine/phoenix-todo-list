import { check } from "k6";
import http from "k6/http";

export default function () {
  const url = __ENV.BASE_URL || `https://${__ENV.PHX_HOST}/`;

  const response = http.get(url);
  check(response, {
    "status is 200": (res) => res.status === 200,
  });
}
