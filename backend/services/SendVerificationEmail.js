import Transporter from "../constants/Transponder.js";
import CreateVerificationEmailTemplate from "./CreateVerificationEmailTemplate.js";
import * as dotenv from "dotenv";
import generateOtpService from "./GenerateOtpService.js";

dotenv.config();

const { MAIL_SERVICE_NAME } = process.env;

const SendVerificationEmail = async (email) => {

  const otp = generateOtpService();

  const mailOptions = {
    from: MAIL_SERVICE_NAME,
    to: email,
    subject: 'Verify your email address',
    text: `Here is : ${otp}`,
    html: CreateVerificationEmailTemplate(otp)
  };

  await Transporter.sendMail(mailOptions);

  return otp;
}

export default SendVerificationEmail;