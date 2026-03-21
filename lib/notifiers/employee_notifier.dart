import 'package:flutter/material.dart';
import '../models/employee.dart';

class EmployeeNotifier extends ChangeNotifier {
  final List<Employee> _employees = [
    Employee(
      name: 'John Doe',
      phone: '9876543210',
      email: 'john@example.com',
      password: 'password123',
      bankName: 'HDFC Bank',
      branchName: 'Salt Lake',
      accountNo: '1234567890',
      ifsc: 'HDFC0001234',
      designation: 'Manager',
      profilePhoto: null,
    ),
    Employee(
      name: 'Jane Smith',
      phone: '9123456789',
      email: 'jane@example.com',
      password: 'password456',
      bankName: 'ICICI Bank',
      branchName: 'Park Street',
      accountNo: '9876543210',
      ifsc: 'ICIC0005678',
      designation: 'Developer',
      profilePhoto: null,
    ),
  ];

  List<Employee> get employees => List.unmodifiable(_employees);

  void addEmployee(Employee emp) {
    _employees.add(emp);
    notifyListeners();
  }

  void updateEmployee(int index, Employee emp) {
    if (index >= 0 && index < _employees.length) {
      _employees[index] = emp;
      notifyListeners();
    }
  }

  void deleteEmployee(int index) {
    if (index >= 0 && index < _employees.length) {
      _employees.removeAt(index);
      notifyListeners();
    }
  }
}
