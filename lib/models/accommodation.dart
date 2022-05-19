class Accommodation {
  String name = '';
  String? description;
  int? ratingMaxVal;
  String? placeId;
  String? location;
  List<String>? imageAssets;
  int? id;

  Accommodation({
    required this.name,
    this.description,
    this.ratingMaxVal,
    this.placeId,
    this.location,
    this.imageAssets,
    this.id,
  });

  // Alternative constructor from a map.
  Accommodation.fromMap(Map map) {
    name = map["name"];
    description = map["description"];
    ratingMaxVal = map["ratingMaxVal"];
    placeId = map["placeId"];
    location = map["location"];
    imageAssets = List.from(map["imageAssets"]);
    id = map["id"];
  }

  // Convert an Accommodation into a Map. The keys must correspond to the names
  // of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'ratingMaxVal': ratingMaxVal,
      'placeId': placeId,
      'location': location,
      'imageAssets': imageAssets,
    };
  }

  // Implement toString to make it easier to see information about
  // each Accommodation when using the print statement.
  @override
  String toString() {
    return 'Accommodation{id: $id, name: $name, description: $description, rating_max_val: $ratingMaxVal, placeId: $placeId, location: $location, imageAssets: $imageAssets}';
  }
}
