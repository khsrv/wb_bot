import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wb_bot_2/models/order_model.dart';
import 'package:wb_bot_2/models/sticker_model.dart';
import 'package:wb_bot_2/models/supplies_model.dart';
import 'package:wb_bot_2/widgets/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:wb_bot_2/widgets/error/internet_check.dart';

class OrderApiClient {
  final Dio dio;
  String? baseUrl;

  OrderApiClient({required this.dio}) {
    baseUrl = dotenv.env['API_URL'];
  }

  Future<Either<List<Supplies>, Failure>> getSupplies() async {
    int next = 0;
    List<Supplies> suppliseList = [];
    try {
      bool hasConnection = await NetworkInfo.isConnected();
      if (!hasConnection) {
        return const Right(
          ConnectionFailure(
            message: 'Нет подключения к интернету',
          ),
        );
      } else {
        while (next != -1) {
          var response = await dio.get(
              'https://suppliers-api.wildberries.ru/api/v3/supplies?',
              queryParameters: {'limit': 1000, 'next': next});
          if (response.statusCode == 200 || response.statusCode == 201) {
            next = response.data['next'];
            var list = response.data['supplies'] as List;
            for (var item in list) {
              if (item['done'] == false) {
                suppliseList.add(Supplies.fromJson(item));
              }
            }
            if (next == 0) {
              return Left(
                suppliseList,
              );
            }
          }
        }
        return Left(
          suppliseList,
        );
      }
    } catch (error) {
      if (error is DioError) {}
      return const Right(
        ServerFailuer(
          message: 'Ошибка авторизации',
        ),
      );
    }
  }

  Future<Either<OrderModel, Failure>> getNewOrders() async {
    int next = 0;
    try {
      bool hasConnection = await NetworkInfo.isConnected();
      if (!hasConnection) {
        return const Right(
          ConnectionFailure(
            message: 'Нет подключения к интернету',
          ),
        );
      } else {
        while (next != -1) {
          var response = await dio.get(
            'https://suppliers-api.wildberries.ru/api/v3/orders/new',
            // queryParameters: {'limit': 1000, 'next': next},
          );
          if (response.statusCode == 200 || response.statusCode == 201) {
            return Left(
              OrderModel.fromJson(response.data),
            );
          }
        }
        return const Right(
          ServerFailuer(
            message: 'Ошибка авторизации',
          ),
        );
      }
    } catch (error) {
      if (error is DioError) {}
      return const Right(
        ServerFailuer(
          message: 'Ошибка авторизации',
        ),
      );
    }
  }

  Future<Either<OrderModel, Failure>> getOrdersBySupplyId(
      {required String supplyId}) async {
    int next = 0;
    try {
      bool hasConnection = await NetworkInfo.isConnected();
      if (!hasConnection) {
        return const Right(
          ConnectionFailure(
            message: 'Нет подключения к интернету',
          ),
        );
      } else {
        while (next != -1) {
          var response = await dio.get(
            'https://suppliers-api.wildberries.ru/api/v3/supplies/$supplyId/orders',
            // queryParameters: {'limit': 1000, 'next': next},
          );
          if (response.statusCode == 200 || response.statusCode == 201) {
            return Left(
              OrderModel.fromJson(response.data),
            );
          }
        }
        return const Right(
          ServerFailuer(
            message: 'Ошибка авторизации',
          ),
        );
      }
    } catch (error) {
      if (error is DioError) {}
      return const Right(
        ServerFailuer(
          message: 'Ошибка авторизации',
        ),
      );
    }
  }

  Future<Either<StickkerModel, Failure>> getStickersByListOfOrderIds(
      {required List<int> orderIds}) async {
    int next = 0;
    try {
      bool hasConnection = await NetworkInfo.isConnected();
      if (!hasConnection) {
        return const Right(
          ConnectionFailure(
            message: 'Нет подключения к интернету',
          ),
        );
      } else {
        while (next != -1) {
          var response = await dio.post(
              'https://suppliers-api.wildberries.ru/api/v3/orders/stickers',
              queryParameters: {'type': 'png', 'width': 58, 'height': 40},
              data: {"orders": orderIds});
          if (response.statusCode == 200 || response.statusCode == 201) {
            log("response ${response.data}");
            return Left(
              StickkerModel.fromJson(response.data),
            );
          }
        }
        return const Right(
          ServerFailuer(
            message: 'Ошибка авторизации',
          ),
        );
      }
    } catch (error) {
      if (error is DioError) {
        log(" stickers error ${error}");
      }
      return const Right(
        ServerFailuer(
          message: 'Ошибка авторизации',
        ),
      );
    }
  }
}
