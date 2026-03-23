

// Replace with your backend URL
const String baseUrl = 'http://127.0.0.1:8000'; 

// API endpoint for login
const String loginEndpoint = '/admin/login';

// Notification endpoints
const String createNotificationEndpoint = '/notifications/';
String getNotificationsByAdminEndpoint(int adminId) => '/notifications/admin/$adminId';
String deleteNotificationEndpoint(int notificationId, int adminId) => '/notifications/$notificationId/admin/$adminId';

// Employee endpoints
const String createEmployeeEndpoint = '/employees/';
String getEmployeesByAdminEndpoint(int adminId) => '/employees/admin/$adminId';
String updateEmployeeByAdminEndpoint(int employeeId, int adminId) => '/employees/$employeeId/admin/$adminId';
String deleteEmployeeByAdminEndpoint(int employeeId, int adminId) => '/employees/$employeeId/admin/$adminId';

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