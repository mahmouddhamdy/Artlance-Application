
import 'freelancerSpeciality.dart';

class Freelancer {
  String address,description,phoneNumber;
  var hourlyRate;
  Speciality speciality;

  Freelancer({
    this.address = '',
    this.description='',
    this.phoneNumber='',
    this.hourlyRate = 0,
    required this.speciality,
});
}

