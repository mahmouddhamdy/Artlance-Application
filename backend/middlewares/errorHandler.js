import { httpResponseCodes } from "../constants/errorCodes.js";
import AppError from "../constants/AppError.js";

export default function errorHandler(err, req, res, next) {
  //console.log(err);
  const statusCode =
    err instanceof AppError
      ? err.statusCode
      : httpResponseCodes.INTERNAL_SERVER_ERROR;
  res.status(statusCode).json({ message: err.message });
  next();
}
