import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/holiday.dart';
import 'api_url.dart';

class HolidayService {
  
  final Dio _dio;
  HolidayService([Dio? dio]) : _dio = (dio ?? Dio()) {
    _dio.interceptors.add(PrettyDioLogger());
  }

  Future<Holiday> createHoliday({required int adminId, required Holiday holiday}) async {
    final response = await _dio.post(
      baseUrl + createHolidayEndpoint,
      data: {
        'admin_id': adminId,
        'occasion': {
          'title': holiday.occasion,
          'remarks': holiday.remarks,
        },
        'date': holiday.date.toIso8601String(),
      },
    );
    return Holiday.fromJson({
      ...response.data,
      'occasion': {
        'title': holiday.occasion,
        'remarks': holiday.remarks,
      },
      'date': holiday.date.toIso8601String(),
      'admin_id': adminId,
    });
  }

  Future<List<Holiday>> getHolidaysByAdmin({required int adminId}) async {
    final response = await _dio.get(
      baseUrl + getHolidaysByAdminEndpoint(adminId),
    );
    return (response.data as List)
        .map((json) => Holiday.fromJson(json))
        .toList();
  }
  
  Future<Holiday> getHolidayByAdminAndId({required int holidayId, required int adminId}) async {
    final response = await _dio.get(
      baseUrl + getHolidayByAdminAndIdEndpoint(holidayId, adminId),
    );
    return Holiday.fromJson(response.data);
  }

  Future<Holiday> updateHoliday({required int holidayId, required int adminId, required Holiday holiday}) async {
    final response = await _dio.put(
      baseUrl + updateHolidayEndpoint(holidayId, adminId),
      data: {
        'occasion': {
          'title': holiday.occasion,
          'remarks': holiday.remarks,
        },
        'date': holiday.date.toIso8601String(),
      },
    );
    return Holiday.fromJson({
      ...response.data,
      'holiday_id': holidayId,
      'admin_id': adminId,
      'occasion': {
        'title': holiday.occasion,
        'remarks': holiday.remarks,
      },
      'date': holiday.date.toIso8601String(),
    });
  }

  Future<void> deleteHoliday({required int holidayId, required int adminId}) async {
    await _dio.delete(
      baseUrl + deleteHolidayEndpoint(holidayId, adminId),
    );
  }
}
