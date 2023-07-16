import * as dotenv from "dotenv";

dotenv.config();
const { GEOCODER_KEY } = process.env;

export const options = {
  method: 'GET',
  url: 'https://forward-reverse-geocoding.p.rapidapi.com/v1/reverse',
  headers: {
    'X-RapidAPI-Key': GEOCODER_KEY,
    'X-RapidAPI-Host': 'forward-reverse-geocoding.p.rapidapi.com'
  }
};
