import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smk/data/sharedpreference/preferences.dart';

class SharedPreferenceHelper {
  // shared pref instance
  // final AuthApi _authApi;
  final SharedPreferences _sharedPreference;

  // constructor
  SharedPreferenceHelper(this._sharedPreference);

  // Set Fcm Token:---------------------------------------------------
  String? get getFcmToken {
    return _sharedPreference.getString(Preferences.fcm_token);
  }

  Future<void> setFcmToken(String fcm_token) {
    return _sharedPreference.setString(Preferences.fcm_token, fcm_token);
  }

  // Set b count:---------------------------------------------------
  String? get getb {
    return _sharedPreference.getString(Preferences.b);
  }

  Future<void> setb(String b) {
    return _sharedPreference.setString(Preferences.b, b);
  }


  // Set Teacher Id:---------------------------------------------------
  String? get getTeacherId {
    return _sharedPreference.getString(Preferences.teacherId);
  }

  Future<void> setTeacherId(String teacherId) {
    return _sharedPreference.setString(Preferences.teacherId, teacherId);
  }

  Future<void> removeTeacherId() {
    return _sharedPreference.remove(Preferences.teacherId);
  }
  String? get getTeacherFcmId {
    return _sharedPreference.getString(Preferences.teacheFcmId);
  }

  Future<void> setTeacherFcmId(String teacherFcmId) {
    return _sharedPreference.setString(Preferences.teacheFcmId, teacherFcmId);
  }

  Future<void> removeTeacherFcmId() {
    return _sharedPreference.remove(Preferences.teacheFcmId);
  }

  int? get getId {
    return _sharedPreference.getInt(Preferences.teacherId);
  }

  Future<void> setId(int id) {
    return _sharedPreference.setInt(Preferences.id, id);
  }

  //for timetable color
  int? get getttColorIndex {
    return _sharedPreference.getInt(Preferences.ttColorIndex);
  }

  Future<void> setttColorIndex(int index) {
    return _sharedPreference.setInt(Preferences.ttColorIndex,index );
  }
  Future<void> removettColorIndex() {
    return _sharedPreference.remove(Preferences.ttColorIndex );
  }

  //for color random announcement
  int? get getColorRandom {
    return _sharedPreference.getInt(Preferences.colorRandom);
  }

  Future<void> setColorRandom(int index) {
    return _sharedPreference.setInt(Preferences.colorRandom,index );
  }
  int? get getColorRandom2 {
    return _sharedPreference.getInt(Preferences.colorRandom2);
  }

  Future<void> setColorRandom2(int index) {
    return _sharedPreference.setInt(Preferences.colorRandom2,index );
  }

  //Staff permission --------------------------------------------------
  String? get getAppLeveCanAdd {
    return _sharedPreference.getString(Preferences.appLeve_can_add);
  }

  Future<void> setAppLeveCanAdd(String str) {
    return _sharedPreference.setString(Preferences.appLeve_can_add, str);
  }

  String? get getAppLeveCanEdit {
    return _sharedPreference.getString(Preferences.appLev_can_edit);
  }

  Future<void> setAppLeveCanEdit(String str) {
    return _sharedPreference.setString(Preferences.appLev_can_edit, str);
  }

  String? get getAppLeveCanDel {
    return _sharedPreference.getString(Preferences.appLev_can_delete);
  }

  Future<void> setAppLeveCanDel(String str) {
    return _sharedPreference.setString(Preferences.appLev_can_delete, str);
  }

  //std att marking
  String? get getStdAttCanAdd {
    return _sharedPreference.getString(Preferences.stdAtt_can_add);
  }

  Future<void> setStdAttCanAdd(String str) {
    return _sharedPreference.setString(Preferences.stdAtt_can_add, str);
  }
  String? get getStdAttCanEdit {
    return _sharedPreference.getString(Preferences.stdAtt_can_edit);
  }

  Future<void> setStdAttCanEdit(String str) {
    return _sharedPreference.setString(Preferences.stdAtt_can_edit, str);
  }
  String? get getStdAttCanDel {
    return _sharedPreference.getString(Preferences.stdAtt_can_delete);
  }

  Future<void> setStdAttCanDel(String str) {
    return _sharedPreference.setString(Preferences.stdAtt_can_delete, str);
  }




}