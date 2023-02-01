


import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smk/data/network/api/announcement/announcement_api.dart';
import 'package:smk/data/network/api/class_sections/class_sections_api.dart';
import 'package:smk/data/network/api/profile/profile_api.dart';
import 'package:smk/data/network/api/staff/staff_api.dart';
import 'package:smk/data/network/api/student_attendence_marking/std_att_marking_new_api.dart';
import 'package:smk/data/repository/announcement_repository.dart';
import 'package:smk/data/repository/class_sections_repository.dart';
import 'package:smk/data/repository/profile_repository.dart';
import 'package:smk/data/repository/staff_repository.dart';
import 'package:smk/data/repository/staff_timetable_repository.dart';
import 'package:smk/data/repository/std_att_marking_new_repository.dart';
import 'package:smk/ui/students/student_attendence/student_attendence_marking.dart';

import '../../data/network/api/auth/logout_api.dart';
import '../../data/network/api/badge/badge.api.dart';
import '../../data/network/api/staff_leave/staff_leave_apply_api.dart';
import '../../data/network/api/staff_leave/staff_leave_balance_api.dart';
import '../../data/network/api/staff_leave/staff_leave_balance_list_api.dart';
import '../../data/network/api/staff_permission/stf_per_api.dart';
import '../../data/network/api/staff_timetable/staff_timetable_api.dart';
import '../../data/network/api/std_apply_leave/std_apply_leave_api.dart';
import '../../data/network/api/student_attendence_marking/student_attendence_marking_api.dart';
import '../../data/network/api/students/student_api.dart';
import '../../data/network/dio_client.dart';
import '../../data/repository/badge_repository.dart';
import '../../data/repository/logout_repository.dart';
import '../../data/repository/staff_leave_apply_repository.dart';
import '../../data/repository/staff_leave_balance_list_repository.dart';
import '../../data/repository/staff_leave_balance_repository.dart';
import '../../data/repository/std_apply_leave_repository.dart';
import '../../data/repository/stf_per_repository.dart';
import '../../data/repository/student_attendence_marking_repository.dart';
import '../../data/repository/student_repository.dart';
import '../../data/sharedpreference/shared_preference_helper.dart';
import '../module/local_module.dart';
import '../module/network_module.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // async singletons:----------------------------------------------------------
  getIt.registerSingletonAsync<SharedPreferences>(() => LocalModule.provideSharedPreferences());

  // singletons:----------------------------------------------------------------
  getIt.registerSingleton(SharedPreferenceHelper(await getIt.getAsync<SharedPreferences>()));
  getIt.registerSingleton<Dio>(NetworkModule.provideDio(getIt<SharedPreferenceHelper>()));
  getIt.registerSingleton(DioClient(getIt<Dio>()));

  // api's:---------------------------------------------------------------------
  //getIt.registerSingleton(AuthApi(getIt<DioClient>()));


  // Profile's:---------------------------------------------------------------------
  getIt.registerSingleton(ProfileApi(getIt<DioClient>()));
  getIt.registerSingleton(ProfileRepository(getIt<ProfileApi>()));

  //Annoucnement's ------------------------------------------------------------
  getIt.registerSingleton(AnnouncementApi(getIt<DioClient>()));
  getIt.registerSingleton(AnnouncementRepository(getIt<AnnouncementApi>()));

  //Staff timetable's ------------------------------------------------------------
  getIt.registerSingleton(StaffTimetableApi(getIt<DioClient>()));
  getIt.registerSingleton(StaffTimetableRepository(getIt<StaffTimetableApi>()));

  //Student Directory's ------------------------------------------------------------
  getIt.registerSingleton(StudentApi(getIt<DioClient>()));
  getIt.registerSingleton(StudentRepository(getIt<StudentApi>()));

  //Staff Directory's ------------------------------------------------------------
  getIt.registerSingleton(StaffApi(getIt<DioClient>()));
  getIt.registerSingleton(StaffRepository(getIt<StaffApi>()));

  //Class Sections's ------------------------------------------------------------
  getIt.registerSingleton(ClassSectionsApi(getIt<DioClient>()));
  getIt.registerSingleton(ClassSectionsRepository(getIt<ClassSectionsApi>()));

  //Student Attendence Marking's ------------------------------------------------------------
  getIt.registerSingleton(StudentAttendenceMarkingApi(getIt<DioClient>()));
  getIt.registerSingleton(StudentAttendenceMarkingRepository(getIt<StudentAttendenceMarkingApi>()));

  //Student Attendence Marking New's ------------------------------------------------------------
  getIt.registerSingleton(StdAttMaringNewApi(getIt<DioClient>()));
  getIt.registerSingleton(StdAttMaringNewRepository(getIt<StdAttMaringNewApi>()));

  //Student Apply Leave's ------------------------------------------------------------
  getIt.registerSingleton(StdApplyLeaveApi(getIt<DioClient>()));
  getIt.registerSingleton(StdApplyLeaveRepository(getIt<StdApplyLeaveApi>()));

  //Staff Leave Balance's ------------------------------------------------------------
  getIt.registerSingleton(StaffLeaveBalanceApi(getIt<DioClient>()));
  getIt.registerSingleton(StaffLeaveBalanceRepository(getIt<StaffLeaveBalanceApi>()));

  //Staff Leave Balance List's ------------------------------------------------------------
  getIt.registerSingleton(StfLevBalListApi(getIt<DioClient>()));
  getIt.registerSingleton(StfLevBalListRepository(getIt<StfLevBalListApi>()));

  //Staff Permission's ------------------------------------------------------------
  getIt.registerSingleton(StfPerApi(getIt<DioClient>()));
  getIt.registerSingleton(StfPerRepository(getIt<StfPerApi>()));

  //Staff Leave Approve's ------------------------------------------------------------
  getIt.registerSingleton(StfLevApplyApi(getIt<DioClient>()));
  getIt.registerSingleton(StfLevApplyRepository(getIt<StfLevApplyApi>()));

  //Badge's ------------------------------------------------------------
  getIt.registerSingleton(BadgeApi(getIt<DioClient>()));
  getIt.registerSingleton(BadgeRepository(getIt<BadgeApi>()));

  //Logout's ------------------------------------------------------------
  getIt.registerSingleton(LogoutApi(getIt<DioClient>()));
  getIt.registerSingleton(LogoutRepository(getIt<LogoutApi>()));


}
