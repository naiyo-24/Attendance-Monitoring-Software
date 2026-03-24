import 'employee.dart';

class SalarySlip {
	final int? slipId;
	final int? adminId;
	final int? employeeId;
	final Employee employee;
	String? pdfPath; 
	String? salarySlipUrl; // Backend URL
	DateTime? createdAt;
	DateTime? updatedAt;

	SalarySlip({
		this.slipId,
		this.adminId,
		this.employeeId,
		required this.employee,
		this.pdfPath,
		this.salarySlipUrl,
		this.createdAt,
		this.updatedAt,
	});

	factory SalarySlip.fromJson(Map<String, dynamic> json, Employee employee) {
		return SalarySlip(
			slipId: json['slip_id'] as int?,
			adminId: json['admin_id'] as int?,
			employeeId: json['employee_id'] as int?,
			employee: employee,
			salarySlipUrl: json['salary_slip_url'] as String?,
			createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
			updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
		);
	}

	Map<String, dynamic> toJson() => {
		'slip_id': slipId,
		'admin_id': adminId,
		'employee_id': employeeId,
		'salary_slip_url': salarySlipUrl,
		'created_at': createdAt?.toIso8601String(),
		'updated_at': updatedAt?.toIso8601String(),
	};
}
