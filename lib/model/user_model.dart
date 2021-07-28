class UserModel {
  String? id;
  String? chooseType;
  String? name;
  String? user;
  String? email;
  String? phonenumber;
  String? password;
  String? confirmpassword;

  UserModel(
      {this.id,
      this.chooseType,
      this.name,
      this.user,
      this.email,
      this.phonenumber,
      this.password,
      this.confirmpassword});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chooseType = json['chooseType'];
    name = json['name'];
    user = json['user'];
    email = json['email'];
    phonenumber = json['phonenumber'];
    password = json['password'];
    confirmpassword = json['confirmpassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['chooseType'] = this.chooseType;
    data['name'] = this.name;
    data['user'] = this.user;
    data['email'] = this.email;
    data['phonenumber'] = this.phonenumber;
    data['password'] = this.password;
    data['confirmpassword'] = this.confirmpassword;
    return data;
  }
}
