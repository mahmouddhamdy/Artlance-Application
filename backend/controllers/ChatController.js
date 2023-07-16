import { default as Client } from "../mongodb/models/Client.js";
import { default as Freelancer } from "../mongodb/models/Freelancer.js";
import { default as Chat } from '../mongodb/models/Chat.js';
import { default as Message } from '../mongodb/models/Message.js';
import { isValidObjectId } from 'mongoose';
import AppError from "../constants/AppError.js";
import { httpResponseCodes, errorEnum } from "../constants/errorCodes.js";
import { userTypes } from "../constants/models.js";

const { INVALID_ID, CLIENT_TALK_CLIENT, CHAT_EXIST, NO_CHAT } = errorEnum;
const { CREATED, NOT_FOUND, OK, FORBIDDEN } = httpResponseCodes;

const createChat = async (req, res, next) => {
  try {
    if (!req.user) return res;

    const { id: userId } = req.user;

    const isFreelancer = await Freelancer.findById(userId);
    const isClient = await Client.findById(userId);

    if (isFreelancer) return res.status(FORBIDDEN).json({});
    if (!isClient) return res.status(NOT_FOUND).json({});

    const { id } = req.body;

    if (!isValidObjectId(id)) throw new AppError(INVALID_ID);

    const isReceiverFreelancer = await Freelancer.findById(id);
    const isReceiverClient = await Client.findById(id);

    if (isReceiverClient) throw new AppError(CLIENT_TALK_CLIENT);
    if (!isReceiverFreelancer) return res.status(NOT_FOUND).json({});
    
    const isChatExist = await Chat.findOne({ client: userId, freelancer: id });

    if (isChatExist) throw new AppError(CHAT_EXIST);

    await Chat.create({ client: userId, freelancer: id });

    res.status(CREATED).json({});
  } catch (err) {
    return next(err);
  }
};

const sendMessage = async (req, res, next) => {
  try {
    if (!req.user) return res;

    const { id: userId } = req.user;

    const isFreelancer = await Freelancer.findById(userId);
    const isClient = await Client.findById(userId);

    const userInfo = isFreelancer || isClient;

    const { to, content } = req.body;

    if (!isValidObjectId(to)) throw new AppError(INVALID_ID);

    const isChatExist = await Chat.findOne({
      $or: [
        { client: userId, freelancer: to },
        { client: to, freelancer: userId }
      ]
    });

    if (!isChatExist) throw new AppError(NO_CHAT);

    const message = await Message.create({
        from: userId,
        to,
        fromModel: userInfo.userType === userTypes.CLIENT ? 'Client' : 'Freelancer',
        toModel: userInfo.userType === userTypes.CLIENT ? 'Freelancer' : 'Client',
        content
    });
    
    isChatExist.messages.push(message._id);
    await isChatExist.save();

    return res.status(CREATED).json({});
  } catch (err) {
    return next(err);
  }
};

const getChat = async (req, res, next) => {
  try {
    if (!req.user) return res;

    const { id: userId } = req.user;

    const id = req.params.id;

    if (!isValidObjectId(id)) throw new AppError(INVALID_ID);

    const isChatExist = await Chat.findOne({
      $or: [
        { client: userId, freelancer: id },
        { client: id, freelancer: userId }
      ]
    }, { __v: false }).populate({
        path: 'messages',
        select: 'from to content date'
    });

    if (!isChatExist) throw new AppError(NO_CHAT);
    
    return res.status(OK).json(isChatExist);
  } catch (err) {
    return next(err);
  }
};

const getAllChats = async (req, res, next) => {
    try {
      if (!req.user) return res;
  
      const { id: userId } = req.user;
  
      const chats = await Chat.find({
        $or: [{ client: userId, messages: { $gt: [] }}, { freelancer: userId, messages: { $gt: [] }}]
      });

      const filteredChats = chats.map(({ client, freelancer }) => client.toString() === userId ? freelancer : client);
  
      return res.status(OK).json(filteredChats);
    } catch (err) {
      return next(err);
    }
  };

export { createChat, sendMessage, getChat, getAllChats };
