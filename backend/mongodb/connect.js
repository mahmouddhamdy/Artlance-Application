import { connect, set } from "mongoose";

const connectDB = async (url) => {
  set("strictQuery", true);
  try {
    await connect(url);
    console.log("MongoDB Connected Successfully");
  } catch (err) {
    console.log(err);
  }
};

export default connectDB;
