import { userData } from "../constants/userData.js";
import userDataValidator from "../utils/userDataValidator.js";

const {
  EMAIL,
  PASSWORD
} = userData;

const LoginService = ({ email, password }) => {
 
  userDataValidator(EMAIL, email);
  userDataValidator(PASSWORD, password);

  return {
    email: email.toLowerCase(),
    password
  }

};

export default LoginService;
