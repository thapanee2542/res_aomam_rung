class AllDiscountPromotion {
  String? allDiscountId;
  String? restaurantId;
  String? allDiscountType;
  String? allDiscountAmount;
  String? allDiscountStartDate;
  String? allDiscountStartTime;
  String? allDiscountFinishDate;
  String? allDiscountFinishTime;

  AllDiscountPromotion(
      {this.allDiscountId,
      this.restaurantId,
      this.allDiscountType,
      this.allDiscountAmount,
      this.allDiscountStartDate,
      this.allDiscountStartTime,
      this.allDiscountFinishDate,
      this.allDiscountFinishTime});

  AllDiscountPromotion.fromJson(Map<String, dynamic> json) {
    allDiscountId = json['all_discount_id'];
    restaurantId = json['restaurantId'];
    allDiscountType = json['all_discount_type'];
    allDiscountAmount = json['all_discount_amount'];
    allDiscountStartDate = json['all_discount_start_date'];
    allDiscountStartTime = json['all_discount_start_time'];
    allDiscountFinishDate = json['all_discount_finish_date'];
    allDiscountFinishTime = json['all_discount_finish_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['all_discount_id'] = this.allDiscountId;
    data['restaurantId'] = this.restaurantId;
    data['all_discount_type'] = this.allDiscountType;
    data['all_discount_amount'] = this.allDiscountAmount;
    data['all_discount_start_date'] = this.allDiscountStartDate;
    data['all_discount_start_time'] = this.allDiscountStartTime;
    data['all_discount_finish_date'] = this.allDiscountFinishDate;
    data['all_discount_finish_time'] = this.allDiscountFinishTime;
    return data;
  }
}