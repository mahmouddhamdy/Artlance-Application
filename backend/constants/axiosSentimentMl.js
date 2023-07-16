import * as dotenv from "dotenv";
import axios from "axios";

dotenv.config();
const { SENTIMENT_ML_MODEL_URL } = process.env;

export const axiosInstance = axios.create({
    baseURL: SENTIMENT_ML_MODEL_URL,
    method: "POST",
    responseType: "json"
})
