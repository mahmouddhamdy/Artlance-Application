import { Schema, model } from "mongoose";

const TokenSchema = new Schema({
  _userId: { type: Schema.Types.ObjectId, ref: "UserInfo", required: true },
  token: { type: String, required: true },
});

const TokenModel = model("Token", TokenSchema);

export default TokenModel;