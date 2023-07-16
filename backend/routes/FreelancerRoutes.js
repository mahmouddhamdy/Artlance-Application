import express from "express";

import {
  createFreelancer,
  getFreelancer,
  acceptBookingOrder,
  refuseBookingOrder,
  getAllBookingOrders
} from "../controllers/FreelancerController.js";
import errorHandler from "../middlewares/errorHandler.js";
import authHandler from "../middlewares/authHandler.js";

const FreelancerRouter = express.Router();

FreelancerRouter.route("/").post(createFreelancer, errorHandler);
FreelancerRouter.route("/:id").get(authHandler, getFreelancer, errorHandler);
FreelancerRouter.route("/orders/accept").post(authHandler, acceptBookingOrder, errorHandler);
FreelancerRouter.route("/orders/refuse").post(authHandler, refuseBookingOrder, errorHandler);
FreelancerRouter.route("/orders/me").get(authHandler, getAllBookingOrders, errorHandler);

export default FreelancerRouter;
