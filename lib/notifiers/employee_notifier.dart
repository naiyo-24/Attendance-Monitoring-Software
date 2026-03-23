import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../services/employee_services.dart';

class EmployeeNotifier extends ChangeNotifier {
  final EmployeeService _service = EmployeeService();
  List<Employee> _employees = [];
  bool _isLoading = false;
  String? _error;

  List<Employee> get employees => List.unmodifiable(_employees);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchEmployees(int adminId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final emps = await _service.getEmployeesByAdmin(adminId);
      _employees = emps;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addEmployee(int adminId, Employee emp, {String? profilePhotoPath}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _service.createEmployee(adminId: adminId, employee: emp, profilePhotoPath: profilePhotoPath);
      await fetchEmployees(adminId);
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateEmployee(int adminId, int employeeId, Employee emp, {String? profilePhotoPath}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _service.updateEmployeeByAdmin(employeeId: employeeId, adminId: adminId, employee: emp, profilePhotoPath: profilePhotoPath);
      await fetchEmployees(adminId);
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteEmployee(int adminId, int employeeId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _service.deleteEmployeeByAdmin(employeeId: employeeId, adminId: adminId);
      await fetchEmployees(adminId);
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
