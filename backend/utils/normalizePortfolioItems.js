import { isArray } from "./checkValidity.js";

export default function normalizePortfolioItems(array) {
  if (!isArray(array)) return [];

  const items = {};

  array.forEach(item => {
    if(item._id && item.features) items[item._id] = item.features;
  })

  return items
}
