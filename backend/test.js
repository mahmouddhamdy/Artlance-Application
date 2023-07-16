import Chat from './mongodb/models/chat.js';
import Message from './mongodb/models/Message.js';
import AppError from './constants/AppError.js';
import { default as Client } from "./mongodb/models/Client.js";
import { default as Freelancer } from "./mongodb/models/Freelancer.js";

const createChat = async (to, senderId) => {
  try {
    const isf = await Freelancer.findById(senderId);
    const isc = await Client.findById(senderId);
    const irf = await Freelancer.findById(to);
    const irc = await Client.findById(to);

    if (isf) throw new Error("freelancer cant start chat");

    // Check if receiver is a client and sender is a client
    if (irc && isc) {
      throw new Error("clients cant talk to each other.");
    }

    // Check if sender is a freelancer and receiver is a freelancer
    if (irf && isf) {
      throw new Error("freelancers cnat talk to other freelancers");
    }
    
    const existingChat = await Chat.findOne({
      sender: senderId,
      receiver: to
    })
      .populate({
        path: 'messages',
        select: 'sender receiver content timestamp',
        populate: {
          path: 'sender',
          select: 'username',
        },
      });

    if (existingChat) {
      return existingChat.messages;
    }

    const newChat = new Chat({
      sender: senderId,
      receiver: to,
      messages: [],
    });

    await newChat.save();
    return [];
  } catch (error) {
    console.error(error);
    throw new Error('Internal Server Error');
  }
};


const addMessage = async (receiverId, content, senderId) => {
  try {
    let chat = await Chat.findOne({
      $or: [
        { sender: senderId, receiver: receiverId },
        { sender: receiverId, receiver: senderId }
      ]
    });

    if (!chat) {
      throw new Error("Chat does not exist.");
    }

    const newMessage = new Message({
      sender: senderId,
      receiver: receiverId,
      content: content,
    });

    await newMessage.save();

    chat.messages.push(newMessage._id);
    await chat.save();

    return chat;
  } catch (error) {
    console.error(error);
    throw new Error('Internal Server Error');
  }
};


const getChatMessages = async (userId) => {
  try {
    const chats = await Chat.find({
      $or: [{ sender: userId }, { receiver: userId }]
    });

    const otherParticipantIds = chats.map(chat => {
      return chat.sender === userId ? chat.receiver : chat.sender;
    });

    return otherParticipantIds;
  } catch (error) {
    console.error(error);
    throw new Error("Server error.");
  }
};

const getChatByParticipant = async (userId, participantId) => {
  try {
    const chat = await Chat.findOne({
      $or: [
        { sender: userId, receiver: participantId },
        { sender: participantId, receiver: userId }
      ]
    })
      .populate({
        path: 'messages',
        select: 'sender receiver content timestamp',
        populate: {
          path: 'sender',
          select: 'username',
        },
      });

    if (!chat) {
      console.log("Chat does not exist.");
      throw new Error("Chat does not exist.");
    }

    return chat;
  } catch (error) {
    console.error(error);
    throw new Error("Server error.");
  }
};

export { createChat, addMessage, getChatMessages, getChatByParticipant };
