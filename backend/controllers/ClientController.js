import { default as Client } from "../mongodb/models/Client.js";
import { default as Freelancer } from "../mongodb/models/Freelancer.js";
import { default as PortfolioItem } from '../mongodb/models/PortfolioItem.js';
import { default as BookingOrder } from '../mongodb/models/BookingOrder.js';
import { default as Otp } from "../mongodb/models/Otp.js";
import CreateUserInfoService from "../services/CreateUserInfoService.js";
import { errorEnum, httpResponseCodes } from "../constants/errorCodes.js";
import AppError from "../constants/AppError.js";
import { isEmpty, isNull, isString, isUrl } from "../utils/checkValidity.js";
import SendVerificationEmail from "../services/SendVerificationEmail.js";
import { isValidObjectId } from "mongoose";
import SearchPortfolioItemService from "../services/SearchPortfolioItemService.js";
import normalizePortfolioItems from "../utils/normalizePortfolioItems.js";
import { userData } from "../constants/userData.js";
import { bookingOrderStates } from "../constants/models.js";
import userDataValidator from "../utils/userDataValidator.js";

const { PENDING, IN_PROGRESS, COMPLETED } = bookingOrderStates;
const { USERNAME_EXIST, EMAIL_EXIST, INVALID_ID, FAV_EXIST, INVALID_URL, PENDING_ORDER, IN_PROGRESS_ORDER, NO_ACTIVE_ORDER } = errorEnum;
const { CREATED, NOT_FOUND, OK, FORBIDDEN, BAD_REQUEST, NO_CONTENT } = httpResponseCodes;

const createClient = async (req, res, next) => {
  try {
    // Get user input
    const { username, profilePic, fullName, email, password } = req.body;

    // Validate user input
    const validUserInfo = CreateUserInfoService({
      username,
      profilePic,
      fullName,
      email,
      password,
    });

    // Check if user already exist
    const isFreelancerUsernameExists = await Freelancer.findOne({
      username: validUserInfo.username,
    });
    const isClientUsernameExists = await Client.findOne({
      username: validUserInfo.username,
    });
    const isFreelancerEmailExists = await Freelancer.findOne({
      email: validUserInfo.email,
    });
    const isClientEmailExists = await Client.findOne({
      email: validUserInfo.email,
    });

    if (isFreelancerUsernameExists || isClientUsernameExists)
      throw new AppError(USERNAME_EXIST);
    if (isFreelancerEmailExists || isClientEmailExists)
      throw new AppError(EMAIL_EXIST);

    // Create client in our database
    const newClient = await Client.create(validUserInfo);

    // Send verification email
    const otp = await SendVerificationEmail(validUserInfo.email);

    await Otp.create({
      _userId: newClient._id,
      otp,
      docModel: "Client"
    });

    return res.status(CREATED).json({});
  } catch (err) {
    return next(err);
  }
};

const getClient = async (req, res, next) => {
  try {
    if (!req.user) return res;

    // Get client ID
    const id = req.params.id;

    // Check if id is valid
    if (!isValidObjectId(id)) throw new AppError(INVALID_ID);

    // Get client data
    const clientData = await Client.findById(id, {
      _id: false,
      __v: false,
      password: false,
    }).exec();

    // Check if found client
    if (!clientData) return res.status(NOT_FOUND).json({});

    // Gather all client info
    const allData = {
      ...clientData.toJSON(),
    };

    return res.status(OK).json(allData);
  } catch (err) {
    return next(err);
  }
};

const addToVisitList = async (req, res, next) => {
  try {
    if (!req.user) return res;

    const { id: userId } = req.user;

    const isFreelancer = await Freelancer.findById(userId);
    const isClient = await Client.findById(userId);

    if (isFreelancer) return res.status(FORBIDDEN).json({});
    if (!isClient) return res.status(NOT_FOUND).json({});

    // Get visited Freelancer id
    const { id } = req.body;

    // Check if id is valid
    if (!isValidObjectId(id)) throw new AppError(INVALID_ID);

    // Check if id valid
    const isFreelancerExists = await Freelancer.findById(id);

    if (!isFreelancerExists) return res.status(NOT_FOUND).json({});

    await Client.findByIdAndUpdate(isClient._id, { $addToSet: { visitList: id }});

    return res.status(OK).json({});
  } catch (err) {
    return next(err);
  }
};

const addToFavList = async (req, res, next) => {
  try {
    if (!req.user) return res;

    const { id: userId } = req.user;

    const isFreelancer = await Freelancer.findById(userId);
    const isClient = await Client.findById(userId);

    if (isFreelancer) return res.status(FORBIDDEN).json({});
    if (!isClient) return res.status(NOT_FOUND).json({});

    // Get Freelancer id
    const { id } = req.body;

    // Check if id is valid
    if (!isValidObjectId(id)) throw new AppError(INVALID_ID);

    // Check if id valid
    const isFreelancerExists = await Freelancer.findById(id);

    if (!isFreelancerExists) return res.status(NOT_FOUND).json({});

    if(isClient.favList.includes(id)) throw new AppError(FAV_EXIST);

    await Client.findByIdAndUpdate(isClient._id, { $addToSet: { favList: id }});

    return res.status(OK).json({});
  } catch (err) {
    return next(err);
  }
};

const removeFromFavList = async (req, res, next) => {
  try {
    if (!req.user) return res;

    const { id: userId } = req.user;

    const isFreelancer = await Freelancer.findById(userId);
    const isClient = await Client.findById(userId);

    if (isFreelancer) return res.status(FORBIDDEN).json({});
    if (!isClient) return res.status(NOT_FOUND).json({});

    // Get Freelancer id
    const id = req.params.id;

    // Check if id is valid
    if (!isValidObjectId(id)) throw new AppError(INVALID_ID);

    // Check if id valid
    const isFreelancerExists = await Freelancer.findById(id);

    if (!isFreelancerExists || !isClient.favList.includes(id)) return res.status(NOT_FOUND).json({});

    await Client.findByIdAndUpdate(isClient._id, { $pull: { favList: id }});

    return res.status(NO_CONTENT).send();
  } catch (err) {
    return next(err);
  }
};

const searchFreelancers = async (req, res, next) => {
  try {
    if (!req.user) return res;

    const { id: userId } = req.user;

    const isFreelancer = await Freelancer.findById(userId);
    const isClient = await Client.findById(userId);

    if (isFreelancer) return res.status(FORBIDDEN).json({});
    if (!isClient) return res.status(NOT_FOUND).json({});

    // Get search query
    const { query } = req.query;

    if (isNull(query) || !isString(query) || isEmpty(query))
      return res.status(BAD_REQUEST).json({});

    const regex = new RegExp(".*" + query + ".*", "i");

    // Get freelancers matching query
    const results = await Freelancer.find(
      {
        $or: [{ username: { $regex: regex } }, { fullName: { $regex: regex } }],
      }
    ).distinct('_id');

    return res.status(OK).json(results);
  } catch (err) {
    return next(err);
  }
};

const searchPortfolioItems = async (req, res, next) => {
  try {
    if (!req.user) return res;

    const { id: userId } = req.user;

    const isFreelancer = await Freelancer.findById(userId);
    const isClient = await Client.findById(userId);

    if (isFreelancer) return res.status(FORBIDDEN).json({});
    if (!isClient) return res.status(NOT_FOUND).json({});

    // Get image url
    const { url, type } = req.query;

    userDataValidator(userData.FREELANCER_TYPE, type);

    if(!isUrl(url)) throw new AppError(INVALID_URL);

    const allPortfolioItems = await PortfolioItem.find({ type }, {
      __v: false,
      owner: false,
      date: false,
      url: false
    })

    const features = normalizePortfolioItems(allPortfolioItems);
     
    const result = await SearchPortfolioItemService(url, features);

    // Create PortfolioItem in our database
    const matchingPortfolioItems = await PortfolioItem.find({
      _id: { $in: result instanceof AppError ? [] : result }
    }, {
      __v: false,
      features: false
    });

    return res.status(OK).json(matchingPortfolioItems);
  } catch (err) {
    return next(err);
  }
};

const createBookingOrder = async (req, res, next) => {
  try {
    if (!req.user) return res;

    const { id: userId } = req.user;

    const isFreelancer = await Freelancer.findById(userId);
    const isClient = await Client.findById(userId);

    if (isFreelancer) return res.status(FORBIDDEN).json({});
    if (!isClient) return res.status(NOT_FOUND).json({});

    const { to } = req.body;

     // Check if id is valid
     if (!isValidObjectId(to)) throw new AppError(INVALID_ID);

     // Check if id valid
     const isFreelancerExists = await Freelancer.findById(to);
 
     if (!isFreelancerExists) return res.status(NOT_FOUND).json({});

     const hasPendingOrder = await BookingOrder.findOne({ from: isClient._id, to, state: PENDING });
     const hasActiveOrder = await BookingOrder.findOne({ from: isClient._id, to, state: IN_PROGRESS });

     if(hasPendingOrder) throw new AppError(PENDING_ORDER);
     if(hasActiveOrder) throw new AppError(IN_PROGRESS_ORDER);

    await BookingOrder.create({
      from: isClient._id,
      to,
    })

    return res.status(CREATED).json({});
  } catch (err) {
    return next(err);
  }
};

const completeBookingOrder = async (req, res, next) => {
  try {
    if (!req.user) return res;

    const { id: userId } = req.user;

    const isFreelancer = await Freelancer.findById(userId);
    const isClient = await Client.findById(userId);

    if (isFreelancer) return res.status(FORBIDDEN).json({});
    if (!isClient) return res.status(NOT_FOUND).json({});

    const { to } = req.body;

     // Check if id is valid
     if (!isValidObjectId(to)) throw new AppError(INVALID_ID);

     // Check if id valid
     const isFreelancerExists = await Freelancer.findById(to);
 
     if (!isFreelancerExists) return res.status(NOT_FOUND).json({});

     const hasActiveOrder = await BookingOrder.findOne({ from: isClient._id, to, state: IN_PROGRESS });

     if(!hasActiveOrder) throw new AppError(NO_ACTIVE_ORDER);

    await BookingOrder.findByIdAndUpdate(hasActiveOrder._id, {
      state: COMPLETED
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

    if (isFreelancer) return res.status(FORBIDDEN).json({});
    if (!isClient) return res.status(NOT_FOUND).json({});

     const orders = await BookingOrder.find({ from: isClient._id }, {
      __v: false,
      from: false
     });

    return res.status(OK).json(orders);
  } catch (err) {
    return next(err);
  }
};

export {
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
};
