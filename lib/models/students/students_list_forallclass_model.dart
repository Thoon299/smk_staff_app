
class StudentListForAllClassModel {
  List<PostData>? postData;

  StudentListForAllClassModel({this.postData, });

  factory StudentListForAllClassModel.fromJson(Map<String,dynamic> json){
    List<dynamic> data = json['data'];
    List<PostData> postData = <PostData>[];

    data.forEach((element) {
      var item = PostData.fromJson(element);
      postData.add(item);
    });


    return StudentListForAllClassModel(
      postData: postData,
    );
  }
}

class PostData {
  String? id;
  String? admission_no;
  String? firstname;
  String? gender;
  String? image;

  PostData(
      {this.id,
        this.admission_no,
        this.firstname,
        this.gender, this.image
      });

  PostData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    admission_no = json['admission_no']??'';
    firstname = json['firstname']??'-';
    gender = json['gender']??'-';
    image = json['image']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['admission_no'] = this.admission_no;
    data['firstname'] = this.firstname;
    data['gender'] = this.gender;
    data['image'] = this.image;
    return data;
  }
}
