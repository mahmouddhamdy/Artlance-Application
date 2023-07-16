import { userData } from "../constants/userData.js";
import userDataValidator from "../utils/userDataValidator.js";

const {
  FREELANCER_TYPE,
  ADDRESS,
  PHONE_NUM,
  HOURLY_RATE,
  DESCRIPTION,
} = userData;

const CreateFreelancerInfoService = ({
  freelancerType,
  address,
  phoneNum,
  hourlyRate,
  description,
}) => {

  userDataValidator(FREELANCER_TYPE, freelancerType);
  userDataValidator(ADDRESS, address);
  userDataValidator(PHONE_NUM, phoneNum);
  userDataValidator(HOURLY_RATE, hourlyRate);
  userDataValidator(DESCRIPTION, description);
  
  return {
    freelancerType,
    address,
    phoneNum,
    hourlyRate,
    description,
  };
};

export default CreateFreelancerInfoService;
