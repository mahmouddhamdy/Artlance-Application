import { isArray, isString, isEmpty } from "./checkValidity.js";

export default function removeDuplicates(array, property) {
  if (!isArray(array) || !isString(property) || isEmpty(property)) return [];

  const uniqueValues = {};

  return array.filter((item) => {
    const value = item[property];

    if (!uniqueValues[value]) {
      uniqueValues[value] = true;
      return true;
    }

    return false;
  });
}
