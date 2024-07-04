// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:printing/printing.dart'; // Импортируем пакет printing

// Future<void> createAndPrintPngFile(String text) async {
//   // Создание canvas для рисования
//   final ui.PictureRecorder recorder = ui.PictureRecorder();
//   final canvas = Canvas(recorder);

//   // Получение размеров экрана
//   final size = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;

//   // Определение шрифта
//   final textPainter = TextPainter(
//     text: TextSpan(
//       text: text,
//       style: TextStyle(
//         fontSize: 30,
//         color: Colors.black,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//     textDirection: TextDirection.ltr,
//     textAlign: TextAlign.center,
//   );
//   textPainter.layout(maxWidth: size.width);

//   // Рисование текста на canvas
//   final offset = Offset((size.width - textPainter.width) / 2,
//       (size.height - textPainter.height) / 2);
//   textPainter.paint(canvas, offset);

//   // Создание png изображения из canvas
//   final picture = recorder.endRecording();
//   final img = await picture.toImage(size.width.toInt(), size.height.toInt());
//   final bytes = await img.toByteData(format: ui.ImageByteFormat.png);


//   // Печать изображения
//   await Printing.layoutPdf(
//     onLayout: (PdfPageFormat format) async {
//       return [
//         PdfPage(
//           build: (PdfPageFormat format) =>
//               PdfImage(bytes: bytes!, width: format.width),
//         ),
//       ];
//     },
//   );
// }