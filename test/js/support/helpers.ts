import process from "process";

const baseUrl = process.env.SERVER_URL_HTTPS_TEST;

export function urlBuild(url: string) {
  return baseUrl + url;
}
