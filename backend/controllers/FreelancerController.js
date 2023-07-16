import { default as Freelancer } from "../mongodb/models/Freelancer.js";
import { default as Client } from "../mongodb/models/Client.js";
import { default as Otp } from "../mongodb/models/Otp.js";
import { default as BookingOrder } from "../mongodb/models/BookingOrder.js";
import CreateUserInfoService from "../services/CreateUserInfoService.js";
import CreateFreelancerInfoService from "../services/CreateFreelancerInfoService.js";
import { errorEnum, httpResponseCodes } from "../constants/errorCodes.js";
import AppError from "../constants/AppError.js";
import GetCity from "../services/GetCity.js";
import SendVerificationEmail from "../services/SendVerificationEmail.js";
import { isValidObjectId } from "mongoose";
import { bookingOrderStates } from "../constants/models.js";

const { PENDING, IN_PROGRESS, REFUSED } = bookingOrderStates;
const { USERNAME_EXIST, EMAIL_EXIST, INVALID_ID, NO_PENDING_ORDER } = errorEnum;
const { CREATED, NOT_FOUND, OK, NO_CONTENT, FORBIDDEN } = httpResponseCodes;

const createFreelancer = async (req, res, next) => {
  try {
    // Get user input
    const {
      username,
      profilePic,
      fullName,
      email,
      password,
      freelancerType,
      address,
      phoneNum,
      hourlyRate,
      description,
    } = req.body;

    // Validate user input
    const validUserInfo = CreateUserInfoService({
      username,
      profilePic,
      fullName,
      email,
      password,
    });

    // Validate user input
    const validFreelancerInfo = CreateFreelancerInfoService({
      freelancerType,
      address,
      phoneNum,
      hourlyRate,
      description,
    });

    // Check if user already exist
    const isFreelancerUsernameExists = await Freelancer.findOne({ username: validUserInfo.username });
    const isClientUsernameExists = await Client.findOne({ username: validUserInfo.username });
    const isFreelancerEmailExists = await Freelancer.findOne({ email: validUserInfo.email });
    const isClientEmailExists = await Client.findOne({ email: validUserInfo.email });

    if (isFreelancerUsernameExists || isClientUsernameExists)
      throw new AppError(USERNAME_EXIST);
    if (isFreelancerEmailExists || isClientEmailExists)
      throw new AppError(EMAIL_EXIST);

    // Get User State
    const result = await GetCity(...validFreelancerInfo.address);

    const newFreelancerInfo = {
      ...validUserInfo,
      ...validFreelancerInfo,
      address: {
        name: result instanceof AppError || !result.address.state ? "Egypt" : result.address.state,
        location: {
          coordinates: result instanceof AppError ? [30.033333, 31.233334] : validFreelancerInfo.address,
        },
      },
    };

    // Create freelancer in our database
    const newFreelancer = await Freelancer.create(newFreelancerInfo);

    // Send verification email
    const otp = await SendVerificationEmail(validUserInfo.email);

    await Otp.create({
      _userId: newFreelancer._id,
      otp,
      docModel: "Freelancer"
    });

    return res.status(CREATED).json({});
  } catch (err) {
    return next(err);
  }
};

const getFreelancer = async (req, res, next) => {
  try {
    if (!req.user) return res;
    
    // Get freelancer ID
    const id = req.params.id;

    // Check if id is valid
    if(!isValidObjectId(id)) throw new AppError(INVALID_ID);

    // Get freelancer data
    const freelancerData = await Freelancer.findById(id, {
      _id: false,
      __v: false,
      password: false,
    }).exec();

    // Check if found freelancer
    if (!freelancerData) return res.status(NOT_FOUND).json({});

    // Gather all freelancer info
    const allData = {
      ...freelancerData.toJSON(),
    };

    return res.status(OK).json(allData);
  } catch (err) {
    return next(err);
  }
};

const acceptBookingOrder = async (req, res, next) => {
  try {
    if (!req.user) return res;

    const { id: userId } = req.user;

    const isFreelancer = await Freelancer.findById(userId);
    const isClient = await Client.findById(userId);

    if (isClient) return res.status(FORBIDDEN).json({});
    if (!isFreelancer) return res.status(NOT_FOUND).json({});

    const { from } = req.body;

     // Check if id is valid
     if (!isValidObjectId(from)) throw new AppError(INVALID_ID);

     // Check if id valid
     const isClientExists = await Client.findById(from);
 
     if (!isClientExists) return res.status(NOT_FOUND).json({});

     const hasPendingOrder = await BookingOrder.findOne({ from, to: isFreelancer._id, state: PENDING });

     if(!hasPendingOrder) throw new AppError(NO_PENDING_ORDER);

    await BookingOrder.findByIdAndUpdate(hasPendingOrder._id, {
      state: IN_PROGRESS
    })

    return res.status(NO_CONTENT).send();
  } catch (err) {
    return next(err);
  }
};

const refuseBookingOrder = async (req, res, next) => {
  try {
    if (!req.user) return res;

    const { id: userId } = req.user;

    const isFreelancer = await Freelancer.findById(userId);
    const isClient = await Client.findById(userId);

    if (isClient) return res.status(FORBIDDEN).json({});
    if (!isFreelancer) return res.status(NOT_FOUND).json({});

    const { from } = req.body;

     // Check if id is valid
     if (!isValidObjectId(from)) throw new AppError(INVALID_ID);

     // Check if id valid
     const isClientExists = await Client.findById(from);
 
     if (!isClientExists) return res.status(NOT_FOUND).json({});

     const hasPendingOrder = await BookingOrder.findOne({ from, to: isFreelancer._id, state: PENDING });

     if(!hasPendingOrder) throw new AppError(NO_PENDING_ORDER);

    await BookingOrder.findByIdAndUpdate(hasPendingOrder._id, {
      state: REFUSED
    })

    return res.status(NO_CONTENT).send();
  } catch (err) {
    return next(err);
  }
};

const getAllBookingOrders = async (req, res, next) => {
  try {
    if (!req.user) return res;

    const { id: userId } = req.user;

    const isFreelancer = await Freelancer.findById(userId);
    const isClient = await Client.findById(userId);

    if (isClient) return res.status(FORBIDDEN).json({});
    if (!isFreelancer) return res.status(NOT_FOUND).json({});

     const orders = await BookingOrder.find({ to: isFreelancer._id }, {
      __v: false,
      to: false
     });

    return res.status(OK).json(orders);
  } catch (err) {
    return next(err);
  }
};

export { createFreelancer, getFreelancer, acceptBookingOrder, refuseBookingOrder, getAllBookingOrders };
