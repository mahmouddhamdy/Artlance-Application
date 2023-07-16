import AppError from "../constants/AppError.js";
import { axiosInstance } from "../constants/axiosSentimentMl.js"
import { errorEnum } from "../constants/errorCodes.js";

const SentimentalAnalysisService = async (content) => {
    try {
      const { data } = await axiosInstance.request({
        url: '/model',
        params: {
            sentence: content
        }
      });
      if(data.error) throw new Error;
      return data;
    } catch (err) {
      return new AppError(errorEnum.ML_MODEL_API_ERROR);
    }
  };
  
  export default SentimentalAnalysisService;