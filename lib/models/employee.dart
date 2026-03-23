class Employee {
  final int? employeeId;
  final String name;
  final String phone;
  final String email;
  final String password;
  final String bankName;
  final String branchName;
  final String accountNo;
  final String ifsc;
  final String designation;
  final String address;
  final String? profilePhoto;

  Employee({
    this.employeeId,
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.bankName,
    required this.branchName,
    required this.accountNo,
    required this.ifsc,
    required this.designation,
    required this.address,
    this.profilePhoto,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      employeeId: json['employee_id'],
      name: json['full_name'] ?? '',
      phone: json['phone_no'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      bankName: json['bank_name'] ?? '',
      branchName: json['branch_name'] ?? '',
      accountNo: json['bank_account_no'] ?? '',
      ifsc: json['ifsc_code'] ?? '',
      designation: json['designation'] ?? '',
      address: json['address'] ?? '',
      profilePhoto: json['profile_photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employee_id': employeeId,
      'full_name': name,
      'phone_no': phone,
      'email': email,
      'password': password,
      'bank_name': bankName,
      'branch_name': branchName,
      'bank_account_no': accountNo,
      'ifsc_code': ifsc,
      'designation': designation,
      'address': address,
      'profile_photo': profilePhoto,
    };
  }
}
