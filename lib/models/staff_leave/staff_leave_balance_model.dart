
class StaffLeaveBalanceModel {
  List<PostData>? postData;

  StaffLeaveBalanceModel({this.postData, });

  factory StaffLeaveBalanceModel.fromJson(Map<String,dynamic> json){
    List<dynamic> data = json['data'];
    List<PostData> postData = <PostData>[];

    data.forEach((element) {
      var item = PostData.fromJson(element);
      postData.add(item);
    });


    return StaffLeaveBalanceModel(
      postData: postData,
    );
  }
}

class PostData {
  String? type;
  int? alloted_days;
  String? used;
  String? avaliable;

  PostData(
      {this.type,
        this.alloted_days,
        this.used,
        this.avaliable,

      });

  PostData.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    alloted_days = json['alloted_days']??0;
    used = json['used']??'0';
    avaliable = json['avaliable']??'0';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['alloted_days'] = this.alloted_days;
    data['used'] = this.used;
    data['avaliable'] = this.avaliable;

    return data;

  }
}
