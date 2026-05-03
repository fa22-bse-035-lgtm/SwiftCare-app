class Patient {
  final String id;
  final String name;
  final String email;
  final String image;
  final List<String> favorites;
  final List<String> allergies;
  final String? bloodGroup;
  final int? age;
  final String? gender;
  final List<double> locationCoordinates; // [longitude, latitude]

  Patient({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
    required this.favorites,
    required this.allergies,
    this.bloodGroup,
    this.age,
    this.gender,
    this.locationCoordinates = const [0.0, 0.0],
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    // Backend may nest coordinates under location.coordinates
    final location = json['location'] as Map<String, dynamic>?;
    final coords = location != null ? location['coordinates'] as List? : json['locationCoordinates'] as List?;

    return Patient(
      id: json['_id']?.toString() ?? json['userId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      image: json['image']?.toString() ?? 'assets/images/Jane.jpg',
      favorites: (json['favorites'] as List?)?.map((e) => e.toString()).toList() ?? [],
      allergies: (json['allergies'] as List?)?.map((e) => e.toString()).toList() ?? [],
      bloodGroup: json['bloodGroup']?.toString(),
      age: json['age'] != null ? int.tryParse(json['age'].toString()) : null,
      gender: json['gender']?.toString(),
      locationCoordinates: coords?.map((e) => (e as num).toDouble()).toList() ?? [0.0, 0.0],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'image': image,
      'favorites': favorites,
      'allergies': allergies,
      'bloodGroup': bloodGroup,
      'age': age,
      'gender': gender,
      'location': {
        'type': 'Point',
        'coordinates': locationCoordinates,
      },
    };
  }

  double get longitude => locationCoordinates.isNotEmpty ? locationCoordinates[0] : 0.0;
  double get latitude => locationCoordinates.length > 1 ? locationCoordinates[1] : 0.0;
}
