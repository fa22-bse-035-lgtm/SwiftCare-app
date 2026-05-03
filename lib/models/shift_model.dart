class Shift {
  final String id;
  final String doctorId;
  final String date; // YYYY-MM-DD
  final String startTime;
  final String endTime;
  final String status;

  Shift({
    required this.id,
    required this.doctorId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  factory Shift.fromJson(Map<String, dynamic> json) {
    final dynamic rawDoctorId = json['doctorId'];
    final String parsedDoctorId = rawDoctorId is Map<String, dynamic>
        ? (rawDoctorId['_id']?.toString() ?? rawDoctorId['id']?.toString() ?? '')
        : rawDoctorId?.toString() ?? '';

    final String rawDate = json['date']?.toString() ?? '';
    String normalizedDate = rawDate;
    if (rawDate.contains('T')) {
      final parsed = DateTime.tryParse(rawDate);
      if (parsed != null) {
        normalizedDate =
            "${parsed.year}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}";
      }
    }

    return Shift(
      id: json['_id']?.toString() ?? '',
      doctorId: parsedDoctorId,
      date: normalizedDate,
      startTime: json['startTime']?.toString() ?? '',
      endTime: json['endTime']?.toString() ?? '',
      status: json['status']?.toString() ?? 'scheduled',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'doctorId': doctorId,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
    };
  }
}
