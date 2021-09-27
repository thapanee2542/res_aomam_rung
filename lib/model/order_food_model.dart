class OrderFoodModel {
  String? id;
  String? customerId;
  String? restaurantId;
  String? foodmenuId;
  String? foodmenuName;
  String? foodmenuPrice;
  String? amount;
  String? netPrice;
  String? orderfoodDateTime;
  String? orderfoodStatus;
  String? orderfoodReasonCancelStatus;
  String? name;
  String? phonenumber;
  String? email;
  String? urlPicture;
  String? restaurantNameshop;
  String? restaurantBranch;
  String? restaurantAddress;
  String? typeOfFood;
  String? promotionId;
  String? promotionDiscount;

  String? paymentId;
  String? paymentDate;
  String? paymentTime;
  String? picture;


  OrderFoodModel(
      {this.id,
      this.customerId,
      this.restaurantId,
      this.foodmenuId,
      this.foodmenuName,
      this.foodmenuPrice,
      this.amount,
      this.netPrice,
      this.orderfoodDateTime,
      this.orderfoodStatus,
      this.orderfoodReasonCancelStatus,
      this.name,
      this.phonenumber,
      this.email,
      this.urlPicture,
      this.restaurantNameshop,
      this.restaurantBranch,
      this.restaurantAddress,
      this.typeOfFood,
      this.promotionId,
      this.promotionDiscount,
      this.paymentId,
      this.paymentDate,
      this.paymentTime,
      this.picture,
      
      });

  OrderFoodModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customerId'];
    restaurantId = json['restaurantId'];
    foodmenuId = json['foodmenuId'];
    foodmenuName = json['foodmenuName'];
    foodmenuPrice = json['foodmenuPrice'];
    amount = json['amount'];
    netPrice = json['netPrice'];
    orderfoodDateTime = json['orderfoodDateTime'];
    orderfoodStatus = json['orderfoodStatus'];
    orderfoodReasonCancelStatus = json['orderfoodReasonCancelStatus'];
    name = json['name'];
    phonenumber = json['phonenumber'];
    email = json['email'];
    urlPicture = json['urlPicture'];
    restaurantNameshop = json['restaurantNameshop'];
    restaurantBranch = json['restaurantBranch'];
    restaurantAddress = json['restaurantAddress'];
    typeOfFood = json['typeOfFood'];
    promotionId = json['promotionId'];
    promotionDiscount = json['promotion_discount'];
    paymentId = json['paymentId'];
    paymentDate = json['paymentDate'];
    paymentTime = json['paymentTime'];
    picture = json['picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customerId'] = this.customerId;
    data['restaurantId'] = this.restaurantId;
    data['foodmenuId'] = this.foodmenuId;
    data['foodmenuName'] = this.foodmenuName;
    data['foodmenuPrice'] = this.foodmenuPrice;
    data['amount'] = this.amount;
    data['netPrice'] = this.netPrice;
    data['orderfoodDateTime'] = this.orderfoodDateTime;
    data['orderfoodStatus'] = this.orderfoodStatus;
    data['orderfoodReasonCancelStatus'] = this.orderfoodReasonCancelStatus;
    data['name'] = this.name;
    data['phonenumber'] = this.phonenumber;
    data['email'] = this.email;
    data['urlPicture'] = this.urlPicture;
    data['restaurantNameshop'] = this.restaurantNameshop;
    data['restaurantBranch'] = this.restaurantBranch;
    data['restaurantAddress'] = this.restaurantAddress;
    data['typeOfFood'] = this.typeOfFood;
    data['promotionId'] = this.promotionId;
    data['promotion_discount'] = this.promotionDiscount;
    data['paymentId'] = this.paymentId;
    data['paymentDate'] = this.paymentDate;
    data['paymentTime'] = this.paymentTime;
    data['picture'] = this.picture;
    return data;
  }
}