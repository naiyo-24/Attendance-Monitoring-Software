import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/user.dart';
import 'api_url.dart';

class AuthService {
	final Dio _dio = Dio(
		BaseOptions(
			baseUrl: baseUrl,
			connectTimeout: const Duration(seconds: 10),
			receiveTimeout: const Duration(seconds: 10),
			headers: {'Content-Type': 'application/json'},
		),
	)..interceptors.add(PrettyDioLogger());
  
  // Login method that sends a POST request to the backend with email and password, and returns a User object on success
	Future<User> login(String email, String password) async {
		try {
			final response = await _dio.post(
				loginEndpoint,
				data: {
					'email': email,
					'password': password,
				},
			);
			return User.fromJson({...response.data, 'password': password});
		} on DioException catch (e) {
			if (e.response != null && e.response?.statusCode == 401) {
				throw Exception('Invalid credentials');
			}
			throw Exception('Login failed: ${e.message}');
		}
	}
}
