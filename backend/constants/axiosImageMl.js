import * as dotenv from "dotenv";
import axios from "axios";

dotenv.config();
const { IMAGE_ML_MODEL_URL } = process.env;

export const axiosInstance = axios.create({
    baseURL: IMAGE_ML_MODEL_URL,
    method: "POST",
    responseType: "json"
})
