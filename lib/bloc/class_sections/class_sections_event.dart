import 'package:equatable/equatable.dart';

abstract class ClassSectionsEvent extends Equatable{
  const ClassSectionsEvent();

  @override
  List<Object> get props => [];
}

class FetchClassSections extends ClassSectionsEvent{
  String search;
  FetchClassSections({required this.search});
}