class Employee {
  final String name;
  final String phone;
  final String email;
  final String password;
  final String bankName;
  final String branchName;
  final String accountNo;
  final String ifsc;
  final String designation;
  final String? profilePhoto;

  Employee({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.bankName,
    required this.branchName,
    required this.accountNo,
    required this.ifsc,
    required this.designation,
    this.profilePhoto,
  });
}
