class Tour {
  String name = '';
  String? description;
  List<String>? visitPoints;
  int? id;

  Tour({required this.name, this.description, this.visitPoints, this.id});

  // Alternative constructor from a map.
  Tour.fromMap(Map map) {
    name = map["name"];
    description = map["description"];
    visitPoints = List.from(map["visitPoints"]);
    id = map["id"];
  }

  // Convert a Tour into a Map. The keys must correspond to the names
  // of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'visitPoints': visitPoints
    };
  }

  // Implement toString to make it easier to see information about
  // each Tour when using the print statement.
  @override
  String toString() {
    return 'Tour{id: $id, name: $name, description: $description, visitPoints: $visitPoints}';
  }
}
