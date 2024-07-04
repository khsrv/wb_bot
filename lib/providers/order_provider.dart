import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:wb_bot_2/common/icons.dart';
import 'package:wb_bot_2/data/repository/order_repository.dart';
import 'package:wb_bot_2/models/order_model.dart';
import 'package:wb_bot_2/models/sticker_model.dart';

import 'package:wb_bot_2/models/supplies_model.dart';

import 'package:pdf/pdf.dart';

class OrderProvider extends ChangeNotifier {
  List<Supplies> supplies = [];
  Map<String, int> groupedOrders = {};

  OrderProvider() {
    isLoading = true;
  }
  OrderRepository orderRepository = OrderRepository();
  OrderModel orderModel = OrderModel();
  OrderModel orderModelBySupply = OrderModel();

  Supplies? selectedSupplyModel;
  StickkerModel? stickkerModel;
  File? stickerfile;

  //for all providers
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool flag) {
    _isLoading = flag;
    notifyListeners();
  }

  Future getSuppliesList() async {
    isLoading = true;

    var result = await orderRepository.getSupplies();
    result.fold((data) {
      supplies = data;
    }, (error) {});
    isLoading = false;
  }

  Future getNewOrders({bool loading = true}) async {
    if (loading) {
      isLoading = true;
    }
    var result = await orderRepository.getNewOrders();
    result.fold((data) {
      orderModel = data;
    }, (error) {});
    if (loading) {
      isLoading = false;
    }
    notifyListeners();
  }

  Future getOrdersBySupply(
      {bool loading = true, required String supplyId}) async {
    if (loading) {
      isLoading = true;
    }
    var result = await orderRepository.getOrdersBySupplyId(supplydId: supplyId);

    result.fold((data) {
      orderModelBySupply = data;
      log("orderModelBySupply ${data.orders!.length}");
      groupOrderByArticule(data.orders ?? []);
    }, (error) {
      log("error ${error}");
    });
    if (loading) {
      isLoading = false;
    }
    notifyListeners();
  }

  List<List<int>> splitList(List<int> originalList) {
    List<List<int>> result = [];

    for (int i = 0; i < originalList.length; i += 100) {
      // Определяем индекс последнего элемента в подсписке
      int endIndex = i + 100;
      // Если индекс последнего элемента больше, чем длина исходного списка,
      // то берем элементы до конца списка
      if (endIndex > originalList.length) {
        endIndex = originalList.length;
      }
      // Создаем подсписок из элементов исходного списка
      result.add(originalList.sublist(i, endIndex));
    }

    return result;
  }

  Future printListOrder(String tittle) async {
    final pdf = pw.Document();
    final fontText = await rootBundle.load(
        "/Users/akubiabdukahhor/Desktop/projects/wb_bot_2/assets/fonts/montserrat.ttf");
    pdf.addPage(
      pw.Page(
        pageFormat: const PdfPageFormat(2480, 3508),
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(150),
            child: pw.Column(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 50),
                  child: pw.Text(
                    tittle,
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      font: Font.ttf(fontText),
                      fontSize: 100,
                    ),
                  ),
                ),
                pw.Expanded(
                    child: pw.GridView(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  children: List.generate(
                    groupedOrders.length,
                    (int index) {
                      return pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                '${(index + 1)}. ${groupedOrders.keys.toList()[index]}: ',
                                textAlign: pw.TextAlign.center,
                                overflow: pw.TextOverflow.clip,
                                style: pw.TextStyle(
                                  font: Font.ttf(fontText),
                                  fontSize: 35,
                                ),
                              ),
                              pw.Expanded(
                                child: pw.Padding(
                                    padding: const pw.EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: pw.Divider(
                                        color: const PdfColor(0, 0, 0))),
                              ),
                              pw.Padding(
                                padding: pw.EdgeInsets.only(right: 100),
                                child: pw.Text(
                                  '${groupedOrders.values.toList()[index]} шт.',
                                  textAlign: pw.TextAlign.center,
                                  style: pw.TextStyle(
                                    font: Font.ttf(fontText),
                                    fontSize: 35,
                                  ),
                                ),
                              ),

                              // pw.SizedBox(width: 100)
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                )
                    // child: pw.Column(
                    //   children:
                    // ),
                    )
              ],
            ),
          );
        },
      ),
    );
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'order_list.pdf',
    );
  }

  Future<List<Orders>> printStickers({required List<Orders> orders}) async {
    List<int> orderIds = [];
    List<Orders> orderWithSticker = orders;
    List<Stickers> stickers = [];
    for (var order in orders) {
      orderIds.add(order.id!);
    }
    List<List<int>> splitLisstLess100 = splitList(orderIds);

    for (var idList in splitLisstLess100) {
      var list = await getStickersByOrderIds(orderIds: idList);
      stickers.addAll(list);
      await Future.delayed(const Duration(seconds: 1));
    }
    for (var order in orderWithSticker) {
      order.sticker = stickers
          .where(
            (element) => element.orderId.toString() == order.id.toString(),
          )
          .first;
    }
    groupedOrders = groupOrderByArticule(orderWithSticker);
    final pdf = pw.Document();
    final fontText = await rootBundle.load(
        "/Users/akubiabdukahhor/Desktop/projects/wb_bot_2/assets/fonts/montserrat.ttf");

    groupedOrders.forEach(
      (key, value) async {
        pdf.addPage(
          pw.Page(
            pageFormat: const PdfPageFormat(220.030349, 151.745068),
            build: (pw.Context context) {
              return pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Center(
                      child: pw.Text(
                        '^',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          font: Font.ttf(fontText),
                          fontSize: 30,
                        ),
                      ),
                    ),
                    pw.Center(
                      child: pw.Text(
                        '|',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          font: Font.ttf(fontText),
                          fontSize: 30,
                        ),
                      ),
                    ),
                    pw.Center(
                      child: pw.Text(
                        "$key\nкол: $valueшт.",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          font: Font.ttf(fontText),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ]); //
            },
          ),
        );
        var productOrders = orderWithSticker
            .where(
              (element) => element.article.toString() == key,
            )
            .toList();
        for (var order in productOrders) {
          final bytes = base64Decode(order.sticker!.file!);
          pdf.addPage(
            pw.Page(
              pageFormat: const PdfPageFormat(220.030349, 151.745068),
              build: (pw.Context context) {
                return pw.Image(pw.MemoryImage(bytes),
                    width: 220.030349, height: 151.745068); // Center
              },
            ),
          );
        }
      },
    );
    // share pdf
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'stickers.pdf',
    );

    // await Printing.layoutPdf(
    //     onLayout: (PdfPageFormat format) async => pdf.save());

    return orderWithSticker;
  }

//   Future<File> createFileINfo() async {
// // // Create a new PDF document.
// //     final PdfDocument document = PdfDocument();
// // // Add a PDF page and draw text.
// //     groupedOrders.forEach((key, value) {
// //       document.pages.add().graphics.drawString(
// //           '${key} : ${value}', PdfStandardFont(PdfFontFamily.helvetica, 12),
// //           brush: PdfSolidBrush(PdfColor(0, 0, 0)),
// //           bounds: const Rect.fromLTWH(0, 0, 150, 20));
// //     });

// // // Save the document.

// // // Dispose the document.
// //     document.dispose();
// //     stickerfile =
// //         await File('stickers.pdf').writeAsBytes(await document.save());

// //     return stickerfile!;
//   }

  Future<List<Stickers>> getStickersByOrderIds(
      {required List<int> orderIds}) async {
    List<Stickers> stickers = [];
    var result =
        await orderRepository.getStickersByListOfOrderIds(orderIds: orderIds);
    result.fold(
      (data) {
        stickkerModel = data;
        stickers = data.stickers ?? [];
      },
      (error) {
        log("error ${error}");
      },
    );
    return stickers;
  }

  Future<File> decodeFile(String path, String orderID) async {
    List<int> bytes = base64.decode(path);
    File file = File("$orderID.png");
    await file.writeAsBytes(bytes);
    return file;
  }

  // Группируем заказы по артикулу
  Map<String, int> groupOrderByArticule(List<Orders> orderList) {
    groupedOrders = {};
    for (Orders order in orderList) {
      groupedOrders[order.article!] = (groupedOrders[order.article] ?? 0) + 1;
    }
    final sorted = Map.fromEntries(
      groupedOrders.entries.toList()
        ..sort(
          (e1, e2) => e2.value.compareTo(e1.value),
        ),
    );

    groupedOrders = sorted;
    notifyListeners();
    return groupedOrders;
  }

  Future<void> createAndPrintPdfWithText(List<Order> orders) async {
    // groupedOrders
    // final imageBytesList = base64ImageStrings.map((base64String) {
    //   final bytes = base64Decode(base64String);
    //   return bytes;
    // }).toList();

    // // Создаем документ PDF
    // final pdf = pw.Document();
    // for (final bytes in imageBytesList) {
    //   pdf.addPage(pw.Page(
    //       pageFormat: PdfPageFormat.a4,
    //       build: (pw.Context context) {
    //         return pw.Center(
    //           child: pw.Text("Hello World"),
    //         ); // Center
    //       }));
    // }

    // Печатаем PDF-файл
    // await Printing.layoutPdf(
    //   onLayout: (PdfPageFormat format) async {
    //     return pdf.document.pa;
    //   },
    // );
  }
}
