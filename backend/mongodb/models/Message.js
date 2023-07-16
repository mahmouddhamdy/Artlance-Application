import { Schema, model } from "mongoose";

const MessageSchema = new Schema({
  from: { type: Schema.Types.ObjectId, refPath: "fromModel", required: true },
  to: { type: Schema.Types.ObjectId, refPath: "toModel", required: true },
  fromModel: { type: String, enum: ["Client", "Freelancer"], required: true },
  toModel: { type: String, enum: ["Client", "Freelancer"], required: true },
  content: { type: String, required: true },
  date: { type: Date, default: Date.now },
});

const MessageModel = model('Message', MessageSchema);

export default MessageModel;