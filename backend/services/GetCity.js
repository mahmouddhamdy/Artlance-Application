import axios from "axios";
import AppError from "../constants/AppError.js";
import { options } from "../constants/axiosGeocoding.js";
import { errorEnum } from "../constants/errorCodes.js";

const GetCity = async (lat, lon) => {
  try {
    const { data } = await axios.request({
      ...options,
      params: {
        lat,
        lon,
        "accept-language": "en",
        polygon_threshold: "0.0",
      },
    });
    if(data.error) throw new AppError;
    return data;
  } catch (err) {
    return new AppError(errorEnum.LOCATION_API_ERROR);
  }
};

export default GetCity;
