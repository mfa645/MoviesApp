class ProductionCompany {
  int id;
  String? logoPath;
  String name;
  String originCountry;
  int? filmForeignKey;

  ProductionCompany({
    required this.id,
    required this.logoPath,
    required this.name,
    required this.originCountry,
    required this.filmForeignKey,
  });

  factory ProductionCompany.fromJson(Map<String, dynamic> json) =>
      ProductionCompany(
        id: json["id"],
        logoPath: json["logo_path"],
        name: json["name"],
        originCountry: json["origin_country"],
        filmForeignKey: json["filmForeignKey"],
      );
  factory ProductionCompany.fromDBMap(Map<String, dynamic> json) =>
      ProductionCompany(
        id: json["id"],
        logoPath: json["logoPath"],
        name: json["name"],
        originCountry: json["originCountry"],
        filmForeignKey: json["filmForeignKey"],
      );

  Map<String, dynamic> toDBMap(int filmId) => {
        "id": id,
        "logoPath": logoPath,
        "name": name,
        "originCountry": originCountry,
        "filmForeignKey": filmForeignKey
      };
}
