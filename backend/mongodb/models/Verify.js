import { Schema, model } from "mongoose";

export const UserverfiyModel = new Schema({
  userid: { type: String},
  uniqueString: { type: String},
  createdate: { type: Date},
  expiredate: { type: Date},
});

const verifymodel = model("Verify", UserverfiyModel);

export default verifymodel;
