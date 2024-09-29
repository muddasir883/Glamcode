// To parse this JSON data, do
//
//     final bookingsModel = bookingsModelFromJson(jsonString);

import 'dart:convert';

BookingsModel bookingsModelFromJson(String str) => BookingsModel.fromJson(json.decode(str));

String bookingsModelToJson(BookingsModel data) => json.encode(data.toJson());

class BookingsModel {
  String? status;
  String? message;
  List<OngoingBookingsArr>? ongoingBookingsArr;

  BookingsModel({
    this.status,
    this.message,
    this.ongoingBookingsArr,
  });

  factory BookingsModel.fromJson(Map<String, dynamic> json) => BookingsModel(
    status: json["status"],
    message: json["message"],
    ongoingBookingsArr: json["OngoingBookingsArr"] == null ? [] : List<OngoingBookingsArr>.from(json["OngoingBookingsArr"]!.map((x) => OngoingBookingsArr.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "OngoingBookingsArr": ongoingBookingsArr == null ? [] : List<dynamic>.from(ongoingBookingsArr!.map((x) => x.toJson())),
  };
}

class OngoingBookingsArr {
  String? userName;
  int? bookingId;
  bool? bookingAssigned;
  int? assignedBookingId;
  int? beauticianId;
  String? beauticianName;
  String? beauticianPhone;
  String? bookingOrderDate;
  DateTime? bookingDate;
  String? bookingTime;
  String? paymentGateway;
  String? orderStatus;
  int? serviceCharge;
  double? discountedPrice;
  double? savePrice;
  int? safetyHygieneFee;
  int? transportationFee;
  double? totalAmount;
  String? paymentStatus;
  String? serviceName;
  String? serviceImage;
  int? serviceTime;
  String? serviceMainCat;
  String? serviceCat;

  OngoingBookingsArr({
    this.userName,
    this.bookingId,
    this.bookingAssigned,
    this.assignedBookingId,
    this.beauticianId,
    this.beauticianName,
    this.beauticianPhone,
    this.bookingOrderDate,
    this.bookingDate,
    this.bookingTime,
    this.paymentGateway,
    this.orderStatus,
    this.serviceCharge,
    this.discountedPrice,
    this.savePrice,
    this.safetyHygieneFee,
    this.transportationFee,
    this.totalAmount,
    this.paymentStatus,
    this.serviceName,
    this.serviceImage,
    this.serviceTime,
    this.serviceMainCat,
    this.serviceCat,
  });

  factory OngoingBookingsArr.fromJson(Map<String, dynamic> json) => OngoingBookingsArr(
    userName: json["user_name"],
    bookingId: json["booking_id"],
    bookingAssigned: json["bookingAssigned"],
    assignedBookingId: json["assignedBookingID"],
    beauticianId: json["beauticianID"],
    beauticianName: json["beautician_name"],
    beauticianPhone: json["beautician_phone"],
    bookingOrderDate: json["booking_order_date"],
    bookingDate: json["booking_date"] == null ? null : DateTime.parse(json["booking_date"]),
    bookingTime: json["booking_time"],
    paymentGateway: json["payment_gateway"],
    orderStatus: json["order_status"],
    serviceCharge: json["service_charge"],
    discountedPrice: json["discounted_price"]?.toDouble(),
    savePrice: json["save_price"]?.toDouble(),
    safetyHygieneFee: json["safety_hygiene_fee"],
    transportationFee: json["transportation_fee"],
    totalAmount: json["total_amount"]?.toDouble(),
    paymentStatus: json["payment_status"],
    serviceName: json["service_name"],
    serviceImage: json["service_image"],
    serviceTime: json["service_time"],
    serviceMainCat: json["service_main_cat"],
    serviceCat: json["service_cat"],
  );

  Map<String, dynamic> toJson() => {
    "user_name": userName,
    "booking_id": bookingId,
    "bookingAssigned": bookingAssigned,
    "assignedBookingID": assignedBookingId,
    "beauticianID": beauticianId,
    "beautician_name": beauticianName,
    "beautician_phone": beauticianPhone,
    "booking_order_date": bookingOrderDate,
    "booking_date": "${bookingDate!.year.toString().padLeft(4, '0')}-${bookingDate!.month.toString().padLeft(2, '0')}-${bookingDate!.day.toString().padLeft(2, '0')}",
    "booking_time": bookingTime,
    "payment_gateway": paymentGateway,
    "order_status": orderStatus,
    "service_charge": serviceCharge,
    "discounted_price": discountedPrice,
    "save_price": savePrice,
    "safety_hygiene_fee": safetyHygieneFee,
    "transportation_fee": transportationFee,
    "total_amount": totalAmount,
    "payment_status": paymentStatus,
    "service_name": serviceName,
    "service_image": serviceImage,
    "service_time": serviceTime,
    "service_main_cat": serviceMainCat,
    "service_cat": serviceCat,
  };
}
