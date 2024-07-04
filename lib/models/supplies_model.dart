class SuppliesModel {
  int? next;
  List<Supplies>? supplies;

  SuppliesModel({this.next, this.supplies});

  SuppliesModel.fromJson(Map<String, dynamic> json) {
    next = json['next'];
    if (json['supplies'] != null) {
      supplies = <Supplies>[];
      json['supplies'].forEach((v) {
        supplies!.add(Supplies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['next'] = this.next;
    if (this.supplies != null) {
      data['supplies'] = this.supplies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Supplies {
  String? id;
  bool? done;
  String? createdAt;
  String? closedAt;
  String? scanDt;
  String? name;
  int? cargoType;

  Supplies(
      {this.id,
      this.done,
      this.createdAt,
      this.closedAt,
      this.scanDt,
      this.name,
      this.cargoType});

  Supplies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    done = json['done'];
    createdAt = json['createdAt'];
    closedAt = json['closedAt'];
    scanDt = json['scanDt'];
    name = json['name'];
    cargoType = json['cargoType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['done'] = this.done;
    data['createdAt'] = this.createdAt;
    data['closedAt'] = this.closedAt;
    data['scanDt'] = this.scanDt;
    data['name'] = this.name;
    data['cargoType'] = this.cargoType;
    return data;
  }
}
