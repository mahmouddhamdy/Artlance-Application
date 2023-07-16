import { hashSync } from "bcrypt";
import { userData } from "../constants/userData.js";
import userDataValidator from "../utils/userDataValidator.js";

const {
  USERNAME,
  PROFILE_PIC,
  FULLNAME,
  EMAIL,
  PASSWORD
} = userData;

const CreateUserInfoService = ({ username, profilePic, fullName, email, password }) => {

  userDataValidator(USERNAME, username);
  userDataValidator(PROFILE_PIC, profilePic);
  userDataValidator(FULLNAME, fullName);
  userDataValidator(EMAIL, email);
  userDataValidator(PASSWORD, password);

  // hash plain password
  const hashPass = hashSync(password, 15);

  return {
    username,
    profilePic,
    fullName,
    email: email.toLowerCase(),
    password: hashPass,
  };
};

export default CreateUserInfoService;
