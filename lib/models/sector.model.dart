class SectorModel{
  int sector_id;
  String name;

  SectorModel(
      {required this.sector_id, required this.name});

  factory SectorModel.fromJson(Map<dynamic, dynamic> json) {
    return SectorModel(
      sector_id: json['sector_id'],
      name: json['name']
    );
  }

  Map<String, dynamic> toJson() => {
    'sector_id': sector_id,
    'name': name
  };
}

class SectorGetResponse {
  final List<dynamic> sectors;
  final int totalSize;

  SectorGetResponse(
      {required this.sectors, required this.totalSize});

  factory SectorGetResponse.fromJson(Map<dynamic, dynamic> json) {
    return SectorGetResponse(
        sectors: json["sectors"],
        totalSize: json["totalSize"]
    );
  }
}