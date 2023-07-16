import { default as PortfolioItem } from '../mongodb/models/PortfolioItem.js';
import { default as Client } from "../mongodb/models/Client.js";
import { default as Freelancer } from "../mongodb/models/Freelancer.js";
import AppError from '../constants/AppError.js';
import { isValidObjectId } from "mongoose";
import { errorEnum, httpResponseCodes } from '../constants/errorCodes.js';
import { isUrl } from '../utils/checkValidity.js';
import UploadPortfolioItemService from '../services/UploadPortfolioItemService.js';

const { INVALID_ID, INVALID_URL } = errorEnum; 
const { OK, NO_CONTENT, FORBIDDEN, NOT_FOUND, UNAUTHORIZED } = httpResponseCodes;

const addPortfolioItem = async (req, res, next) => {
  try {
    if (!req.user) return res;

    const { id: userId } = req.user;

    const isFreelancer = await Freelancer.findById(userId);
    const isClient = await Client.findById(userId);

    if (isClient) return res.status(FORBIDDEN).json({});
    if (!isFreelancer) return res.status(NOT_FOUND).json({});

    const { url } = req.body;

    if(!isUrl(url)) throw new AppError(INVALID_URL);
 
    const { features } = await UploadPortfolioItemService(url);

    // Create PortfolioItem in our database
    await PortfolioItem.create({
      owner: isFreelancer._id,
      type: isFreelancer.freelancerType,
      url,
      features
    });

    return res.status(OK).json({});
  } catch (err) {
    return next(err);
  }
};

const removePortfolioItem = async (req, res, next) => {
  try {
    if (!req.user) return res;

    const { id: userId } = req.user;

    const isFreelancer = await Freelancer.findById(userId);
    const isClient = await Client.findById(userId);

    if (isClient) return res.status(FORBIDDEN).json({});
    if (!isFreelancer) return res.status(NOT_FOUND).json({});

    // Get PortfolioItem ID
    const id = req.params.id;

    // Check if id is valid
    if(!isValidObjectId(id)) throw new AppError(INVALID_ID);

    // Get PortfolioItem data
    const portfolioItemData = await PortfolioItem.findById(id);

    if(!portfolioItemData) return res.status(NOT_FOUND).json({});

    if(userId !== portfolioItemData.owner.toString()) return res.status(UNAUTHORIZED).json({});

   // Delete package from our database
   await PortfolioItem.findByIdAndDelete(id);

   return res.status(NO_CONTENT).send();
  } catch (err) {
    return next(err);
  }
};

const getAllPortfolioItems = async (req, res, next) => {
  try {
    if (!req.user) return res;
    
    // Get freelancer ID
    const id = req.params.id;

    // Check if id is valid
    if(!isValidObjectId(id)) throw new AppError(INVALID_ID);

    const isFreelancer = await Freelancer.findById(id);

    if (!isFreelancer) return res.status(NOT_FOUND).json({});

    // Match all these packages in our database
    const portfolioItems = await PortfolioItem.find({ owner: isFreelancer._id }, {
      __v: false,
      features: false,
      type: false
    });

    return res.status(OK).json(portfolioItems);
  } catch (err) {
    return next(err);
  }
};

export { addPortfolioItem, removePortfolioItem, getAllPortfolioItems };
