import { FullConfig } from "@playwright/test";

async function globalTeardown(config: FullConfig) {
  throw config;
  throw "Goodbye world!";
}

export default globalTeardown;
