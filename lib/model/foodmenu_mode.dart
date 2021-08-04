class FoodMenuModel {
  String? foodMenuId;
  String? restaurantId;
  String? foodMenuName;
  String? foodMenuPrice;
  String? foodMenuPicture;
  String? foodMenuDescrip;
  String? foodMenuStatus;

  FoodMenuModel(
      {this.foodMenuId,
      this.restaurantId,
      this.foodMenuName,
      this.foodMenuPrice,
      this.foodMenuPicture,
      this.foodMenuDescrip,
      this.foodMenuStatus});

  FoodMenuModel.fromJson(Map<String, dynamic> json) {
    foodMenuId = json['foodMenuId'];
    restaurantId = json['restaurantId'];
    foodMenuName = json['foodMenuName'];
    foodMenuPrice = json['foodMenuPrice'];
    foodMenuPicture = json['foodMenuPicture'];
    foodMenuDescrip = json['foodMenuDescrip'];
    foodMenuStatus = json['foodMenuStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['foodMenuId'] = this.foodMenuId;
    data['restaurantId'] = this.restaurantId;
    data['foodMenuName'] = this.foodMenuName;
    data['foodMenuPrice'] = this.foodMenuPrice;
    data['foodMenuPicture'] = this.foodMenuPicture;
    data['foodMenuDescrip'] = this.foodMenuDescrip;
    data['foodMenuStatus'] = this.foodMenuStatus;
    return data;
  }
}
