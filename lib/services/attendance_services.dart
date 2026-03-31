
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/attendance.dart';
import 'api_url.dart';

class AttendanceService {
	final Dio _dio = Dio()
		..interceptors.add(PrettyDioLogger(requestBody: true, responseBody: true));

	Future<List<Attendance>> fetchAttendanceByAdminAndEmployee(int adminId, int employeeId) async {
		final url = baseUrl + getAttendanceByAdminAndEmployeeEndpoint(adminId, employeeId);
		try {
			final response = await _dio.get(url);
			if (response.statusCode == 200) {
				final data = response.data as List;
				return data.map((e) => Attendance.fromJson(e)).toList();
			} else {
				throw Exception('Failed to fetch attendance');
			}
		} catch (e) {
			rethrow;
		}
	}

	Future<bool> updateAttendanceStatus({
		required int attendanceId,
		required int adminId,
		required AttendanceStatus status,
	}) async {
		final url = baseUrl + updateAttendanceStatusEndpoint(attendanceId, adminId);
		try {
			final response = await _dio.put(url, data: {'status': status.name});
			return response.statusCode == 200;
		} catch (e) {
			rethrow;
		}
	}
}
