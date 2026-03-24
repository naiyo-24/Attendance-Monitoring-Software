import 'dart:io';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/salary_slip.dart';
import '../models/employee.dart';
import 'api_url.dart';

class SalarySlipService {
  final Dio _dio;
  SalarySlipService({Dio? dio}) : _dio = dio ?? Dio()..interceptors.add(PrettyDioLogger());

  Future<SalarySlip> uploadSalarySlip({
    required int adminId,
    required Employee employee,
    required File pdfFile,
  }) async {
    final formData = FormData.fromMap({
      'slip_file': await MultipartFile.fromFile(pdfFile.path, filename: 'slip.pdf'),
    });
    final response = await _dio.post(
      baseUrl + createSalarySlipEndpoint(adminId, employee.employeeId!),
      data: formData,
    );
    return SalarySlip.fromJson(response.data, employee);
  }

  Future<SalarySlip> updateSalarySlip({
    required int adminId,
    required Employee employee,
    required int slipId,
    required File pdfFile,
  }) async {
    final formData = FormData.fromMap({
      'slip_file': await MultipartFile.fromFile(pdfFile.path, filename: 'slip.pdf'),
    });
    final response = await _dio.put(
      baseUrl + updateSalarySlipEndpoint(adminId, employee.employeeId!, slipId),
      data: formData,
    );
    return SalarySlip.fromJson(response.data, employee);
  }

  Future<List<SalarySlip>> getSalarySlipsForEmployee({
    required int adminId,
    required Employee employee,
  }) async {
    final response = await _dio.get(
      baseUrl + getAllSalarySlipsByAdminAndEmployeeEndpoint(adminId, employee.employeeId!),
    );
    if (response.data is List) {
      return (response.data as List)
          .map((json) => SalarySlip.fromJson(json, employee))
          .toList();
    }
    return [];
  }

  Future<void> deleteSalarySlip({
    required int slipId,
  }) async {
    await _dio.delete(baseUrl + deleteSalarySlipEndpoint(slipId));
  }
}
