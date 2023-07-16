import { Schema, model } from "mongoose";

const OtpSchema = new Schema({
  _userId: { type: Schema.Types.ObjectId, refPath: "docModel", required: true },
  otp: { type: String, required: true },
  docModel: { type: String, enum: ["Client", "Freelancer"], required: true },
  expireAt: { type: Date, default: Date.now, expires: 1800 }
});

const OtpModel = model("Otp", OtpSchema);

export default OtpModel;