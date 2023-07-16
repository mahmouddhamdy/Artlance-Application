import nodemailer from "nodemailer";
import * as dotenv from "dotenv";

dotenv.config();

const { MAIL_SERVICE_SENDER, MAIL_SERVICE_PASS } = process.env;

const Transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: MAIL_SERVICE_SENDER,
      pass: MAIL_SERVICE_PASS
    },
    from: MAIL_SERVICE_SENDER,
});

export default Transporter;