class LocationMatrix {
  final int? locationMatrixId;
  final int? adminId;
  final double latitude;
  final double longitude;

  LocationMatrix({
    this.locationMatrixId,
    this.adminId,
    required this.latitude,
    required this.longitude,
  });

  factory LocationMatrix.fromJson(Map<String, dynamic> json) {
    return LocationMatrix(
      locationMatrixId: json['location_matrix_id'],
      adminId: json['admin_id'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (locationMatrixId != null) 'location_matrix_id': locationMatrixId,
      if (adminId != null) 'admin_id': adminId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
