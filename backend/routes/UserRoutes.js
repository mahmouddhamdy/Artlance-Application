import express from "express";

import {
  getProfile,
  updateProfile,
  sendVerification,
  verifyUser,
  sendReset,
  resetPassword,
} from "../controllers/UserController.js";
import errorHandler from "../middlewares/errorHandler.js";
import authHandler from "../middlewares/authHandler.js";

const UserRouter = express.Router();

UserRouter.route("/me").get(authHandler, getProfile, errorHandler);
UserRouter.route("/me").patch(authHandler, updateProfile, errorHandler);
UserRouter.route("/send-verify").post(sendVerification, errorHandler);
UserRouter.route("/verify").post(verifyUser, errorHandler);
UserRouter.route("/send-reset").post(sendReset, errorHandler);
UserRouter.route("/reset").post(resetPassword, errorHandler);


export default UserRouter;
