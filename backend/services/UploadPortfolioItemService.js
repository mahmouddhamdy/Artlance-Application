import AppError from "../constants/AppError.js";
import { axiosInstance } from "../constants/axiosImageMl.js"
import { errorEnum } from "../constants/errorCodes.js";

const UploadPortfolioItemService = async (url) => {
    try {
      const { data } = await axiosInstance.request({
        url: '/upload',
        data: {
            image_url: url
        }
      });
      if(data.error) throw new Error;
      return data;
    } catch (err) {
      return new AppError(errorEnum.ML_MODEL_API_ERROR);
    }
  };
  
  export default UploadPortfolioItemService;