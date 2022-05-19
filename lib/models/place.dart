class Place {
  String name = '';
  String? description;
  int? ratingMaxVal;
  String? placeId;
  String? location;
  List<String>? imageAssets;
  List<String>? videoAssets;
  int? id;

  Place({
    required this.name,
    this.description,
    this.ratingMaxVal,
    this.placeId,
    this.location,
    this.imageAssets,
    this.videoAssets,
    this.id,
  });

  // Alternative constructor from a map.
  Place.fromMap(Map map) {
    name = map["name"];
    description = map["description"];
    ratingMaxVal = map["ratingMaxVal"];
    placeId = map["placeId"];
    location = map["location"];
    imageAssets = List.from(map["imageAssets"]);
    videoAssets = List.from(map["videoAssets"]);
    id = map["id"];
  }

  // Convert a Place into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'ratingMaxVal': ratingMaxVal,
      'placeId': placeId,
      'location': location,
      'imageAssets': imageAssets,
      'videoAssets': videoAssets,
    };
  }

  // Implement toString to make it easier to see information about
  // each Place when using the print statement.
  @override
  String toString() {
    return 'Place{id: $id, name: $name, description: $description, rating_max_val: $ratingMaxVal, placeId: $placeId, location: $location, imageAssets: $imageAssets, videoAssets: $videoAssets}';
  }
}
