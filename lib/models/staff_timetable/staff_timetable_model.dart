
class StaffTimetableList {
  List<PostData>? postData;

  StaffTimetableList({this.postData, });

  factory StaffTimetableList.fromJson(Map<String,dynamic> json){
    List<dynamic> data = json['data'];
    List<PostData> postData = <PostData>[];

    data.forEach((element) {
      var item = PostData.fromJson(element);
      postData.add(item);
    });


    return StaffTimetableList(
      postData: postData,
    );
  }
}

class PostData {
  String? id;
  String? time_from;
  String? time_to;
  String? room_no;
  String? subject_name;

  PostData(
      {this.id,
        this.time_from, this.time_to, this.room_no,
        this.subject_name,
      });

  PostData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time_from = json['time_from']??'-';
    time_to = json['time_to']??'-';
    room_no = json['room_no']??'-';
    subject_name = json['subject_name']??'-';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['time_from'] = this.time_from;
    data['time_to'] = this.time_to;
    data['room_no'] =  this.room_no;
    data['subject_name'] = this.subject_name;
    return data;
  }
}
