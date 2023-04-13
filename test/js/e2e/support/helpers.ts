import { randomUUID } from "crypto";

export function emailGenerateRandom() {
  return `${randomUUID()}@example.com`;
}

// export function emailGenerateForTestUser(id: number) {
//   return `test_user_${id}@example.com`;
// }
