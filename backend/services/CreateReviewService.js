import { reviewData } from "../constants/userData.js";
import reviewDataValidator from "../utils/reviewDataValidator.js";

const { CONTENT } = reviewData;

const CreateReviewService = ({ content }) => {
  
  reviewDataValidator(CONTENT, content);

  return {
    content
  }

};

export default CreateReviewService;
