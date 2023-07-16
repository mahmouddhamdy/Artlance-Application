import { freelancerPackageData } from "../constants/userData.js";
import freelancerPackageDataValidator from "../utils/freelancerPackageDataValidator.js";

const {
  PHOTOS_NUM,
  DESCRIPTION,
  PRICE
} = freelancerPackageData;

const CreateFreelancerPackageService = ({
  photosNum,
  description,
  price
}) => {

  freelancerPackageDataValidator(PHOTOS_NUM, photosNum);
  freelancerPackageDataValidator(DESCRIPTION, description);
  freelancerPackageDataValidator(PRICE, price);
  
  return {
    photosNum,
    description,
    price
  };
};

export default CreateFreelancerPackageService;
