import express from "express";

import {
  validate
} from "../controllers/DataController.js";
import errorHandler from "../middlewares/errorHandler.js";

const DataRouter = express.Router();

DataRouter.route("/validate").post(validate, errorHandler);

export default DataRouter;
