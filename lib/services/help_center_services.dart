import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/help_center.dart';
import 'api_url.dart';

class HelpCenterService {
  final Dio _dio = Dio()
    ..interceptors.add(PrettyDioLogger());

  Future<List<HelpCenter>> getAllHelpCenters() async {
    final response = await _dio.get(baseUrl + getAllHelpCentersEndpoint);
    if (response.statusCode == 200) {
      final data = response.data as List;
      return data.map((e) => HelpCenter.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load help centers');
    }
  }
}
