
class CurrentLocation {
	final int locationId;
	final int adminId;
	final int employeeId;
	final String date;
	final List<LocationCoordinate> coordinates;

	CurrentLocation({
		required this.locationId,
		required this.adminId,
		required this.employeeId,
		required this.date,
		required this.coordinates,
	});

	factory CurrentLocation.fromJson(Map<String, dynamic> json) {
		return CurrentLocation(
			locationId: json['location_id'] ?? 0,
			adminId: json['admin_id'] ?? 0,
			employeeId: json['employee_id'] ?? 0,
			date: json['date'] ?? '',
			coordinates: (json['coordinates'] as List<dynamic>? ?? [])
					.map((e) => LocationCoordinate.fromJson(e)).toList(),
		);
	}
}

class LocationCoordinate {
	final double lat;
	final double lng;
	final String timestamp;

	LocationCoordinate({
		required this.lat,
		required this.lng,
		required this.timestamp,
	});

	factory LocationCoordinate.fromJson(Map<String, dynamic> json) {
		return LocationCoordinate(
			lat: (json['lat'] as num).toDouble(),
			lng: (json['lng'] as num).toDouble(),
			timestamp: json['timestamp'] ?? '',
		);
	}
}
