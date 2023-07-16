import {
    isNull,
    isEmpty,
    isString,
    isBetween
  } from "./checkValidity.js";
import AppError from "../constants/AppError.js";
import { errorEnum } from "../constants/errorCodes.js";
import { reviewData } from "../constants/userData.js";
  
const { INVALID_REVIEW_CONTENT, ALL_FIELDS_REQUIRED } = errorEnum;
const { CONTENT } = reviewData;

const reviewDataValidator = (dataType, data) => {
    switch(dataType){
        case CONTENT:
            if(isNull(data) || isEmpty(data))
                throw new AppError(ALL_FIELDS_REQUIRED);
            if(!isString(data) || !isBetween(4, data.length, 201))
                throw new AppError(INVALID_REVIEW_CONTENT);
        
        default:
            if (isNull(data)) throw new AppError(ALL_FIELDS_REQUIRED);
    }
}

export default reviewDataValidator;