export function alpineExpressionIsObject(expression: string) {
  /** If expression can be evaluated as an object, return true. */
  return /^{.*}$/.test(expression);
}
