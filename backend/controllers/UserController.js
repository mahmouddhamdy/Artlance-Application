import { default as Freelancer } from "../mongodb/models/Freelancer.js";
import { default as Client } from "../mongodb/models/Client.js";
import { default as Otp } from "../mongodb/models/Otp.js";
import { hashSync, compareSync } from "bcrypt";
import { errorEnum, httpResponseCodes } from "../constants/errorCodes.js";
import UpdateProfileService from "../services/UpdateProfileService.js";
import { userTypes } from "../constants/models.js";
import AppError from "../constants/AppError.js";
import SendVerificationEmail from "../services/SendVerificationEmail.js";
import SendResetPasswordEmail from "../services/SendResetPasswordEmail.js";
import userDataValidator from "../utils/userDataValidator.js";
import { userData } from "../constants/userData.js";

const { EMAIL, PASSWORD } = userData;
const { NO_CONTENT, NOT_FOUND, OK } = httpResponseCodes;
const { EMAIL_VERIFIED, EMAIL_NOT_FOUND, PASSWORD_MATCH, OTP_EXPIRED, INVALID_OTP } =
  errorEnum;

const getProfile = async (req, res, next) => {
  try {
    if (!req.user) return res;

    const { id: userId } = req.user;

    const isFreelancer = await Freelancer.findById(userId, {
      __v: false,
      password: false,
    }).exec();

    const isClient = await Client.findById(userId, {
      __v: false,
      password: false,
    }).exec();

    if (!isFreelancer && !isClient) return res.status(NOT_FOUND).json({});

    const userInfo = isFreelancer || isClient;

    return res.status(OK).json(userInfo);
  } catch (err) {
    return next(err);
  }
};

const updateProfile = async (req, res, next) => {
  try {
    if (!req.user) return res;

    const { id: userId } = req.user;

    const isFreelancer = await Freelancer.findById(userId);

    const isClient = await Client.findById(userId);

    if (!isFreelancer && !isClient) return res.status(NOT_FOUND).json({});

    const userInfo = isFreelancer || isClient;

    const userType = userInfo.userType;

    const updateKeys = UpdateProfileService(req.body, userType);

    userType === userTypes.FREELANCER
      ? await Freelancer.findByIdAndUpdate(userId, { ...updateKeys })
      : await Client.findByIdAndUpdate(userId, { ...updateKeys });

    return res.status(NO_CONTENT).send();
  } catch (err) {
    return next(err);
  }
};

const sendVerification = async (req, res, next) => {
  try {
    const { email } = req.body;
    userDataValidator(EMAIL, email);
    const isFreelancer = await Freelancer.findOne({ email });
    const isClient = await Client.findOne({ email });
    if (!isFreelancer && !isClient) throw new AppError(EMAIL_NOT_FOUND);
    const userInfo = isClient || isFreelancer;
    if (userInfo.verified) throw new AppError(EMAIL_VERIFIED);
    const otp = await SendVerificationEmail(email);
    const isOtp = await Otp.findOne({ _userId: userInfo._id });
    if(isOtp){
      await Otp.findByIdAndUpdate(isOtp._id, { otp });
    }
    else{
      await Otp.create({
        _userId: userInfo._id,
        otp,
        docModel: userInfo.constructor.modelName
      });
    }
    return res.status(NO_CONTENT).send();
  } catch (err) {
    return next(err);
  }
};

const verifyUser = async (req, res, next) => {
  try {
    const { email, code } = req.body;
    const isFreelancer = await Freelancer.findOne({ email });
    const isClient = await Client.findOne({ email });
    if (!isFreelancer && !isClient) throw new AppError(EMAIL_NOT_FOUND);
    const userInfo = isClient || isFreelancer;
    if(userInfo.verified) throw new AppError(EMAIL_VERIFIED);
    const otpDoc = await Otp.findOne({ _userId: userInfo._id  });
    if(!otpDoc) throw new AppError(OTP_EXPIRED);
    if(otpDoc.otp !== code) throw new AppError(INVALID_OTP);
    if (userInfo.userType === userTypes.CLIENT)
      await Client.findByIdAndUpdate(userInfo._id, { verified: true });
    else await Freelancer.findByIdAndUpdate(userInfo._id, { verified: true });
    await Otp.findByIdAndDelete(otpDoc._id);
    return res.status(NO_CONTENT).send();
  } catch (err) {
    return next(err);
  }
};

const sendReset = async (req, res, next) => {
  try {
    const { email } = req.body;
    userDataValidator(EMAIL, email);
    const isFreelancer = await Freelancer.findOne({ email });
    const isClient = await Client.findOne({ email });
    if (!isFreelancer && !isClient) throw new AppError(EMAIL_NOT_FOUND);
    const userInfo = isFreelancer || isClient;
    const otp = await SendResetPasswordEmail(email);
    const isOtp = await Otp.findOne({ _userId: userInfo._id });
    if(isOtp){
      await Otp.findByIdAndUpdate(isOtp._id, { otp });
    }
    else{
      await Otp.create({
        _userId: userInfo._id,
        otp,
        docModel: userInfo.constructor.modelName
      });
    }
    return res.status(NO_CONTENT).send();
  } catch (err) {
    return next(err);
  }
};

const resetPassword = async (req, res, next) => {
  try {
    const { email, code, password } = req.body;
    const isFreelancer = await Freelancer.findOne({ email });
    const isClient = await Client.findOne({ email });
    const userInfo = isFreelancer || isClient;
    if (!userInfo) throw new AppError(EMAIL_NOT_FOUND);
    const otpDoc = await Otp.findOne({ _userId: userInfo._id  });
    if(!otpDoc) throw new AppError(OTP_EXPIRED);
    if(otpDoc.otp !== code) throw new AppError(INVALID_OTP);
    const isPasswordMatch = compareSync(password, userInfo.password);
    if(isPasswordMatch) throw new AppError(PASSWORD_MATCH);
    userDataValidator(PASSWORD, password);
    // hash plain password
    const hashPass = hashSync(password, 15);
    if (userInfo.userType === userTypes.CLIENT)
      await Client.updateOne({ email }, { password: hashPass });
    else await Freelancer.updateOne({ email }, { password: hashPass });
    await Otp.findByIdAndDelete(otpDoc._id);
    return res.status(NO_CONTENT).send();
  } catch (err) {
    return next(err);
  }
};

export {
  getProfile,
  updateProfile,
  sendVerification,
  verifyUser,
  sendReset,
  resetPassword,
};
