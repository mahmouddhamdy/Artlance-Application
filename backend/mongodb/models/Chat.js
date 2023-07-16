import { Schema, model } from "mongoose";

const ChatSchema = new Schema({
  client: { type: Schema.Types.ObjectId, ref: "Client", required: true },
  freelancer: { type: Schema.Types.ObjectId, ref: "Freelancer", required: true },
  messages: [{ type: Schema.Types.ObjectId, ref: "Message" }],
});

const ChatModel = model("Chat", ChatSchema);

export default ChatModel;