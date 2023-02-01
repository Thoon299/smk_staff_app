
import 'package:smk/models/announcements/announcement_list_model.dart';

class StudentHome {
  List<PostData>? postData;

  StudentHome({this.postData, });

  factory StudentHome.fromJson(Map<String,dynamic> json){
    List<dynamic> data = json['data'];
    List<PostData> postData = <PostData>[];

    data.forEach((element) {
      var item = PostData.fromJson(element);
      postData.add(item);
    });


    return StudentHome(
      postData: postData,
    );
  }
}

class PostData {
  String? id;
  String? students;
  String? classs;
  String? section;
  String? class_id;
  String? section_id;

  PostData(
      {this.id,
        this.students,
        this.classs,
        this.section,
        this.class_id,
        this.section_id,
      });

  PostData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    students = json['students']??'-';
    classs = json['class']??'-';
    section = json['section']??'-';
    class_id = json['class_id']??'-';
    section_id = json['section_id']??'-';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['class'] = this.classs;
    data['students'] = this.students;
    data['section'] = this.section;
    data['class_id'] = this.class_id;
    data['section_id'] = this.section_id;
    return data;
  }
}
