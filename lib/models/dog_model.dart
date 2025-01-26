import 'dart:convert';

class Dog {
  int? id;
  String? name;
  String? breedGroup;
  String? size;
  String? lifespan;
  String? origin;
  String? temperament;
  List<String>? colors;
  String? description;
  String? image;

  Dog({
    this.id,
    this.name,
    this.breedGroup,
    this.size,
    this.lifespan,
    this.origin,
    this.temperament,
    this.colors,
    this.description,
    this.image,
  });

  Dog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    breedGroup = json['breed_group'];
    size = json['size'];
    lifespan = json['lifespan'];
    origin = json['origin'];
    temperament = json['temperament'];
    colors = json['colors'].cast<String>();
    description = json['description'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['breed_group'] = breedGroup;
    data['size'] = size;
    data['lifespan'] = lifespan;
    data['origin'] = origin;
    data['temperament'] = temperament;
    data['colors'] = colors;
    data['description'] = description;
    data['image'] = image;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'breed_group': breedGroup,
      'size': size,
      'lifespan': lifespan,
      'origin': origin,
      'temperament': jsonEncode(temperament),
      'colors': jsonEncode(colors),
      'description': description,
      'image': image,
    };
  }
}
