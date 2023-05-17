import {
  data as baseData,
  directives as baseDirectives,
  stores as baseStores,
} from "./base/alpine";
import { data as todosData } from "js/todos/alpine";

// export generic alpine types
export type AlpineComponent = any;
export type AlpineStore = any;

export const data = [...baseData, ...todosData];
export const directives = [...baseDirectives];
export const stores: Array<object> = [...baseStores];
