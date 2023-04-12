import process from "process";

const baseUrl = process.env.SERVER_URL_HTTPS_TEST;

export enum ConsoleColors {
  // colors
  Default = "default",
  Gray = "gray",
  Cyan = "cyan",
  Green = "green",
  Yellow = "yellow",
  Red = "red",

  // themes
  Primary = "primary",
  Secondary = "secondary",
  Info = "info",
  Success = "success",
  Warning = "warning",
  Error = "error",
}

export function textColorize(
  content: string,
  color: ConsoleColors | string = ConsoleColors.Info,
  bold: boolean = false
) {
  /** Return a string of text with ANSI formatting escape codes. */
  let colorCode = "\x1b["; // sequence begins the escape code
  const colorResetCode = "\x1b[0m"; // resets terminal text to default color

  // parse color code from specified color
  switch (color) {
    case ConsoleColors.Default:
    case ConsoleColors.Primary:
      colorCode += "39";
      break;
    case ConsoleColors.Gray:
    case ConsoleColors.Secondary:
      colorCode += "90";
      break;
    case ConsoleColors.Cyan:
    case ConsoleColors.Info:
      colorCode += "96";
      break;
    case ConsoleColors.Green:
    case ConsoleColors.Success:
      colorCode += "92";
      break;
    case ConsoleColors.Yellow:
    case ConsoleColors.Warning:
      colorCode += "93";
      break;
    case ConsoleColors.Red:
    case ConsoleColors.Error:
      colorCode += "91";
      break;
    default:
      throw (
        `Invalid color parameter received (${color}). Must be one of: ` +
        "default, gray, cyan, green, success, yellow, red, " +
        "primary, secondary, info, success, warning, error"
      );
  }

  if (bold) colorCode += ";1"; // append bold formatting
  colorCode += "m"; // append the letter 'm' to complete the code

  // prepend format data and append
  content = `${colorCode}${content}${colorResetCode}`;

  return content;
}

export function urlBuild(url: string) {
  return baseUrl + url;
}
