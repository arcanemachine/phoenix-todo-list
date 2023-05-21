import http from "k6/http";

export default function () {
  const url = `${__ENV.BASE_URL}/todos`;

  http.get(url);
}
