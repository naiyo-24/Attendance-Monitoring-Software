import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/leaves.dart';
import '../models/employee.dart';
import 'api_url.dart';

class LeaveRequestService {
  final Dio _dio;
  LeaveRequestService({Dio? dio}) : _dio = dio ?? Dio();

  Future<List<Leave>> fetchLeavesByAdminAndEmployee({
    required int adminId,
    required Employee employee,
  }) async {
    final response = await _dio.get(
      baseUrl + getLeaveRequestsByAdminAndEmployeeEndpoint(adminId, employee.employeeId!),
    );
    if (response.data is List) {
      return (response.data as List)
          .map((json) => Leave.fromJson(json, employee))
          .toList();
    }
    return [];
  }

  Future<void> updateLeaveStatus({
    required int leaveId,
    DateTime? date,
    String? reason,
    required LeaveStatus status,
  }) async {
    final data = <String, dynamic>{
      if (date != null) 'date': date.toIso8601String(),
      'reason': ?reason,
      'status': leaveStatusToString(status),
    };
    await _dio.put(
      baseUrl + updateLeaveRequestByIdEndpoint(leaveId),
      data: jsonEncode(data),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
  }
}
