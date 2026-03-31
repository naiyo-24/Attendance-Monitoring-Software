
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/break_time.dart';
import 'api_url.dart';

class BreakTimeService {
	final Dio _dio = Dio()
		..interceptors.add(PrettyDioLogger(requestBody: true, responseBody: true));

	Future<List<BreakTime>> fetchBreaksByAdminAndEmployee(int adminId, int employeeId) async {
		final url = baseUrl + getBreaksByAdminAndEmployeeEndpoint(adminId, employeeId);
		try {
			final response = await _dio.get(url);
			if (response.statusCode == 200) {
				final data = response.data as List;
				return data.map((e) => BreakTime.fromJson(e)).toList();
			} else {
				throw Exception('Failed to fetch break times');
			}
		} catch (e) {
			rethrow;
		}
	}
}
