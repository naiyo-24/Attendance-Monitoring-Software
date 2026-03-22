// Replace with your backend URL
const String baseUrl = 'http://127.0.0.1:8000'; 

// API endpoint for login
const String loginEndpoint = '/admin/login';

// Notification endpoints
const String createNotificationEndpoint = '/notifications/';
String getNotificationsByAdminEndpoint(int adminId) => '/notifications/admin/$adminId';
String deleteNotificationEndpoint(int notificationId, int adminId) => '/notifications/$notificationId/admin/$adminId';
