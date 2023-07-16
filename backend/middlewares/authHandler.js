import { verifyToken } from "../utils/jwt.js";
import errorHandler from "./errorHandler.js";
import { errorEnum } from "../constants/errorCodes.js";
import AppError from "../constants/AppError.js";
import { tokenTypes } from "../constants/jwt.js";

const { AUTH_REQUIRED, INVALID_AUTH } = errorEnum

export default function authHandler(req, res, next){
  const bearerHeader = req.headers.authorization;

  if (!bearerHeader) return errorHandler(new AppError(AUTH_REQUIRED), req, res, next)

  const bearer = bearerHeader.split(' ');
  const bearerToken = bearer[1];
  const result = verifyToken(bearerToken, tokenTypes.ACCESS);

  if (result instanceof Error) return errorHandler(new AppError(INVALID_AUTH), req, res, next);
  req.user = result;

  next();
};
