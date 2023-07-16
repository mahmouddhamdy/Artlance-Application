import express from "express";

import {
  createClient,
  getClient,
  addToVisitList,
  addToFavList,
  removeFromFavList,
  searchFreelancers,
  searchPortfolioItems,
  createBookingOrder,
  completeBookingOrder,
  getAllBookingOrders
} from "../controllers/ClientController.js";
import errorHandler from "../middlewares/errorHandler.js";
import authHandler from "../middlewares/authHandler.js";

const ClientRouter = express.Router();

ClientRouter.route("/").post(createClient, errorHandler);
ClientRouter.route("/search/freelancers").get(authHandler, searchFreelancers, errorHandler);
ClientRouter.route("/search/images").get(authHandler, searchPortfolioItems, errorHandler);
ClientRouter.route("/:id").get(authHandler, getClient, errorHandler);
ClientRouter.route("/visit").post(authHandler, addToVisitList, errorHandler);
ClientRouter.route("/fav").post(authHandler, addToFavList, errorHandler);
ClientRouter.route("/fav/:id").delete(authHandler, removeFromFavList, errorHandler);
ClientRouter.route("/orders/create").post(authHandler, createBookingOrder, errorHandler);
ClientRouter.route("/orders/complete").post(authHandler, completeBookingOrder, errorHandler);
ClientRouter.route("/orders/me").get(authHandler, getAllBookingOrders, errorHandler);

export default ClientRouter;
