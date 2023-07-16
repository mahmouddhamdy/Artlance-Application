import { Schema, model } from "mongoose";
import { bookingOrderStates } from "../../constants/models.js";

export const BookingOrderSchema = new Schema({
  date: { type: Date, default: Date.now },
  from: { type: Schema.Types.ObjectId, ref: "Client", required: true },
  to: { type: Schema.Types.ObjectId, ref: "Freelancer", required: true },
  state: { type: String, enum: Object.values(bookingOrderStates), default: bookingOrderStates.PENDING, required: true }
});

const BookingOrderModel = model("BookingOrder", BookingOrderSchema);

export default BookingOrderModel;