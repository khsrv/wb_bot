import 'dart:math';

import 'package:wb_bot_2/data/api/order_api_client.dart';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wb_bot_2/models/order_model.dart';
import 'package:wb_bot_2/models/sticker_model.dart';
import 'package:wb_bot_2/models/supplies_model.dart';
import 'package:wb_bot_2/widgets/error/failure.dart';

class OrderRepository {
  late OrderApiClient _client;

  OrderRepository() {
    _client = OrderApiClient(
      dio: Dio(
        BaseOptions(contentType: "application/json", headers: {
          'Authorization': '${dotenv.env['GUM_TOKEN']}',
        }),
      ),
    );
  }

  Future<Either<List<Supplies>, Failure>> getSupplies() async {
    final result = _client.getSupplies();

    return result;
  }

  Future<Either<OrderModel, Failure>> getNewOrders() async {
    final result = _client.getNewOrders();
    return result;
  }

  Future<Either<OrderModel, Failure>> getOrdersBySupplyId(
      {required String supplydId}) async {
    final result = _client.getOrdersBySupplyId(supplyId: supplydId);
    return result;
  }

  Future<Either<StickkerModel, Failure>> getStickersByListOfOrderIds(
      {required List<int> orderIds}) async {
    final result = _client.getStickersByListOfOrderIds(orderIds: orderIds);
    return result;
  }
}
