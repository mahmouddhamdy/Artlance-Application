import express from "express";
import { createChat, sendMessage, getChat, getAllChats } from "../controllers/ChatController.js";
import authHandler from "../middlewares/authHandler.js";
import errorHandler from "../middlewares/errorHandler.js";

const ChatRouter = express.Router();

ChatRouter.route('/create').post(authHandler, createChat, errorHandler);
ChatRouter.route('/message').post(authHandler, sendMessage, errorHandler);
ChatRouter.route('/:id').get(authHandler, getChat, errorHandler);
ChatRouter.route('/').get(authHandler, getAllChats, errorHandler);

export default ChatRouter;
