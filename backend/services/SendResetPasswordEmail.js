import Transporter from "../constants/Transponder.js";
import CreateResetPasswordEmailTemplate from "./CreateResetPasswordEmailTemplate.js";
import * as dotenv from "dotenv";
import generateOtpService from "./GenerateOtpService.js";

dotenv.config();

const { MAIL_SERVICE_NAME } = process.env;

const SendResetPasswordEmail = async (email) => {

  const otp = generateOtpService();

  const mailOptions = {
    from: MAIL_SERVICE_NAME,
    to: email,
    subject: 'Reset your password',
    text: `Please use the following OTP to reset your password: ${otp}`,
    html: CreateResetPasswordEmailTemplate(otp)
  };

  await Transporter.sendMail(mailOptions);

  return otp;
}

export default SendResetPasswordEmail;