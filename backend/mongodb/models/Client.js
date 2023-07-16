import { Schema, model } from "mongoose";
import { UserInfoSchema } from "./UserInfo.js";
import { userTypes } from "../../constants/models.js";

const ClientSchema = new Schema({
  ...UserInfoSchema.obj,
  userType: {
    type: String,
    enum: Object.values(userTypes),
    default: userTypes.CLIENT
  },
  favList: [{ type: Schema.Types.ObjectId, ref: "Freelancer" }],
  visitList: [{ type: Schema.Types.ObjectId, ref: "Freelancer" }]
});

const ClientModel = model("Client", ClientSchema);

export default ClientModel;
