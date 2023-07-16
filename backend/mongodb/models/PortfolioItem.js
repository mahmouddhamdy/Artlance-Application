import { Schema, model } from "mongoose";
import { freelancerTypes } from "../../constants/models.js";

export const PortfolioItemSchema = new Schema({
  date: { type: Date, default: Date.now },
  owner: { type: Schema.Types.ObjectId, ref: "Freelancer", required: true },
  type: { type: String, enum: Object.values(freelancerTypes), required: true },
  url: { type: String, required: true },
  features: { type: [Number], required: true }
});

const PortfolioItemModel = model("PortfolioItem", PortfolioItemSchema);

export default PortfolioItemModel;
