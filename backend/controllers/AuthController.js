import { compareSync } from "bcrypt";
import { default as Client } from "../mongodb/models/Client.js";
import { default as Freelancer } from "../mongodb/models/Freelancer.js";
import { createToken } from "../utils/jwt.js";
import { errorEnum, httpResponseCodes } from "../constants/errorCodes.js";
import { verifyToken } from "../utils/jwt.js";
import { default as TokenModel } from "../mongodb/models/Token.js";
import LoginService from "../services/LoginService.js";
import AppError from "../constants/AppError.js";
import { tokenTypes } from "../constants/jwt.js";

const { AUTH_REQUIRED, EMAIL_NOT_FOUND, WRONG_PASSWORD, EMAIL_NOT_VERIFIED, ACCOUNT_SUSPENDED } = errorEnum;
const { OK } = httpResponseCodes;
const { ACCESS, REFRESH } = tokenTypes

const login = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    const validCredentials = LoginService({ email, password });

    // Check if user is client
    const isClient = await Client.findOne({ email: validCredentials.email });

    // Check if user is freelancer
    const isFreelancer = await Freelancer.findOne({
      email: validCredentials.email,
    });

    // Validate if user exist in our database
    if (!isClient && !isFreelancer) throw new AppError(EMAIL_NOT_FOUND);

    const userInfo = isClient || isFreelancer;

    const isPasswordValid = compareSync(password, userInfo.password);

    if (!isPasswordValid) throw new AppError(WRONG_PASSWORD);

    if(!userInfo.verified) throw new AppError(EMAIL_NOT_VERIFIED);

    if(isFreelancer && userInfo.isSuspended) throw new AppError(ACCOUNT_SUSPENDED);

    // Create access token
    const access = createToken({ id: userInfo._id }, ACCESS);

    // Create refresh token
    const refresh = createToken({ id: userInfo._id }, REFRESH);

    const newTokenInfo = {
      _userId: userInfo._id,
      token: refresh,
    };

    //Get token from database
    const dbToken = await TokenModel.findOne({ _userId: userInfo._id });

    // create token in database
    if (!dbToken) await TokenModel.create(newTokenInfo);
    // Update token in database
    else
      await TokenModel.updateOne({ _userId: userInfo._id }, { token: refresh });

    // Assigning refresh token in signed cookie
    // res.cookie("Auth", refresh, {
    //   signed: true,
    //   maxAge: 60 * 60 * 24 * 365,
    // });

    // return access and refresh token
    return res.status(OK).json({ access, refresh });
  } catch (err) {
    return next(err);
  }
};

const refreshToken = async (req, res, next) => {
  try {
    const { token: refreshToken } = req.body;

    if (!refreshToken) throw new AppError(AUTH_REQUIRED);

    const result = verifyToken(refreshToken, REFRESH);

    if (
      (result instanceof Error && result.name === "TokenExpiredError") ||
      !(result instanceof Error)
    ) {
      //Get token from database
      const dbToken = await TokenModel.findOne({ token: refreshToken });

      if (!dbToken) return res.status(httpResponseCodes.NOT_FOUND).json({});

      // Create access token
      const access = createToken({ id: dbToken._userId }, ACCESS);

      // Creating refresh token
      const refresh = createToken({ id: dbToken._userId }, REFRESH);

      // Update token in database
      await TokenModel.updateOne(
        { _userId: dbToken._userId },
        { token: refresh }
      );

      // Assigning refresh token in new signed cookie
      //res.cookie("Auth", refresh, { signed: true });

      // return access token
      return res.status(OK).json({ access, refresh });
    }

    throw new AppError(errorEnum.INVALID_AUTH);
  } catch (err) {
    return next(err);
  }
};

export { login, refreshToken };
