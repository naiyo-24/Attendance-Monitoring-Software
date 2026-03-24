import 'dart:io' show File;
import 'dart:typed_data';
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
    File? pdfFile,
    Uint8List? pdfBytes,
    String? fileName,
  }) async {
    MultipartFile slipFile;
    if (pdfBytes != null && fileName != null) {
      slipFile = MultipartFile.fromBytes(pdfBytes, filename: fileName);
    } else if (pdfFile != null) {
      slipFile = await MultipartFile.fromFile(pdfFile.path, filename: fileName ?? 'slip.pdf');
    } else {
      throw Exception('No PDF file or bytes provided');
    }
    final formData = FormData.fromMap({
      'slip_file': slipFile,
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
    File? pdfFile,
    Uint8List? pdfBytes,
    String? fileName,
  }) async {
    MultipartFile slipFile;
    if (pdfBytes != null && fileName != null) {
      slipFile = MultipartFile.fromBytes(pdfBytes, filename: fileName);
    } else if (pdfFile != null) {
      slipFile = await MultipartFile.fromFile(pdfFile.path, filename: fileName ?? 'slip.pdf');
    } else {
      throw Exception('No PDF file or bytes provided');
    }
    final formData = FormData.fromMap({
      'slip_file': slipFile,
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
