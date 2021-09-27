class ReservationModel {
  String? reservationId;
  String? customerId;
  String? restaurantId;
  String? tableResId;
  String? restaurantNameshop;
  String? numberOfGueste;
  String? reservationDate;
  String? reservationTime;
  String? reservationStatus;

  ReservationModel(
      {this.reservationId,
      this.customerId,
      this.restaurantId,
      this.tableResId,
      this.restaurantNameshop,
      this.numberOfGueste,
      this.reservationDate,
      this.reservationTime,
      this.reservationStatus
      });

  ReservationModel.fromJson(Map<String, dynamic> json) {
    reservationId = json['reservationId'];
    customerId = json['customerId'];
    restaurantId = json['restaurantId'];
    tableResId = json['tableResId'];
    restaurantNameshop = json['restaurantNameshop'];
    numberOfGueste = json['numberOfGueste'];
    reservationDate = json['reservationDate'];
    reservationTime = json['reservationTime'];
reservationStatus = json['reservationStatus'];

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
    data['reservationStatus'] = this.reservationStatus;
    return data;
  }
}
