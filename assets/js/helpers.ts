export function alpineExpressionIsObject(expression: string) {
  return /^{.*}$/.test(expression);
}
