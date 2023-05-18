import Alpine from "alpinejs";
import collapse from "@alpinejs/collapse";
import focus from "@alpinejs/focus";
import {
  data as alpineData,
  directives as alpineDirectives,
  stores as alpineStores,
} from "js/alpine";

export default function initAlpine() {
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

  Alpine.start();
  return Alpine;
}
