import express from "express";

import {
    addPortfolioItem,
    removePortfolioItem,
    getAllPortfolioItems
} from "../controllers/PortfolioItemController.js";
import errorHandler from "../middlewares/errorHandler.js";
import authHandler from "../middlewares/authHandler.js";

const PortfolioItemRouter = express.Router();

PortfolioItemRouter.route("/").post(authHandler, addPortfolioItem, errorHandler);
PortfolioItemRouter.route("/:id").delete(authHandler, removePortfolioItem, errorHandler);
PortfolioItemRouter.route("/:id").get(authHandler, getAllPortfolioItems, errorHandler);

export default PortfolioItemRouter;
