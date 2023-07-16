import { default as Package } from "../mongodb/models/Package.js";
import { default as Freelancer } from "../mongodb/models/Freelancer.js";
import { default as Client } from "../mongodb/models/Client.js";
import CreateFreelancerPackageService from "../services/CreateFreelancerPackageService.js";
import { httpResponseCodes, errorEnum } from "../constants/errorCodes.js";
import freelancerPackageDataValidator from "../utils/freelancerPackageDataValidator.js";
import { freelancerPackageData } from "../constants/userData.js";
import { isValidObjectId } from "mongoose";

const { INVALID_ID } = errorEnum;
const { FORBIDDEN, NO_CONTENT, NOT_FOUND, CREATED, OK, UNAUTHORIZED } = httpResponseCodes;
const { PHOTOS_NUM, DESCRIPTION, PRICE } = freelancerPackageData

const createPackage = async (req, res, next) => {
  try {
    if (!req.user) return res;

    const { id: userId } = req.user;

    const isFreelancer = await Freelancer.findById(userId);
    const isClient = await Client.findById(userId);

    if (isClient) return res.status(FORBIDDEN).json({});
    if (!isFreelancer) return res.status(NOT_FOUND).json({});

    // Get package info
    const { photosNum, description, price } = req.body;

    // Validate package info
    const validPackageInfo = CreateFreelancerPackageService({
      photosNum,
      description,
      price
    });

    // Create package in our database
    await Package.create({
      ...validPackageInfo,
      owner: isFreelancer._id,
    });

    return res.status(CREATED).json({});
  } catch (err) {
    return next(err);
  }
};

const updatePackage = async (req, res, next) => {
  try {
    if (!req.user) return res;

    const { id: userId } = req.user;

    const isFreelancer = await Freelancer.findById(userId);
    const isClient = await Client.findById(userId);

    if (isClient) return res.status(FORBIDDEN).json({});
    if (!isFreelancer) return res.status(NOT_FOUND).json({});

     // Get package ID
     const id = req.params.id;

    // Check if id is valid
     if(!isValidObjectId(id)) throw new AppError(INVALID_ID);
 
     // Get package data
     const packageData = await Package.findById(id);
    
     if(!packageData) return res.status(NOT_FOUND).json({});

     if(userId !== packageData.owner.toString()) return res.status(UNAUTHORIZED).json({});

    // Get package info
    const { photosNum, description, price } = req.body;

    // Validate package info
    photosNum && freelancerPackageDataValidator(PHOTOS_NUM, photosNum);
    description && freelancerPackageDataValidator(DESCRIPTION, description);
    price && freelancerPackageDataValidator(PRICE, price);

    const updateKeys = Object.assign({},
      photosNum && { photosNum },
      description && { description },
      price && { price }
    );

    // Update package in our database
    await Package.findByIdAndUpdate(id, { ...updateKeys })

    return res.status(NO_CONTENT).send();
  } catch (err) {
    return next(err);
  }
};

const removePackage = async (req, res, next) => {
  try {
    if (!req.user) return res;

    const { id: userId } = req.user;

    const isFreelancer = await Freelancer.findById(userId);
    const isClient = await Client.findById(userId);

    if (isClient) return res.status(FORBIDDEN).json({});
    if (!isFreelancer) return res.status(NOT_FOUND).json({});

     // Get package ID
     const id = req.params.id;

     // Check if id is valid
     if(!isValidObjectId(id)) throw new AppError(INVALID_ID);
 
     // Get package data
     const packageData = await Package.findById(id);
 
     if(!packageData) return res.status(NOT_FOUND).json({});

     if(userId !== packageData.owner.toString()) return res.status(UNAUTHORIZED).json({});

    // Delete package from our database
    await Package.findByIdAndDelete(id);

    return res.status(NO_CONTENT).send();
  } catch (err) {
    return next(err);
  }
};

const getAllPackages = async (req, res, next) => {
  try {
    if (!req.user) return res;
    
    // Get freelancer ID
    const id = req.params.id;

    // Check if id is valid
    if(!isValidObjectId(id)) throw new AppError(INVALID_ID);

    const isFreelancer = await Freelancer.findById(id);

    if (!isFreelancer) return res.status(NOT_FOUND).json({});

    // Match all these packages in our database
    const packages = await Package.find({ owner: isFreelancer._id }, {
      __v: false
    });

    return res.status(OK).json(packages);
  } catch (err) {
    return next(err);
  }
};

export {
  createPackage,
  updatePackage,
  removePackage,
  getAllPackages,
};
