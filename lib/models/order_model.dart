import 'dart:developer';

import 'package:wb_bot_2/models/sticker_model.dart';

class OrderModel {
  List<Orders>? orders;

  OrderModel({this.orders});

  OrderModel.fromJson(Map<String, dynamic> json) {
    try {
      if (json['orders'] != null) {
        orders = <Orders>[];
        json['orders'].forEach((v) {
          orders!.add(Orders.fromJson(v));
        });
      }
    } catch (error) {
      log("Error in ordermodel $error");
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  int? id;
  String? rid;
  String? createdAt;
  int? warehouseId;
  List<String>? offices;
  Address? address;
  List<String>? requiredMeta;
  User? user;
  List<String>? skus;
  int? price;
  int? convertedPrice;
  int? currencyCode;
  int? convertedCurrencyCode;
  String? orderUid;
  String? deliveryType;
  int? nmId;
  int? chrtId;
  String? article;
  String? colorCode;
  int? cargoType;
  Stickers? sticker;

  Orders(
      {this.id,
      this.rid,
      this.createdAt,
      this.warehouseId,
      this.offices,
      this.address,
      this.requiredMeta,
      this.user,
      this.sticker,
      this.skus,
      this.price,
      this.convertedPrice,
      this.currencyCode,
      this.convertedCurrencyCode,
      this.orderUid,
      this.deliveryType,
      this.nmId,
      this.chrtId,
      this.article,
      this.colorCode,
      this.cargoType});

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rid = json['rid'];
    createdAt = json['createdAt'];
    warehouseId = json['warehouseId'];
    offices = json['offices'].cast<String>();
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    // requiredMeta = json['requiredMeta'].cast<String>();
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    skus = json['skus'].cast<String>();
    price = json['price'];
    convertedPrice = json['convertedPrice'];
    currencyCode = json['currencyCode'];
    convertedCurrencyCode = json['convertedCurrencyCode'];
    orderUid = json['orderUid'];
    deliveryType = json['deliveryType'];
    nmId = json['nmId'];
    chrtId = json['chrtId'];
    article = json['article'];
    colorCode = json['colorCode'];
    cargoType = json['cargoType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rid'] = this.rid;
    data['createdAt'] = this.createdAt;
    data['warehouseId'] = this.warehouseId;
    data['offices'] = this.offices;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    data['requiredMeta'] = this.requiredMeta;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['skus'] = this.skus;
    data['price'] = this.price;
    data['convertedPrice'] = this.convertedPrice;
    data['currencyCode'] = this.currencyCode;
    data['convertedCurrencyCode'] = this.convertedCurrencyCode;
    data['orderUid'] = this.orderUid;
    data['deliveryType'] = this.deliveryType;
    data['nmId'] = this.nmId;
    data['chrtId'] = this.chrtId;
    data['article'] = this.article;
    data['colorCode'] = this.colorCode;
    data['cargoType'] = this.cargoType;
    return data;
  }
}

class Address {
  String? fullAddress;
  String? province;
  String? area;
  String? city;
  String? street;
  String? home;
  String? flat;
  String? entrance;
  double? longitude;
  double? latitude;

  Address(
      {this.fullAddress,
      this.province,
      this.area,
      this.city,
      this.street,
      this.home,
      this.flat,
      this.entrance,
      this.longitude,
      this.latitude});

  Address.fromJson(Map<String, dynamic> json) {
    fullAddress = json['fullAddress'];
    province = json['province'];
    area = json['area'];
    city = json['city'];
    street = json['street'];
    home = json['home'];
    flat = json['flat'];
    entrance = json['entrance'];
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullAddress'] = this.fullAddress;
    data['province'] = this.province;
    data['area'] = this.area;
    data['city'] = this.city;
    data['street'] = this.street;
    data['home'] = this.home;
    data['flat'] = this.flat;
    data['entrance'] = this.entrance;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    return data;
  }
}

class User {
  String? fio;
  String? phone;

  User({this.fio, this.phone});

  User.fromJson(Map<String, dynamic> json) {
    fio = json['fio'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fio'] = this.fio;
    data['phone'] = this.phone;
    return data;
  }
}
