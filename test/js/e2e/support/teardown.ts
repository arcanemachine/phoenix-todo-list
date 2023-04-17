// import { state } from "test/e2e/support/setup/global";

async function globalTeardown() {
  // // if SQL sandbox user agent was used, destroy the SQL sandbox session
  // if (state.sqlSandboxUserAgent) {
  //   await fetch(`${state.baseUrl}/sandbox`, {
  //     method: "DELETE",
  //     headers: {
  //       "user-agent": state.sqlSandboxUserAgent,
  //     },
  //   }).then((res) => {
  //     if (!res.ok)
  //       throw (
  //         "Setup (global): Could not set destroy SQL sandbox. " +
  //         "The test database may need to be cleared manually."
  //       );
  //   });
  // }
}

export default globalTeardown;
