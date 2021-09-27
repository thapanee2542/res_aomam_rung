class ReserveDetailsModel {
  String? reservationId;
  String? customerId;
  String? restaurantId;
  String? tableResId;
  String? restaurantNameshop;
  String? numberOfGueste;
  String? reservationDate;
  String? reservationTime;
  String? orderfoodId;
  String? foodmenuId;
  String? foodmenuName;
  String? foodmenuPrice;
  String? amount;
  String? netPrice;
  String? orderfoodDateTime;
  String? reservationStatus;
  String? name;
  String? email;
  String? phonenumber;
  String? urlPicture;
  String? tableName;
  String? tableNumseat;
  String? tableDescrip;
  String? tablePicOne;
  String? restaurantPicture;
  String? restaurantBranch;
  String? restaurantAddress;
  String? typeOfFood;

  ReserveDetailsModel(
      {this.reservationId,
      this.customerId,
      this.restaurantId,
      this.tableResId,
      this.restaurantNameshop,
      this.numberOfGueste,
      this.reservationDate,
      this.reservationTime,
      this.orderfoodId,
      this.foodmenuId,
      this.foodmenuName,
      this.foodmenuPrice,
      this.amount,
      this.netPrice,
      this.orderfoodDateTime,
      this.reservationStatus,
      this.name,
      this.email,
      this.phonenumber,
      this.urlPicture,
      this.tableName,
      this.tableNumseat,
      this.tableDescrip,
      this.tablePicOne,
      this.restaurantPicture,
      this.restaurantBranch,
      this.restaurantAddress,
      this.typeOfFood});

  ReserveDetailsModel.fromJson(Map<String, dynamic> json) {
    reservationId = json['reservationId'];
    customerId = json['customerId'];
    restaurantId = json['restaurantId'];
    tableResId = json['tableResId'];
    restaurantNameshop = json['restaurantNameshop'];
    numberOfGueste = json['numberOfGueste'];
    reservationDate = json['reservationDate'];
    reservationTime = json['reservationTime'];
    orderfoodId = json['orderfoodId'];
    foodmenuId = json['foodmenuId'];
    foodmenuName = json['foodmenuName'];
    foodmenuPrice = json['foodmenuPrice'];
    amount = json['amount'];
    netPrice = json['netPrice'];
    orderfoodDateTime = json['orderfoodDateTime'];
    reservationStatus = json['reservationStatus'];
    name = json['name'];
    email = json['email'];
    phonenumber = json['phonenumber'];
    urlPicture = json['urlPicture'];
    tableName = json['tableName'];
    tableNumseat = json['tableNumseat'];
    tableDescrip = json['tableDescrip'];
    tablePicOne = json['tablePicOne'];
    restaurantPicture = json['restaurantPicture'];
    restaurantBranch = json['restaurantBranch'];
    restaurantAddress = json['restaurantAddress'];
    typeOfFood = json['typeOfFood'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reservationId'] = this.reservationId;
    data['customerId'] = this.customerId;
    data['restaurantId'] = this.restaurantId;
    data['tableResId'] = this.tableResId;
    data['restaurantNameshop'] = this.restaurantNameshop;
    data['numberOfGueste'] = this.numberOfGueste;
    data['reservationDate'] = this.reservationDate;
    data['reservationTime'] = this.reservationTime;
    data['orderfoodId'] = this.orderfoodId;
    data['foodmenuId'] = this.foodmenuId;
    data['foodmenuName'] = this.foodmenuName;
    data['foodmenuPrice'] = this.foodmenuPrice;
    data['amount'] = this.amount;
    data['netPrice'] = this.netPrice;
    data['orderfoodDateTime'] = this.orderfoodDateTime;
    data['reservationStatus'] = this.reservationStatus;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phonenumber'] = this.phonenumber;
    data['urlPicture'] = this.urlPicture;
    data['tableName'] = this.tableName;
    data['tableNumseat'] = this.tableNumseat;
    data['tableDescrip'] = this.tableDescrip;
    data['tablePicOne'] = this.tablePicOne;
    data['restaurantPicture'] = this.restaurantPicture;
    data['restaurantBranch'] = this.restaurantBranch;
    data['restaurantAddress'] = this.restaurantAddress;
    data['typeOfFood'] = this.typeOfFood;
    return data;
  }
}
