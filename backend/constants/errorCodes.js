import { freelancerTypes } from "./models.js";

export const errorEnum = {
  ALL_FIELDS_REQUIRED: 'ALL_FIELDS_REQUIRED',
  AUTH_REQUIRED: 'AUTH_REQUIRED',
  USER_ID_REQUIRED: 'USER_ID_REQUIRED',
  PACKAGE_ID_REQUIRED: 'PACKAGE_ID_REQUIRED',
  USERNAME_EXIST: 'USERNAME_EXIST',
  EMAIL_EXIST: 'EMAIL_EXIST',
  REVIEW_EXIST: 'REVIEW_EXIST',
  FAV_EXIST: 'FAV_EXIST',
  CHAT_EXIST: 'CHAT_EXIST',
  INVALID_USERNAME: 'INVALID_USERNAME',
  INVALID_FULLNAME: 'INVALID_FULLNAME',
  INVALID_EMAIL: 'INVALID_EMAIL',
  INVALID_PASSWORD: 'INVALID_PASSWORD',
  INVALID_FREELANCER_TYPE: 'INVALID_FREELANCER_TYPE',
  INVALID_ADDRESS: 'INVALID_ADDRESS',
  INVALID_HOURLY_RATE: 'INVALID_HOURLY_RATE',
  INVALID_PHONE: 'INVALID_PHONE',
  INVALID_DESCRIPTION: 'INVALID_DESCRIPTION',
  INVALID_CREDENTIALS: 'INVALID_CREDENTIALS',
  INVALID_PACKAGE_PHOTOS_NUM: 'INVALID_PACKAGE_PHOTOS_NUM',
  INVALID_PACKAGE_DESCRIPTION: 'INVALID_PACKAGE_DESCRIPTION',
  INVALID_PACKAGE_PRICE: 'INVALID_PACKAGE_PRICE',
  INVALID_REVIEW_CONTENT: 'INVALID_REVIEW_CONTENT',
  INVALID_AUTH: 'INVALID_AUTH',
  INVALID_ID: 'INVALID_ID',
  INVALID_URL: 'INVALID_URL',
  INVALID_OTP: 'INVALID_OTP',
  EMAIL_NOT_FOUND: 'EMAIL_NOT_FOUND',
  EMAIL_NOT_VERIFIED: 'EMAIL_NOT_VERIFIED',
  EMAIL_VERIFIED: 'EMAIL_VERIFIED',
  WRONG_PASSWORD: 'WRONG_PASSWORD',
  PASSWORD_MATCH: 'PASSWORD_MATCH',
  LOCATION_API_ERROR: 'LOCATION_API_ERROR',
  ML_MODEL_API_ERROR: 'ML_MODEL_API_ERROR',
  INTERNAL_ERROR: 'INTERNAL_ERROR',
  OTP_EXPIRED: 'OTP_EXPIRED',
  PENDING_ORDER: 'PENDING_ORDER',
  IN_PROGRESS_ORDER: 'IN_PROGRESS_ORDER',
  NO_ACTIVE_ORDER: 'NO_ACTIVE_ORDER',
  NO_PENDING_ORDER: 'NO_PENDING_ORDER',
  NO_CHAT: 'NO_CHAT',
  ACCOUNT_SUSPENDED: 'ACCOUNT_SUSPENDED',
  CLIENT_TALK_CLIENT: 'CLIENT_TALK_CLIENT'
}

export const httpResponseCodes = {
  OK: 200,
  CREATED: 201,
  NO_CONTENT: 204,
  BAD_REQUEST: 400,
  UNAUTHORIZED: 401,
  FORBIDDEN: 403,
  NOT_FOUND: 404,
  CONFLICT: 409,
  INTERNAL_SERVER_ERROR: 500,
};

export const errorCodes = {
  [errorEnum.ALL_FIELDS_REQUIRED]: {
    statusCode: httpResponseCodes.BAD_REQUEST,
    message: "All fields are required.",
  },
  
  [errorEnum.AUTH_REQUIRED]: {
    statusCode: httpResponseCodes.UNAUTHORIZED,
    message: "Authorization credentials are required.",
  },

  [errorEnum.USER_ID_REQUIRED]: {
    statusCode: httpResponseCodes.BAD_REQUEST,
    message: "User ID is required.",
  },

  [errorEnum.PACKAGE_ID_REQUIRED]: {
    statusCode: httpResponseCodes.BAD_REQUEST,
    message: "Package ID is required.",
  },

  [errorEnum.USERNAME_EXIST]: {
    statusCode: httpResponseCodes.CONFLICT,
    message: "Username already exists.",
  },

  [errorEnum.EMAIL_EXIST]: {
    statusCode: httpResponseCodes.CONFLICT,
    message: "Email address already exists.",
  },

  [errorEnum.REVIEW_EXIST]: {
    statusCode: httpResponseCodes.CONFLICT,
    message: "Client has already reviewed same freelancer before.",
  },

  [errorEnum.FAV_EXIST]: {
    statusCode: httpResponseCodes.CONFLICT,
    message: "Freelancer has already been added to favorites before.",
  },

  [errorEnum.CHAT_EXIST]: {
    statusCode: httpResponseCodes.CONFLICT,
    message: "Client has already created chat with same freelancer before.",
  },

  [errorEnum.INVALID_USERNAME]: {
    statusCode: httpResponseCodes.BAD_REQUEST,
    message: "Username length must be between 8 to 20. Username must only contain alphanumeric characters, underscore and dot. Underscore and dot can't be at the end or the start or next to each other. Underscore or dot can't be used multiple times in a row.",
  },

  [errorEnum.INVALID_FULLNAME]: {
    statusCode: httpResponseCodes.BAD_REQUEST,
    message: "Full name must be at most 3 words (first name is 4 or more characters).",
  },

  [errorEnum.INVALID_EMAIL]: {
    statusCode: httpResponseCodes.BAD_REQUEST,
    message: "Invalid email address.",
  },

  [errorEnum.INVALID_PASSWORD]: {
    statusCode: httpResponseCodes.BAD_REQUEST,
    message: "Password must contain at least 1 lowercase alphabetical character, 1 uppercase alphabetical character, 1 numeric character, 1 special character and be 8 characters or longer.",
  },

  [errorEnum.INVALID_FREELANCER_TYPE]: {
    statusCode: httpResponseCodes.BAD_REQUEST,
    message: `Type should be one of these: ${Object.values(freelancerTypes).join(', ')}`,
  },

  [errorEnum.INVALID_ADDRESS]: {
    statusCode: httpResponseCodes.BAD_REQUEST,
    message: "Address must be an array of two numeric values [latitude, longitude].",
  },

  [errorEnum.INVALID_HOURLY_RATE]: {
    statusCode: httpResponseCodes.BAD_REQUEST,
    message: "Hourly rate must be a number [10, 1000].",
  },

  [errorEnum.INVALID_PHONE]: {
    statusCode: httpResponseCodes.BAD_REQUEST,
    message: "Mobile number must be in one of the following formats: {0-10-xxxx-xxxx, 0-11-xxxx-xxxx, 0-12-xxxx-xxxx, 0-15-xxxx-xxxx}.",
  },

  [errorEnum.INVALID_DESCRIPTION]: {
    statusCode: httpResponseCodes.BAD_REQUEST,
    message: "Description must be at least 20 characters and not exceeding 1000 characters.",
  },

  [errorEnum.INVALID_CREDENTIALS]: {
    statusCode: httpResponseCodes.BAD_REQUEST,
    message: "Invalid credentials.",
  },

  [errorEnum.INVALID_PACKAGE_PHOTOS_NUM]: {
    statusCode: httpResponseCodes.BAD_REQUEST,
    message: "Photos must be a number [1, 1000].",
  },

  [errorEnum.INVALID_PACKAGE_DESCRIPTION]: {
    statusCode: httpResponseCodes.BAD_REQUEST,
    message: "Description must be at least 20 characters and not exceeding 200 characters.",
  },

  [errorEnum.INVALID_PACKAGE_PRICE]: {
    statusCode: httpResponseCodes.BAD_REQUEST,
    message: "Package price must be a number [10, 100000].",
  },

  [errorEnum.INVALID_REVIEW_CONTENT]: {
    statusCode: httpResponseCodes.BAD_REQUEST,
    message: "Review content must be at least 5 characters and not exceeding 200 characters.",
  },

  [errorEnum.INVALID_AUTH]: {
    statusCode: httpResponseCodes.UNAUTHORIZED,
    message: "Invalid authorization.",
  },

  [errorEnum.INVALID_ID]: {
    statusCode: httpResponseCodes.BAD_REQUEST,
    message: "Invalid id.",
  },

  [errorEnum.INVALID_URL]: {
    statusCode: httpResponseCodes.BAD_REQUEST,
    message: "Invalid url.",
  },

  [errorEnum.INVALID_OTP]: {
    statusCode: httpResponseCodes.BAD_REQUEST,
    message: "Invalid OTP.",
  },

  [errorEnum.EMAIL_NOT_FOUND]: {
    statusCode: httpResponseCodes.NOT_FOUND,
    message: "This email address isn't registered.",
  },

  [errorEnum.EMAIL_VERIFIED]: {
    statusCode: httpResponseCodes.CONFLICT,
    message: "This email address is already verified.",
  },

  [errorEnum.EMAIL_NOT_VERIFIED]: {
    statusCode: httpResponseCodes.UNAUTHORIZED,
    message: "This email address isn't verified.",
  },

  [errorEnum.WRONG_PASSWORD]: {
    statusCode: httpResponseCodes.UNAUTHORIZED,
    message: "Password is incorrect.",
  },

  [errorEnum.PASSWORD_MATCH]: {
    statusCode: httpResponseCodes.BAD_REQUEST,
    message: "Password can't match the old one.",
  },

  [errorEnum.LOCATION_API_ERROR]: {
    statusCode: httpResponseCodes.INTERNAL_SERVER_ERROR,
    message: "Something went wrong in reverse geocoding API.",
  },

  [errorEnum.ML_MODEL_API_ERROR]: {
    statusCode: httpResponseCodes.INTERNAL_SERVER_ERROR,
    message: "Something went wrong in machine model API.",
  },

  [errorEnum.INTERNAL_ERROR]: {
    statusCode: httpResponseCodes.INTERNAL_SERVER_ERROR,
    message: "Internal server error.",
  },

  [errorEnum.OTP_EXPIRED]: {
    statusCode: httpResponseCodes.NOT_FOUND,
    message: "OTP expired (it expires in 30 mins).",
  },

  [errorEnum.PENDING_ORDER]: {
    statusCode: httpResponseCodes.CONFLICT,
    message: "There is a pending order to same freelancer.",
  },

  [errorEnum.IN_PROGRESS_ORDER]: {
    statusCode: httpResponseCodes.CONFLICT,
    message: "There is an active order to same freelancer.",
  },

  [errorEnum.NO_ACTIVE_ORDER]: {
    statusCode: httpResponseCodes.NOT_FOUND,
    message: "No active order has been found.",
  },

  [errorEnum.NO_PENDING_ORDER]: {
    statusCode: httpResponseCodes.NOT_FOUND,
    message: "No pending order has been found.",
  },

  [errorEnum.NO_CHAT]: {
    statusCode: httpResponseCodes.NOT_FOUND,
    message: "No chat has been created between client and freelancer.",
  },

  [errorEnum.ACCOUNT_SUSPENDED]: {
    statusCode: httpResponseCodes.UNAUTHORIZED,
    message: "This account has been suspended.",
  },

  [errorEnum.CLIENT_TALK_CLIENT]: {
    statusCode: httpResponseCodes.BAD_REQUEST,
    message: "Clients can't have chat with each other.",
  },
};
