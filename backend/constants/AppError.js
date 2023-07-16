import { errorCodes } from "./errorCodes.js";

class AppError extends Error {
  constructor(message) {
    super(errorCodes[message].message);
    this.name = "AppError";
    this.statusCode = errorCodes[message].statusCode;
  }
}

export default AppError;