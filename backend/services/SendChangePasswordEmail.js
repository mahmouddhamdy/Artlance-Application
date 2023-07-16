import Transporter from "../constants/Transponder.js";
import CreateChangePasswordEmailTemplate from "./CreateChangePasswordEmailTemplate.js";
import * as dotenv from "dotenv";
import generateOtpService from "./GenerateOtpService.js";

dotenv.config();

const { MAIL_SERVICE_NAME } = process.env;

const SendChangePasswordEmail = async (email) => {

  const otp = generateOtpService();

  const mailOptions = {
    from: MAIL_SERVICE_NAME,
    to: email,
    subject: 'Change your password',
    text: `Please use the following OTP to change your password: ${otp}`,
    html: CreateChangePasswordEmailTemplate(otp)
  };

  await Transporter.sendMail(mailOptions);

  return otp;
}

export default SendChangePasswordEmail;