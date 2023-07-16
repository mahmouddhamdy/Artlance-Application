import 'package:flutter/material.dart';

class myProvider with ChangeNotifier {
  String? id, username, fullName, email;
  bool? isFreelancer;
  late int homePageIndex = 0;
  String? freelancerType,phoneNum,description;
  int? hourlyRate;
  List? availablePages;
  int portfolioItemIndex = 0;
  int searchIndex = 0;
  var rate;

  incrementIndex() {
    portfolioItemIndex++;
    notifyListeners();
  }

  incrementSearchIndex() {
    searchIndex++;
    notifyListeners();
  }

  setRate(var rate) {
    this.rate = rate;
    notifyListeners();
  }

  setAvailablePages(List pages) {
    availablePages = pages;
  }

  void changeUsername(String newUsername) {
    username = newUsername;
    notifyListeners();
  }


  void changeName(String name) {
    fullName = name;
    notifyListeners();
  }

  void changeMail(String mail) {
    email = mail;
    notifyListeners();
  }

  void changeID(String ID) {
    id = ID;
    notifyListeners();
  }

  void selectType(bool isFree) {
    isFreelancer = isFree;
    notifyListeners();
  }

  void changeIndex(int index) {
    homePageIndex = index;
    notifyListeners();
  }

  void selectFreelancingType(String type) {
    freelancerType = type;
    notifyListeners();
  }

  void changePhoneNum(String phone) {
    phoneNum = phone;
    notifyListeners();
  }

  void changeHourlyRate(int HR) {
    hourlyRate = HR;
    notifyListeners();
  }
  void changeDescription(String description) {
    this.description = description;
    notifyListeners();
  }

}
