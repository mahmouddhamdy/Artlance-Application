import express from "express";
import {
  explore,
  getTopPicks,
} from "../controllers/HomeController.js";
import errorHandler from "../middlewares/errorHandler.js";
import authHandler from "../middlewares/authHandler.js"

const HomeRouter = express.Router();

HomeRouter.route("/explore").get(authHandler, explore, errorHandler);
HomeRouter.route("/top-picks").get(authHandler, getTopPicks, errorHandler);

export default HomeRouter;
