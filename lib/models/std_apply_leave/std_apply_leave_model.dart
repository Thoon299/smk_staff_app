class StdApplyLeaveModel {
  List<PostData>? postData;

  StdApplyLeaveModel({this.postData, });

  factory StdApplyLeaveModel.fromJson(Map<String,dynamic> json){
    List<dynamic> data = json['data'];
    List<PostData> postData = <PostData>[];

    data.forEach((element) {
      var item = PostData.fromJson(element);
      postData.add(item);
    });


    return StdApplyLeaveModel(
      postData: postData,
    );
  }
}

class PostData {
  String? student_applyleave_id;
  String? reason;
  String? from_date;
  String? to_date;
  String? apply_date;
  String? status;
  String? firstname;
  String? class_name;
  String? section_name;

  PostData(
      {this.student_applyleave_id,
        this.reason,
        this.from_date,
        this.to_date,
        this.apply_date,
        this.status,
        this.firstname,
        this.class_name,
        this.section_name,
      });

  PostData.fromJson(Map<String, dynamic> json) {
    student_applyleave_id = json['student_applyleave_id']??'';
    reason = json['reason']??'';
    from_date = json['from_date']??'';
    to_date = json['to_date']??'';
    apply_date = json['apply_date']??'';
    status = json['status']??'0';
    firstname = json['firstname']??'';
    class_name = json['class_name']??'';
    section_name = json['section_name']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['student_id'] = this.student_applyleave_id;
    data['firstname'] = this.reason;
    data['student_attendences_id'] = this.from_date;
    data['attendence_type_id'] = this.to_date;
    data['type'] = this.apply_date;
    data['status']  =  this.status;
    data['firstname'] = this.firstname;
    data['class_name'] = this.class_name;
    data['section_name'] = this.section_name;
    return data;
  }
}
