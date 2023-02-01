import 'package:equatable/equatable.dart';
import 'package:smk/models/class_sections/class_sections_model.dart';

import '../../models/staff/staff_model.dart';

abstract class ClassSectionsState extends Equatable{
  @override
  List<Object> get props => [];
}

class ClassSectionsEmpty extends ClassSectionsState{}

class ClassSectionsLoading extends ClassSectionsState{}

class ClassSectionsLoaded extends ClassSectionsState{
  final ClassSectionsModel classSectionsModel;
  ClassSectionsLoaded({required this.classSectionsModel});
}

class ClassSectionsError extends ClassSectionsState{
  final String errorMessage;
  ClassSectionsError({required this.errorMessage});
}