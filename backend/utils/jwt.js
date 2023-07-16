import jwt from "jsonwebtoken";
import * as dotenv from "dotenv";
import { tokenTypes } from "../constants/jwt.js";

dotenv.config();

const { ACCESS, REFRESH } = tokenTypes;
const { sign, verify } = jwt;
const { ACCESS_JWT_KEY, REFRESH_JWT_KEY, PUBLIC_JWT_KEY } = process.env;

const getTokenKey = (tokenType) => {
  switch (tokenType) {
    case ACCESS:
      return ACCESS_JWT_KEY;
    case REFRESH:
      return REFRESH_JWT_KEY;
    default:
      return PUBLIC_JWT_KEY;
  }
};

const getTokenExpiry = (tokenType) => {
  switch (tokenType) {
    case ACCESS:
      return 60 * 60;
    case REFRESH:
      return 60 * 60 * 2;
    default:
      return 60 * 60 * 0.5;
  }
}

export function createToken(body, tokenType) {
  const key = getTokenKey(tokenType);
  const token = sign(body, key, { expiresIn: getTokenExpiry(tokenType) });
  return token;
}

export function verifyToken(token, tokenType) {
  const key = getTokenKey(tokenType);
  return verify(token, key, (err, body) => (err ? err : body));
}
