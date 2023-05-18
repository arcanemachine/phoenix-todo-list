import {
  data as baseData,
  directives as baseDirectives,
  stores as baseStores,
} from "js/base/alpine";
import { data as todosData } from "js/todos/alpine";

// export generic alpine types
export type AlpineComponent = any;
export type AlpineInstance = any;
export type AlpineStore = any;

export const data: Array<any> = [...baseData, ...todosData];
export const directives: Array<any> = [...baseDirectives];
export const stores: Array<Record<string, any>> = [...baseStores];
