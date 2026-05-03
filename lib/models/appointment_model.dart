class Appointment {
  final String id;
  final String patientId;
  final String doctorId;
  final String doctorName; // NEW
  final String? shiftId;
  final int? queueNumber;
  final String date;
  final String time;
  final String status;
  final String? consultationNotes; // RENAMED from notes
  final int amount; // NEW

  Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.doctorName,
    this.shiftId,
    this.queueNumber,
    required this.date,
    required this.time,
    required this.status,
    this.consultationNotes,
    required this.amount,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    if (json['_id'] == null || json['_id'].toString().isEmpty) {
      throw ArgumentError.value(json['_id'], '_id', 'Appointment ID is required');
    }

    return Appointment(
      id: json['_id'].toString(),
      patientId: json['patientId']?.toString() ?? '',
      doctorId: json['doctorId']?.toString() ?? '',
      doctorName: json['doctorName']?.toString() ?? 'Unknown Doctor',
      shiftId: json['shiftId']?.toString(),
      queueNumber: json['queueNumber'] != null ? int.tryParse(json['queueNumber'].toString()) : null,
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      status: (json['status']?.toString().toLowerCase() == 'scheduled' || json['status'] == null) 
          ? 'pending' 
          : json['status'].toString().toLowerCase(),
      consultationNotes: json['consultationNotes']?.toString() ?? json['notes']?.toString(),
      amount: int.tryParse(json['amount']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'shiftId': shiftId,
      'queueNumber': queueNumber,
      'date': date,
      'time': time,
      'status': status,
      'consultationNotes': consultationNotes,
      'amount': amount,
    };
  }
}
