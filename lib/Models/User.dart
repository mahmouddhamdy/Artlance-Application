class User {
  String name,image,location,email,password,username;
  bool isFreelancer;

  User({
    this.username='',
    this.name = '',
    this.location = '',
    this.image = '',
    this.email='',
    this.password='',
    this.isFreelancer=false,
  });
}