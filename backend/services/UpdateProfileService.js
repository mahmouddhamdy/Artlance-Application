import { userTypes } from "../constants/models.js";
import { userData } from "../constants/userData.js";
import userDataValidator from "../utils/userDataValidator.js";

const {
  USERNAME,
  FULLNAME,
  PHONE_NUM,
  HOURLY_RATE,
  DESCRIPTION,
  PROFILE_PIC
} = userData;

const UpdateProfileService = ({ username, fullName, profilePic, phoneNum, hourlyRate, description }, userType) => {
  
  const validKeys = {};

  username && userDataValidator(USERNAME, username) && (validKeys.username = username);
  fullName && userDataValidator(FULLNAME, fullName) && (validKeys.fullName = fullName);
  profilePic && userDataValidator(PROFILE_PIC, profilePic) && (validKeys.profilePic = profilePic);

  if (userType === userTypes.FREELANCER) {
    phoneNum && userDataValidator(PHONE_NUM, phoneNum) && (validKeys.phoneNum = phoneNum);
    hourlyRate && userDataValidator(HOURLY_RATE, hourlyRate) && (validKeys.hourlyRate = hourlyRate);
    description && userDataValidator(DESCRIPTION, description) && (validKeys.description = description);
  }

  return validKeys;
};

export default UpdateProfileService;
