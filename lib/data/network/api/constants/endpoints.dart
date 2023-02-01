
class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "https://uat.smkedugroup.com/api/";

  static const String imgbaseUrl = "https://uat.smkedugroup.com/";

  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout[kwf]
  static const int connectionTimeout = 30000;

  //auth driver
  // static const String driverLogin = baseUrl + "driver/login";

  // auth admin
  static const String login = baseUrl + "login";

  // auth check
  static const String authcheck = baseUrl + "auth/check";

  //logout
  static const String logout = baseUrl + "logout";

  //profile
  static const String profile = baseUrl + "webservice2/profile";

  //announcement
  static const String announcement = baseUrl + "notification/announcementListHome";
  static const String announcementList = baseUrl + "notification/announcementListAll";
  static const String annDetail = baseUrl + "notification/annDetail";

  //staff_time_table
  static const String staffTimetableList = baseUrl + "staff_time_table/timeTableList";
  //student directory
  static const String studentHome = baseUrl + "student_dir/studentHome";
  static const String studentList = baseUrl + "student_dir/studentList";
  static const String studentListForAllClass = baseUrl + "student_dir/studentListForAllClass";
  static const String studentDetail = baseUrl + "student_dir/studentDetail";
  static const String studentDetailForAllClass = baseUrl + "student_dir/studentDetailForAllClass";

  //staff directory
  static const String staff = baseUrl + "staff_dir/staffDirHome";

  //class_sections
  static const String class_sections =  baseUrl + "student_dir/getClassSections";

  //student_attendence_marking
  static const String student_attendence_marking = baseUrl + "student_dir/getStudentAttendence";

  //std attendence marking new
  static const String std_att_marking_new = baseUrl + "student_dir/storeStudentAttendence";

  //std Apply Leave
  static const String std_apply_leave = baseUrl + "student_dir/getStudentApplyLeave";
  static const String std_apply_leave_status = baseUrl + "student_dir/updateStdApplyLeaveStatus";
  static const String stdApplyLeaveEdit   =  baseUrl + "student_dir/editStdApplyLeave";

  //staff leave balance
  static const String staffLeaveBalance = baseUrl + "staff_leave/getLeaveBalance";
  static const String StfLevBalList = baseUrl + "staff_leave/getLeaveBalanceList";

  //staff permission
  static const String stfPer = baseUrl + "staff_permission/getRolePermission";

  //staff Leave Apply
  static const String staff_lev_apply = baseUrl + "staff_apply_leave/add_staff_leave";
  //badge
  static const String badge = baseUrl + "notification/getBadge";
  static const String updateBadge = baseUrl + "notification/updateBadge";

  //noti
  static const String noti = baseUrl + "notification/getNotification";

  //logout
  static const String logoutStaff = baseUrl + "auth/logoutStaff";


}



