import {
  data as baseData,
  directives as baseDirectives,
  stores as baseStores,
} from "./base/alpine";
import { data as todosData } from "./todos/alpine";

export const data = [...baseData, ...todosData];
export const directives = [...baseDirectives];
export const stores: Array<object> = [...baseStores];
