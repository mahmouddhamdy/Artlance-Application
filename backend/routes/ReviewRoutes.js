import express from "express";
import { createReview, updateReview, removeReview, getAllReviews }from "../controllers/ReviewController.js";
import authHandler from "../middlewares/authHandler.js";
import errorHandler from "../middlewares/errorHandler.js";

const ReviewRouter = express.Router();

ReviewRouter.route("/").post(authHandler, createReview, errorHandler);
ReviewRouter.route("/:id").patch(authHandler, updateReview, errorHandler);
ReviewRouter.route("/:id").delete(authHandler, removeReview, errorHandler);
ReviewRouter.route("/:id").get(authHandler, getAllReviews, errorHandler);

export default ReviewRouter;
