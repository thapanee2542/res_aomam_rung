
class PromotionModel {
/*
{
  "promotion_id": "",
  "restaurantId": "",
  "promotion_type": "",
  "promotion_start_date": "",
  "promotion_start_time": "",
  "promotion_finish_date": "",
  "promotion_finish_time": "",
  "foodMenuId_discount": "",
  "promotion_discount": "",
  "promotion_old_price": "",
  "promotion_new_price": "",
  "promotion_buy_one": "",
  "foodMenuId_buy_one": "",
  "promotion_get_one": "",
  "foodMenuId_get_one": ""
} 
*/

  String? promotionId;
  String? restaurantId;
  String? promotionType;
  String? promotionStartDate;
  String? promotionStartTime;
  String? promotionFinishDate;
  String? promotionFinishTime;
  String? foodMenuIdDiscount;
  String? promotionDiscount;
  String? promotionOldPrice;
  String? promotionNewPrice;
  String? promotionBuyOne;
  String? foodMenuIdBuyOne;
  String? promotionGetOne;
  String? foodMenuIdGetOne;

  PromotionModel({
    this.promotionId,
    this.restaurantId,
    this.promotionType,
    this.promotionStartDate,
    this.promotionStartTime,
    this.promotionFinishDate,
    this.promotionFinishTime,
    this.foodMenuIdDiscount,
    this.promotionDiscount,
    this.promotionOldPrice,
    this.promotionNewPrice,
    this.promotionBuyOne,
    this.foodMenuIdBuyOne,
    this.promotionGetOne,
    this.foodMenuIdGetOne,
  });
  PromotionModel.fromJson(Map<String, dynamic> json) {
    promotionId = json["promotion_id"]?.toString();
    restaurantId = json["restaurantId"]?.toString();
    promotionType = json["promotion_type"]?.toString();
    promotionStartDate = json["promotion_start_date"]?.toString();
    promotionStartTime = json["promotion_start_time"]?.toString();
    promotionFinishDate = json["promotion_finish_date"]?.toString();
    promotionFinishTime = json["promotion_finish_time"]?.toString();
    foodMenuIdDiscount = json["foodMenuId_discount"]?.toString();
    promotionDiscount = json["promotion_discount"]?.toString();
    promotionOldPrice = json["promotion_old_price"]?.toString();
    promotionNewPrice = json["promotion_new_price"]?.toString();
    promotionBuyOne = json["promotion_buy_one"]?.toString();
    foodMenuIdBuyOne = json["foodMenuId_buy_one"]?.toString();
    promotionGetOne = json["promotion_get_one"]?.toString();
    foodMenuIdGetOne = json["foodMenuId_get_one"]?.toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["promotion_id"] = promotionId;
    data["restaurantId"] = restaurantId;
    data["promotion_type"] = promotionType;
    data["promotion_start_date"] = promotionStartDate;
    data["promotion_start_time"] = promotionStartTime;
    data["promotion_finish_date"] = promotionFinishDate;
    data["promotion_finish_time"] = promotionFinishTime;
    data["foodMenuId_discount"] = foodMenuIdDiscount;
    data["promotion_discount"] = promotionDiscount;
    data["promotion_old_price"] = promotionOldPrice;
    data["promotion_new_price"] = promotionNewPrice;
    data["promotion_buy_one"] = promotionBuyOne;
    data["foodMenuId_buy_one"] = foodMenuIdBuyOne;
    data["promotion_get_one"] = promotionGetOne;
    data["foodMenuId_get_one"] = foodMenuIdGetOne;
    return data;
  }
}
