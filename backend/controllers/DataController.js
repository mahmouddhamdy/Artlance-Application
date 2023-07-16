import { httpResponseCodes } from "../constants/errorCodes.js";
import { isMember } from "../utils/checkValidity.js";
import userDataValidator from "../utils/userDataValidator.js";
import { userData } from "../constants/userData.js";
const { OK, BAD_REQUEST } = httpResponseCodes;

const validate = async (req, res, next) => {
  try {
    const { data, dataType } = req.body;

    if(!isMember(dataType, Object.values(userData))) return res.status(BAD_REQUEST).json({});

    userDataValidator(dataType, data);
    
    return res.status(OK).json({});
  } catch (err) {
    return next(err);
  }
};

export { validate };
