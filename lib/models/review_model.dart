class Review {
  final String id;
  final String patientId;
  final String doctorId;
  final double rating;
  final String comment;
  final DateTime? createdAt;

  Review({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.rating,
    required this.comment,
    this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    // Backend may return patient/doctor as nested objects or IDs
    final pId = json['patientId'] is Map ? json['patientId']['_id'] : json['patientId'];
    final dId = json['doctorId'] is Map ? json['doctorId']['_id'] : json['doctorId'];

    return Review(
      id: json['_id']?.toString() ?? '',
      patientId: pId?.toString() ?? '',
      doctorId: dId?.toString() ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      comment: json['comment']?.toString() ?? '',
      createdAt: json['createdAt'] == null
          ? null
          : (json['createdAt'] is int)
              ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int)
              : DateTime.tryParse(json['createdAt'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
