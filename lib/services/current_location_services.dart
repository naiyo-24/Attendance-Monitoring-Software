
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_url.dart';
import '../models/current_location.dart';

class CurrentLocationService {
	final Dio _dio;

	CurrentLocationService()
			: _dio = Dio(BaseOptions(baseUrl: baseUrl)) {
		_dio.interceptors.add(PrettyDioLogger(
			requestHeader: true,
			requestBody: true,
			responseHeader: true,
			responseBody: true,
			error: true,
			compact: true,
			maxWidth: 120,
		));
	}

	Future<List<CurrentLocation>> fetchCurrentLocationsByAdmin(int adminId) async {
		final endpoint = getCurrentLocationsByAdminEndpoint(adminId);
		final response = await _dio.get(endpoint);
		if (response.statusCode == 200) {
			final data = response.data as List;
			return data.map((e) => CurrentLocation.fromJson(e)).toList();
		} else {
			throw Exception('Failed to fetch current locations');
		}
	}
}
