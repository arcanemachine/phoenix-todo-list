import { randomUUID } from "crypto";

export function emailGenerateRandom() {
  return `${randomUUID()}@example.com`;
}
