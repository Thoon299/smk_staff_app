
import 'dart:io';

import 'package:smk/models/class_sections/class_sections_model.dart';

import '../network/api/class_sections/class_sections_api.dart';

class ClassSectionsRepository {
  //api object
  final ClassSectionsApi classSectionsApi;

  ClassSectionsRepository(this.classSectionsApi);

  Future<ClassSectionsModel> getClassSections(search) async {
    return classSectionsApi.getClassSections(search);
  }


}
