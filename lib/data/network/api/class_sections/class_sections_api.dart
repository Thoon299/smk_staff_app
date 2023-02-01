import 'package:dio/dio.dart';
import 'package:smk/models/class_sections/class_sections_model.dart';
import '../../dio_client.dart';
import 'dart:io';

import '../constants/endpoints.dart';

class ClassSectionsApi {
  // dio instance
  final DioClient _dioClient;


  // injecting dio instance
  ClassSectionsApi(this._dioClient);

  Future<ClassSectionsModel> getClassSections(search) async {
    final res = await _dioClient.get(Endpoints.class_sections+"/$search");
    return ClassSectionsModel.fromJson(res);
  }

}
// dio.options.headers={
// 'Content-Type':"multipart/form-data",
// 'Accept':'application/json'
// };

