class Holiday {
  final int? holidayId;
  final int? adminId;
  final DateTime date;
  final String occasion;
  final String remarks;

  Holiday({
    this.holidayId,
    this.adminId,
    required this.date,
    required this.occasion,
    required this.remarks,
  });

  factory Holiday.fromJson(Map<String, dynamic> json) {
    // Occasion can be a map or string depending on backend
    String occasion = json['occasion'] is Map
        ? json['occasion']['title'] ?? ''
        : (json['occasion'] ?? '');
    String remarks = json['occasion'] is Map
        ? json['occasion']['remarks'] ?? ''
        : (json['remarks'] ?? '');
    return Holiday(
      holidayId: json['holiday_id'],
      adminId: json['admin_id'],
      date: DateTime.parse(json['date']),
      occasion: occasion,
      remarks: remarks,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (holidayId != null) 'holiday_id': holidayId,
      if (adminId != null) 'admin_id': adminId,
      'date': date.toIso8601String(),
      'occasion': {
        'title': occasion,
        'remarks': remarks,
      },
    };
  }
}
