import { default as Review } from '../mongodb/models/Review.js';
import { default as Freelancer } from "../mongodb/models/Freelancer.js";
import { default as Client } from "../mongodb/models/Client.js";
import { default as BookingOrder } from '../mongodb/models/BookingOrder.js';
import AppError from '../constants/AppError.js';
import { isValidObjectId } from "mongoose";
import { errorEnum, httpResponseCodes } from '../constants/errorCodes.js';
import CreateReviewService from '../services/CreateReviewService.js';
import { bookingOrderStates } from '../constants/models.js';
import CalculateFreelancerRateService from '../services/CalculateFreelancerRateService.js';
import SentimentalAnalysisService from '../services/SentimentalAnalysisService.js';


const { COMPLETED } = bookingOrderStates;
const { INVALID_ID, REVIEW_EXIST } = errorEnum; 
const { CREATED, OK, NO_CONTENT, FORBIDDEN, NOT_FOUND, UNAUTHORIZED } = httpResponseCodes;

const createReview = async (req, res, next) => {
  try {
    if (!req.user) return res;

    const { id: userId } = req.user;

    const isFreelancer = await Freelancer.findById(userId);
    const isClient = await Client.findById(userId);

    if (isFreelancer) return res.status(FORBIDDEN).json({});
    if (!isClient) return res.status(NOT_FOUND).json({});
    
    const from = isClient._id;
    const { content, to } = req.body;

    // Check if id is valid
    if(!isValidObjectId(to)) throw new AppError(INVALID_ID);

    const bookingOrderExists = await BookingOrder.findOne({ from, to, state: COMPLETED });

    if(!bookingOrderExists) return res.status(UNAUTHORIZED).json({});

    const reviewExists = await Review.findOne({ from, to });

    // Check if client reviewed freelancer before
    if (reviewExists) throw new AppError(REVIEW_EXIST);
    
    const validReviewInfo = CreateReviewService({ content });

    const result = await SentimentalAnalysisService(content);

    if (result instanceof AppError) throw result;

    // Create review in our database
    await Review.create({ ...validReviewInfo, from, to, sentiment: result.predictions });

    const reviews = await Review.find({ to });
    const sentiments = reviews.map(review => review.sentiment);

    const rate = CalculateFreelancerRateService(sentiments);

    if(rate < 2 && reviews.length > 10){
      await Freelancer.findByIdAndUpdate(to, {
        rate,
        isSuspended: true
      })
    }
    else {
      await Freelancer.findByIdAndUpdate(to, {
        rate
      })
    }

    res.status(CREATED).json({});
    
  } catch (err) {
    return next(err);
  }
};

const updateReview = async (req, res, next) => {
  try {
    if (!req.user) return res;

    const { id: userId } = req.user;

    const isFreelancer = await Freelancer.findById(userId);
    const isClient = await Client.findById(userId);

    if (isFreelancer) return res.status(FORBIDDEN).json({});
    if (!isClient) return res.status(NOT_FOUND).json({});

    // Get review ID
    const id = req.params.id;

    // Check if id is valid
    if(!isValidObjectId(id)) throw new AppError(INVALID_ID);

    const isReviewExist = await Review.findById(id);

    if(!isReviewExist) return res.status(NOT_FOUND).json({});

    if(userId !== isReviewExist.from.toString()) return res.status(UNAUTHORIZED).json({});

    // Get review updated content
    const { content } = req.body;

    const validReviewInfo = CreateReviewService({ content });

    const result = await SentimentalAnalysisService(content);

    if (result instanceof AppError) throw result;

    // Update review in our database
    const targetReview = await Review.findByIdAndUpdate(id, { ...validReviewInfo, sentiment: result.predictions });

    const reviews = await Review.find({ to: targetReview.to });
    const sentiments = reviews.map(review => review.sentiment);

    const rate = CalculateFreelancerRateService(sentiments);

    await Freelancer.findByIdAndUpdate(targetReview.to, {
      rate
    })

    return res.status(NO_CONTENT).send();
    
  } catch (err) {
    return next(err);
  }
};

const removeReview = async (req, res, next) => {
  try {
    if (!req.user) return res;

    const { id: userId } = req.user;

    const isFreelancer = await Freelancer.findById(userId);
    const isClient = await Client.findById(userId);

    if (isFreelancer) return res.status(FORBIDDEN).json({});
    if (!isClient) return res.status(NOT_FOUND).json({});

    // Get review ID
    const id = req.params.id;

    // Check if id is valid
    if(!isValidObjectId(id)) throw new AppError(INVALID_ID);

    const isReviewExist = await Review.findById(id);

    if(!isReviewExist) return res.status(NOT_FOUND).json({});

    if(userId !== isReviewExist.from.toString()) return res.status(UNAUTHORIZED).json({});

    // delete review from our database
    await Review.findByIdAndDelete(id);

    const reviews = await Review.find({ to: isReviewExist.to });
    const sentiments = reviews.map(review => review.sentiment);

    const rate = CalculateFreelancerRateService(sentiments);

    await Freelancer.findByIdAndUpdate(isReviewExist.to, {
      rate
    })

    return res.status(NO_CONTENT).send();
    
  } catch (err) {
    return next(err);
  }
};

const getAllReviews = async (req, res, next) => {
  try {
    if (!req.user) return res;
    
    // Get freelancer ID
    const id = req.params.id;

    // Check if id is valid
    if(!isValidObjectId(id)) throw new AppError(INVALID_ID);

    const isFreelancer = await Freelancer.findById(id);
   
    if (!isFreelancer) return res.status(NOT_FOUND).json({});

    const reviews = await Review.find({ to: id }, {
      __v: false
    }).sort({ date: -1 });

    res.status(OK).json(reviews);
  } catch (err) {
    return next(err);
  }
};

export { createReview, updateReview, removeReview, getAllReviews }