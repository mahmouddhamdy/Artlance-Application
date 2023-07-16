import { Schema, model } from "mongoose";

export const ReviewSchema = new Schema({
  content: { type: String, required: true },
  from: { type: Schema.Types.ObjectId, ref: "Client", required: true },
  to: { type: Schema.Types.ObjectId, ref: "Freelancer", required: true },
  sentiment: { type: Number, enum: [0, 1], required: true },
  date: { type: Date, default: Date.now }
});

const ReviewModel = model("Review", ReviewSchema);

export default ReviewModel;
