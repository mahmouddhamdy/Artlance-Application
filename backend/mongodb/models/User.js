import { Schema, model } from "mongoose";
import { UserInfoSchema } from "./UserInfo.js";

export const UserSchema = new Schema({
  userInfo: { type: UserInfoSchema, required: true },
});

const UserModel = model("User", UserSchema);

export default UserModel;
