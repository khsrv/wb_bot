import 'dart:convert';
import 'dart:developer';
import 'dart:io';

class StickkerModel {
  List<Stickers>? stickers;
  StickkerModel({this.stickers});

  StickkerModel.fromJson(Map<String, dynamic> json) {
    try {
      if (json['stickers'] != null) {
        stickers = <Stickers>[];
        json['stickers'].forEach((v) {
          stickers!.add(Stickers.fromJson(v));
        });
      }
    } catch (error) {
      log("error in sticker $error");
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.stickers != null) {
      data['stickers'] = this.stickers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stickers {
  int? orderId;
  String? partA;
  String? partB;
  String? barcode;
  String? file;
  File? pngFile;

  Stickers({this.orderId, this.partA, this.partB, this.barcode, this.file});

  Stickers.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    partA = json['partA'];
    partB = json['partB'];
    barcode = json['barcode'];
    file = json['file'];
    // pngFile = decodeFile(json['file'], json['orderId']??'') as File?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['partA'] = this.partA;
    data['partB'] = this.partB;
    data['barcode'] = this.barcode;
    data['file'] = this.file;
    return data;
  }

  Future<File> decodeFile(String path, String orderID) async {
    List<int> bytes = base64.decode(path);
    File file = File("$orderID.pdf");
    await file.writeAsBytes(bytes);
    return file;
  }
}
