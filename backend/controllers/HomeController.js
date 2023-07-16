import { default as PortfolioItem } from '../mongodb/models/PortfolioItem.js';
import { default as Client } from "../mongodb/models/Client.js";
import { default as Freelancer } from "../mongodb/models/Freelancer.js";
import { httpResponseCodes } from '../constants/errorCodes.js';

const { OK, FORBIDDEN, NOT_FOUND } = httpResponseCodes;

const explore = async (req, res, next) => {
  try {
    if (!req.user) return res;

    const { id: userId } = req.user;

    const isFreelancer = await Freelancer.findById(userId);
    const isClient = await Client.findById(userId);

    if (isFreelancer) return res.status(FORBIDDEN).json({});
    if (!isClient) return res.status(NOT_FOUND).json({});
    
    const itemSize = await PortfolioItem.countDocuments();

    const items = await PortfolioItem.aggregate([
        { $sample: { size: itemSize }},
        { $project: { __v: false, features: false, type: false }}
    ])

    return res.status(OK).json(items);
  } catch (err) {
    return next(err);
  }
};

const getTopPicks = async (req, res, next) => {
  try {
    if (!req.user) return res;

    const { id: userId } = req.user;

    const isFreelancer = await Freelancer.findById(userId);
    const isClient = await Client.findById(userId);

    if (isFreelancer) return res.status(FORBIDDEN).json({});
    if (!isClient) return res.status(NOT_FOUND).json({});

    const topPicks = await PortfolioItem.find({
        owner: { $in: isClient.favList }
    }, {
        __v: false,
        features: false,
        type: false,
    })

    return res.status(OK).json(topPicks);
  } catch (err) {
    return next(err);
  }
};

export { explore, getTopPicks };
