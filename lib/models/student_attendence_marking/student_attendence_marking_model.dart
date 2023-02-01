class StudentAttendenceMarkingModel {
  List<PostData>? postData;

  StudentAttendenceMarkingModel({this.postData, });

  factory StudentAttendenceMarkingModel.fromJson(Map<String,dynamic> json){
    List<dynamic> data = json['data'];
    List<PostData> postData = <PostData>[];

    data.forEach((element) {
      var item = PostData.fromJson(element);
      postData.add(item);
    });


    return StudentAttendenceMarkingModel(
      postData: postData,
    );
  }
}

class PostData {
  String? student_session_id;
  String? student_id;
  String? firstname;
  String? student_attendence_id;
  String? attendence_type_id;
  String? type;

  PostData(
      {this.student_session_id,
        this.student_id,
        this.firstname,
        this.student_attendence_id,
        this.attendence_type_id,
        this.type,
      });

  PostData.fromJson(Map<String, dynamic> json) {
    student_session_id = json['student_session_id']??'';
    student_id = json['student_id']??'';
    firstname = json['firstname']??'';
    student_attendence_id = json['student_attendences_id']??'';
    attendence_type_id = json['attendence_type_id']??'';
    type = json['type']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['student_session_id'] = this.student_session_id;
    data['student_id'] = this.student_id;
    data['firstname'] = this.firstname;
    data['student_attendences_id'] = this.student_attendence_id;
    data['attendence_type_id'] = this.attendence_type_id;
    data['type'] = this.type;
    return data;
  }
}
