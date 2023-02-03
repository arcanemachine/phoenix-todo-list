// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";

// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";
import Hooks from "./hooks";

// setup Alpine.JS
import Alpine from "alpinejs";
import collapse from "@alpinejs/collapse";
import focus from "@alpinejs/focus";
import {
  data as alpineData,
  directives as alpineDirectives,
  stores as alpineStores,
} from "./alpine";

// plugins
Alpine.plugin(collapse);
Alpine.plugin(focus);

for (const data of alpineData) {
  Alpine.data(data.name, data.data);
}

for (const directive of alpineDirectives) {
  Alpine.directive(directive.name, directive.directive);
}

for (const store of alpineStores) {
  Alpine.store(store.name, store.store);
}

window.Alpine = Alpine;
Alpine.start();

// setup LiveView
let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  dom: {
    onBeforeElUpdated(from, to) {
      // if (from._x_dataStack) {
      //   Alpine.clone(from, to);
      // }

      const liveSocketInitializeAlpine = (from, to) => {
        if (!Alpine || !from || !to) return;

        for (let index = 0; index < to.children.length; index++) {
          const from2 = from.children[index];
          const to2 = to.children[index];

          if (from2 instanceof HTMLElement && to2 instanceof HTMLElement) {
            liveSocketInitializeAlpine.call(from2, to2);
          }
        }

        if (from._x_dataStack) Alpine.clone(from, to);
      };

      liveSocketInitializeAlpine(from, to);
    },
  },
  params: { _csrf_token: csrfToken },
  hooks: Hooks,
});

Alpine.store("liveSocket", liveSocket); // add alpine store for livesocket

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", () =>
  topbar.delayedShow(200)
);
window.addEventListener("phx:page-loading-stop", () => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// liveSocket.enableDebug()
// liveSocket.enableLatencySim(1500); // enabled for duration of browser session
// liveSocket.disableLatencySim()
window.liveSocket = liveSocket;

// any logic that shouldn't be committed to source control should be placed in
// '/assets/js/gitignore.ts' e.g. debugging logic, livesocket latency
// configuration, etc.
(() => {
  try {
    return import("./gitignore.js");
  } catch (err) {}
})();

// var canHover = !matchMedia("(hover: none)").matches;
// alert(canHover);
