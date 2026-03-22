import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/location_matrix.dart';
import 'api_url.dart';

class LocationMatrixService {
	final Dio _dio = Dio(
		BaseOptions(
			baseUrl: baseUrl,
			connectTimeout: const Duration(seconds: 10),
			receiveTimeout: const Duration(seconds: 10),
			headers: {'Content-Type': 'application/json'},
		),
	)..interceptors.add(PrettyDioLogger());

	Future<LocationMatrix> createLocationMatrix(LocationMatrix matrix) async {
		final response = await _dio.post(
			createLocationMatrixEndpoint,
			data: matrix.toJson(),
		);
		if (response.statusCode == 200 || response.statusCode == 201) {
			return LocationMatrix.fromJson({
				...matrix.toJson(),
				'location_matrix_id': response.data['location_matrix_id'],
			});
		} else {
			throw Exception('Failed to create location matrix');
		}
	}

	Future<List<LocationMatrix>> getLocationMatricesByAdmin(int adminId) async {
		final response = await _dio.get(getLocationMatricesByAdminEndpoint(adminId));
		if (response.statusCode == 200) {
			final data = response.data as List;
			return data.map((json) => LocationMatrix.fromJson(json)).toList();
		} else {
			throw Exception('Failed to fetch location matrices');
		}
	}

	Future<LocationMatrix> updateLocationMatrix(LocationMatrix matrix, int adminId) async {
		if (matrix.locationMatrixId == null) throw Exception('Missing location_matrix_id');
		final response = await _dio.put(
			updateLocationMatrixEndpoint(matrix.locationMatrixId!, adminId),
			data: matrix.toJson(),
		);
		if (response.statusCode == 200) {
			return LocationMatrix.fromJson({
				...matrix.toJson(),
				'location_matrix_id': response.data['location_matrix_id'],
			});
		} else {
			throw Exception('Failed to update location matrix');
		}
	}

	Future<void> deleteLocationMatrix(int locationMatrixId, int adminId) async {
		final response = await _dio.delete(deleteLocationMatrixEndpoint(locationMatrixId, adminId));
		if (response.statusCode != 200) {
			throw Exception('Failed to delete location matrix');
		}
	}
}
