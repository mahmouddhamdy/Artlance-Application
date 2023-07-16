import validator from "validator";
import {
  isNull,
  isEmpty,
  hasLength,
  isArray,
  isMember,
  isBetween,
  isNum,
  isString,
  isUrl
} from "./checkValidity.js";
import AppError from "../constants/AppError.js";
import { errorEnum } from "../constants/errorCodes.js";
import { freelancerTypes } from "../constants/models.js";
import { userData } from "../constants/userData.js";

const {
  ALL_FIELDS_REQUIRED,
  INVALID_USERNAME,
  INVALID_FULLNAME,
  INVALID_EMAIL,
  INVALID_PASSWORD,
  INVALID_FREELANCER_TYPE,
  INVALID_ADDRESS,
  INVALID_PHONE,
  INVALID_HOURLY_RATE,
  INVALID_DESCRIPTION,
  INVALID_URL
} = errorEnum;
const { matches, isEmail, isMobilePhone } = validator;
const {
  USERNAME,
  PROFILE_PIC,
  FULLNAME,
  EMAIL,
  PASSWORD,
  FREELANCER_TYPE,
  ADDRESS,
  PHONE_NUM,
  HOURLY_RATE,
  DESCRIPTION,
} = userData;

const userDataValidator = (dataType, data) => {
    switch (dataType) {
      
      case USERNAME:
          if (isNull(data) || isEmpty(data))
            throw new AppError(ALL_FIELDS_REQUIRED);
          if (!isString(data) || !matches(data, new RegExp(/^[a-zA-Z0-9](_(?!(\.|_))|\.(?!(_|\.))|[a-zA-Z0-9]){6,18}[a-zA-Z0-9]$/)))
            throw new AppError(INVALID_USERNAME);
  
      break;

      case PROFILE_PIC:
          if (isNull(data) || isEmpty(data))
            throw new AppError(ALL_FIELDS_REQUIRED);
          if(!isUrl(data))
            throw new AppError(INVALID_URL);
  
      break;
  
      case FULLNAME:
          if (isNull(data) || isEmpty(data))
            throw new AppError(ALL_FIELDS_REQUIRED);
          if (!isString(data) || !matches(data, new RegExp(/^[a-zA-Z]{4,}((?: [a-zA-Z]+){0,2})/)))
            throw new AppError(INVALID_FULLNAME);
  
      break;
  
      case EMAIL:
          if (isNull(data) || isEmpty(data))
            throw new AppError(ALL_FIELDS_REQUIRED);
          if (!isEmail(data))
            throw new AppError(INVALID_EMAIL);
  
      break;
  
      case PASSWORD:
          if (isNull(data) || isEmpty(data))
            throw new AppError(ALL_FIELDS_REQUIRED);
          if (!isString(data) || !matches(data, new RegExp(/^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#.?_!@$%^&*-]).{8,32}$/)))
            throw new AppError(INVALID_PASSWORD);
  
      break;
  
      case FREELANCER_TYPE:
          if (isNull(data) || isEmpty(data))
            throw new AppError(ALL_FIELDS_REQUIRED);
          if (!isMember(data, Object.values(freelancerTypes)))
            throw new AppError(INVALID_FREELANCER_TYPE);
  
      break;
  
      case ADDRESS:
          if (isNull(data))
            throw new AppError(ALL_FIELDS_REQUIRED);
          if (!(isArray(data) && hasLength(data, 2) && data.reduce((acc, cur) => acc && isNum(cur), true)))
            throw new AppError(INVALID_ADDRESS);
  
      break;
  
      case PHONE_NUM:
          if (isNull(data) || isEmpty(data))
            throw new AppError(ALL_FIELDS_REQUIRED);
          if (!isMobilePhone(data, "ar-EG"))
            throw new AppError(INVALID_PHONE);
  
      break;
  
      case HOURLY_RATE:
          if (isNull(data))
            throw new AppError(ALL_FIELDS_REQUIRED);
          if (!(isNum(data) && isBetween(9, data, 1001)))
            throw new AppError(INVALID_HOURLY_RATE);
  
      break;
  
      case DESCRIPTION:
          if (isNull(data) || isEmpty(data))
            throw new AppError(ALL_FIELDS_REQUIRED);
          if (!isString(data) || !isBetween(19, data.length, 1001))
            throw new AppError(INVALID_DESCRIPTION);
  
      break;
  
      default:
          if (isNull(data))
            throw new AppError(ALL_FIELDS_REQUIRED);
    }
    return true;
  };
  
export default userDataValidator;