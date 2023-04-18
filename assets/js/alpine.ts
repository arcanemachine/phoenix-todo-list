import {
  data as baseData,
  directives as baseDirectives,
  stores as baseStores,
} from "./base/alpine";
import { data as todosData } from "js/todos/alpine";

// convert alpine component namespace to type and export it
import type { AlpineComponent as AlpineComponentNS } from "alpinejs";
export type AlpineComponent = typeof AlpineComponentNS;

export const data = [...baseData, ...todosData];
export const directives = [...baseDirectives];
export const stores: Array<object> = [...baseStores];
