class Location {
  final String label;
  final List<double> coordinates; // [longitude, latitude]

  Location({
    required this.label,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    // Backend may send { label: "...", geo: { coordinates: [...] } }
    final geo = json['geo'] as Map<String, dynamic>?;
    final coords = geo != null ? geo['coordinates'] as List? : json['coordinates'] as List?;
    
    return Location(
      label: json['label']?.toString() ?? '',
      coordinates: coords?.map((e) => (e as num).toDouble()).toList() ?? [0.0, 0.0],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'geo': {
        'type': 'Point',
        'coordinates': coordinates,
      },
    };
  }

  double get longitude => coordinates.isNotEmpty ? coordinates[0] : 0.0;
  double get latitude => coordinates.length > 1 ? coordinates[1] : 0.0;
}

class Doctor {
  final String id;
  final String name;
  final String email;
  final String about;
  final String specialization;
  final String image;
  final String patients;
  final String experience;
  final double rating;
  final int reviewsCount;
  final Location location;
  final List<String> availableDays;
  final List<String> availableHours;
  final String verificationStatus;
  final int consultationFee; // NEW

  Doctor({
    required this.id,
    required this.name,
    required this.email,
    required this.about,
    required this.specialization,
    required this.image,
    required this.patients,
    required this.experience,
    required this.rating,
    required this.reviewsCount,
    required this.location,
    required this.availableDays,
    required this.availableHours,
    required this.verificationStatus,
    required this.consultationFee,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    // Parse Location
    Location loc;
    if (json['location'] is Map<String, dynamic>) {
      loc = Location.fromJson(json['location']);
    } else {
      loc = Location(label: json['location']?.toString() ?? '', coordinates: [0.0, 0.0]);
    }

    // Parse Schedule (backend may nest under 'schedule')
    final schedule = json['schedule'] as Map<String, dynamic>?;
    final days = schedule != null ? schedule['availableDays'] : json['availableDays'];
    final hours = schedule != null ? schedule['availableHours'] : json['availableHours'];

    // Parse Account Status
    final accountStatus = json['accountStatus'] as Map<String, dynamic>?;
    final verifStatus = accountStatus != null ? accountStatus['verificationStatus'] : json['verificationStatus'];

    final professionalInfo = json['professionalInfo'] as Map<String, dynamic>?;

    String readFirstNonEmpty(List<dynamic> candidates, {String fallback = ''}) {
      for (final value in candidates) {
        final text = value?.toString().trim() ?? '';
        if (text.isNotEmpty && text.toLowerCase() != 'null') return text;
      }
      return fallback;
    }

    return Doctor(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      about: json['about']?.toString() ?? '',
      specialization: json['specialization']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      patients: readFirstNonEmpty([
        json['patients'],
        json['patientsCount'],
        json['totalPatients'],
        professionalInfo?['patients'],
        professionalInfo?['patientsCount'],
      ], fallback: '0'),
      experience: readFirstNonEmpty([
        json['experience'],
        json['yearsExperience'],
        json['experienceYears'],
        professionalInfo?['experience'],
        professionalInfo?['yearsExperience'],
        professionalInfo?['experienceYears'],
      ], fallback: 'N/A'),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: json['reviewsCount'] != null ? int.tryParse(json['reviewsCount'].toString()) ?? 0 : 0,
      location: loc,
      availableDays: (days as List?)?.map((e) => e.toString()).toList() ?? [],
      availableHours: (hours as List?)?.map((e) => e.toString()).toList() ?? [],
      verificationStatus: verifStatus?.toString() ?? 'pending',
      consultationFee: int.tryParse(json['consultationFee']?.toString() ?? '2500') ?? 2500,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'about': about,
      'specialization': specialization,
      'image': image,
      'patients': patients,
      'experience': experience,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'location': location.toJson(),
      'schedule': {
        'availableDays': availableDays,
        'availableHours': availableHours,
      },
      'accountStatus': {
        'verificationStatus': verificationStatus,
      },
      'consultationFee': consultationFee,
    };
  }
}
