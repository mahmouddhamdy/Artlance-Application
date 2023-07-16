import { Schema, model } from "mongoose";

export const PackageSchema = new Schema({
  date: { type: Date, default: Date.now },
  owner: { type: Schema.Types.ObjectId, ref: "Freelancer" },
  photosNum: { type: Number, required: true },
  description: { type: String, required: true },
  price: { type: Number, required: true }
});

const PackageModel = model("Package", PackageSchema);

export default PackageModel;
