class Event {
  String name = '';
  String? description;
  String? location;
  List<String>? imageAssets;
  int? id;

  Event({
    required this.name,
    this.description,
    this.location,
    this.imageAssets,
    this.id,
  });

  // Alternative constructor from a map.
  Event.fromMap(Map map) {
    name = map["name"];
    description = map["description"];
    location = map["location"];
    imageAssets = List.from(map["imageAssets"]);
    id = map["id"];
  }

  // Convert an Event into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'imageAssets': imageAssets,
    };
  }

  // Implement toString to make it easier to see information about
  // each Event when using the print statement.
  @override
  String toString() {
    return 'Event{id: $id, name: $name, description: $description, location: $location, imageAssets: $imageAssets}';
  }
}
