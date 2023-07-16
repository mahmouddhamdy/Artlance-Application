import express from "express";

import {
  login,
  refreshToken,
} from "../controllers/AuthController.js";
import errorHandler from "../middlewares/errorHandler.js";

const AuthRouter = express.Router();

AuthRouter.route("/create").post(login, errorHandler);
AuthRouter.route("/refresh").post(refreshToken, errorHandler);

export default AuthRouter;
