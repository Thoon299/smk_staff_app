
import 'package:bloc/bloc.dart';

import '../../data/repository/class_sections_repository.dart';
import '../../models/class_sections/class_sections_model.dart';
import 'class_sections_event.dart';
import 'class_sections_state.dart';

class ClassSectionsBloc extends Bloc<ClassSectionsEvent,ClassSectionsState>{
  // late SharedPreferenceHelper sharedPreferenceHelper;
  ClassSectionsRepository classSectionsRepository;
  ClassSectionsBloc(this.classSectionsRepository) : super(ClassSectionsEmpty());
  List<PostData> staffList=[];


  @override
  Stream<ClassSectionsState> mapEventToState(
      ClassSectionsEvent event
      ) async*{
    if(event is FetchClassSections){
      yield ClassSectionsLoading();
      try{
        ClassSectionsModel classSectionsModel = await classSectionsRepository.getClassSections(event.search);
        yield ClassSectionsLoaded(classSectionsModel: classSectionsModel);
      }
      catch (e){
        yield ClassSectionsError(errorMessage: e.toString());
      }
    }
  }
}