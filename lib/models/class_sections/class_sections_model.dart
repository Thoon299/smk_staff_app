
class ClassSectionsModel {
  List<PostData>? postData;

  ClassSectionsModel({this.postData, });

  factory ClassSectionsModel.fromJson(Map<String,dynamic> json){
    List<dynamic> data = json['data'];
    List<PostData> postData = <PostData>[];

    data.forEach((element) {
      var item = PostData.fromJson(element);
      postData.add(item);
    });


    return ClassSectionsModel(
      postData: postData,
    );
  }
}

class PostData {
  String? class_sections_id;
  String? classs;
  String? section;
  String? class_id;
  String? section_id;
  String? atts;

  PostData(
      {this.class_sections_id,
        this.classs,
        this.section,
        this.class_id, this.section_id, this.atts
      });

  PostData.fromJson(Map<String, dynamic> json) {
    class_sections_id = json['class_sections_id'];
    classs = json['class'];
    section = json['section']??'-';
    class_id =  json['class_id']??'';
    section_id = json['section_id']??'';
    atts = json['atts']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['class_sections_id'] = this.class_sections_id;
    data['class'] = this.classs;
    data['section'] = this.section;
    data['class_id'] = this.class_id;
    data['section_id'] = this.section_id;
    data['atts'] = this.atts;
    return data;

  }
}
