import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../models/employee.dart';
import 'api_url.dart';

class EmployeeService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {'Accept': 'application/json'},
    ),
  )..interceptors.add(PrettyDioLogger());

  Future<Employee> createEmployee({
    required int adminId,
    required Employee employee,
    String? profilePhotoPath,
  }) async {
    final formData = FormData.fromMap({
      'admin_id': adminId,
      'full_name': employee.name,
      'phone_no': employee.phone,
      'email': employee.email,
      'address': employee.address,
      'designation': employee.designation,
      'password': employee.password,
      'bank_account_no': employee.accountNo,
      'bank_name': employee.bankName,
      'branch_name': employee.branchName,
      'ifsc_code': employee.ifsc,
      if (profilePhotoPath != null)
        'profile_photo': await MultipartFile.fromFile(profilePhotoPath),
    });
    final response = await _dio.post(createEmployeeEndpoint, data: formData);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return employee;
    } else {
      throw Exception('Failed to create employee');
    }
  }

  Future<List<Employee>> getEmployeesByAdmin(int adminId) async {
    final response = await _dio.get(getEmployeesByAdminEndpoint(adminId));
    if (response.statusCode == 200) {
      final data = response.data as List;
      return data.map((json) => Employee.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch employees');
    }
  }

  Future<Employee> updateEmployeeByAdmin({
    required int employeeId,
    required int adminId,
    required Employee employee,
    String? profilePhotoPath,
  }) async {
    final formData = FormData.fromMap({
      'full_name': employee.name,
      'phone_no': employee.phone,
      'email': employee.email,
      'address': employee.address,
      'designation': employee.designation,
      'password': employee.password,
      'bank_account_no': employee.accountNo,
      'bank_name': employee.bankName,
      'branch_name': employee.branchName,
      'ifsc_code': employee.ifsc,
      if (profilePhotoPath != null)
        'profile_photo': await MultipartFile.fromFile(profilePhotoPath),
    });
    final response = await _dio.put(
      updateEmployeeByAdminEndpoint(employeeId, adminId),
      data: formData,
    );
    if (response.statusCode == 200) {
      return employee;
    } else {
      throw Exception('Failed to update employee');
    }
  }

  Future<void> deleteEmployeeByAdmin({
    required int employeeId,
    required int adminId,
  }) async {
    final response = await _dio.delete(deleteEmployeeByAdminEndpoint(employeeId, adminId));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete employee');
    }
  }
}
