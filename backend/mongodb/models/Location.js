import { Schema } from "mongoose";
import { PointSchema } from "./Point.js";

export const LocationSchema = new Schema({
  name: { type: String, required: true },
  location: { type: PointSchema, required: true },
});
