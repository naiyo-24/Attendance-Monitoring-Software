
// Replace with your backend URL
//const String baseUrl = 'https://attendxappbackend.naiyo24.com'; 

// BASE URL for localhost testing
const String baseUrl = 'http://localhost:8000';

// API endpoint for login
const String loginEndpoint = '/admin/login';

// Notification endpoints
const String createNotificationEndpoint = '/notifications/';
String getNotificationsByAdminEndpoint(int adminId) => '/notifications/admin/$adminId';
String deleteNotificationEndpoint(int notificationId, int adminId) => '/notifications/$notificationId/admin/$adminId';

// Employee endpoints
const String createEmployeeEndpoint = '/create/employees/';
String getEmployeesByAdminEndpoint(int adminId) => '/get-all/employees/admin/$adminId';
String updateEmployeeByAdminEndpoint(int employeeId, int adminId) => '/update-by/employees/$employeeId/admin/$adminId';
String deleteEmployeeByAdminEndpoint(int employeeId, int adminId) => '/delete/employees/$employeeId/admin/$adminId';

// Location Matrix endpoints
const String createLocationMatrixEndpoint = '/location-matrix/';
const String getAllLocationMatricesEndpoint = '/location-matrix/';
String getLocationMatricesByAdminEndpoint(int adminId) => '/location-matrix/admin/$adminId';
String updateLocationMatrixEndpoint(int locationMatrixId, int adminId) => '/location-matrix/$locationMatrixId/admin/$adminId';
String deleteLocationMatrixEndpoint(int locationMatrixId, int adminId) => '/location-matrix/$locationMatrixId/admin/$adminId';

// Help Center endpoints
const String getAllHelpCentersEndpoint = '/help-center/';

// Holidays endpoints
const String createHolidayEndpoint = '/holidays/post';
String getHolidayByAdminAndIdEndpoint(int holidayId, int adminId) => '/get-holidays/$holidayId/admin/$adminId';
String updateHolidayEndpoint(int holidayId, int adminId) => '/update-holidays/$holidayId/admin/$adminId';
String getHolidaysByAdminEndpoint(int adminId) => '/get-holidays/admin/$adminId';
String deleteHolidayEndpoint(int holidayId, int adminId) => '/delete-holidays/$holidayId/admin/$adminId';

// Salary Slip endpoints
String createSalarySlipEndpoint(int adminId, int employeeId) => '/salary_slip/$adminId/$employeeId';
String updateSalarySlipEndpoint(int adminId, int employeeId, int slipId) => '/salary_slip/$adminId/$employeeId/$slipId';
String getSalarySlipByIdEndpoint(int slipId) => '/salary_slip/$slipId';
String getAllSalarySlipsByAdminAndEmployeeEndpoint(int adminId, int employeeId) => '/salary_slip/all/$adminId/$employeeId';
String getSalarySlipsByEmployeeEndpoint(int employeeId) => '/salary_slip/employee/$employeeId';
String deleteSalarySlipEndpoint(int slipId) => '/salary_slip/$slipId';

// Leave Request endpoints
String getLeaveRequestsByAdminAndEmployeeEndpoint(int adminId, int employeeId) => '/get-all/leave_requests/admin/$adminId/employee/$employeeId';
String updateLeaveRequestByIdEndpoint(int leaveId) => '/update/leave_requests/$leaveId';

// Attendance endpoints
String getAttendanceByAdminAndEmployeeEndpoint(int adminId, int employeeId) => '/attendance/admin/$adminId/employee/$employeeId';
String updateAttendanceStatusEndpoint(int attendanceId, int adminId) => '/attendance/$attendanceId/admin/$adminId/status';

// Break Time endpoints
String getBreaksByAdminAndEmployeeEndpoint(int adminId, int employeeId) => '/break-time/admin/$adminId/employee/$employeeId';