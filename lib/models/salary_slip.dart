import 'employee.dart';

class SalarySlip {
	final Employee employee;
	String? pdfPath; // Local file path to the PDF

	SalarySlip({
		required this.employee,
		this.pdfPath,
	});
}
