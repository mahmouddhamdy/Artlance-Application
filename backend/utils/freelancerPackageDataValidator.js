import {
  isNull,
  isEmpty,
  isBetween,
  isNum,
  isString,
} from "./checkValidity.js";
import AppError from "../constants/AppError.js";
import { errorEnum } from "../constants/errorCodes.js";
import { freelancerPackageData } from "../constants/userData.js";

const { ALL_FIELDS_REQUIRED, INVALID_PACKAGE_PHOTOS_NUM, INVALID_PACKAGE_DESCRIPTION, INVALID_PACKAGE_PRICE } = errorEnum;

const { PHOTOS_NUM, DESCRIPTION, PRICE } = freelancerPackageData;

const freelancerPackageDataValidator = (dataType, data) => {
  switch (dataType) {
    case PHOTOS_NUM:
      if (isNull(data)) throw new AppError(ALL_FIELDS_REQUIRED);
      if (!(isNum(data) && isBetween(0, data, 1001)))
        throw new AppError(INVALID_PACKAGE_PHOTOS_NUM);

      break;

    case DESCRIPTION:
      if (isNull(data) || isEmpty(data))
        throw new AppError(ALL_FIELDS_REQUIRED);
      if (!isString(data) || !isBetween(19, data.length, 201))
        throw new AppError(INVALID_PACKAGE_DESCRIPTION);

      break;

    case PRICE:
      if (isNull(data)) throw new AppError(ALL_FIELDS_REQUIRED);
      if (!(isNum(data) && isBetween(9, data, 100001)))
        throw new AppError(INVALID_PACKAGE_PRICE);

      break;

    default:
      if (isNull(data)) throw new AppError(ALL_FIELDS_REQUIRED);
  }
};

export default freelancerPackageDataValidator;
