
class NotiModel {
  List<NotiData>? notiData;

  NotiModel({this.notiData, });

  factory NotiModel.fromJson(Map<String,dynamic> json){
    List<dynamic> data = json['data'];
    List<NotiData> notiData = <NotiData>[];

    data.forEach((element) {
      var item = NotiData.fromJson(element);
      notiData.add(item);
    });


    return NotiModel(
      notiData: notiData,
    );
  }
}

class NotiData {
  String? same;
  String? id;
  String? title;
  String? body;
  String? type;
  String? type_id;
  String? created_at;

  NotiData(
      {this.same,
        this.id,
        this.title,
        this.body,
        this.type, this.type_id,
        this.created_at
      });

  NotiData.fromJson(Map<String, dynamic> json) {
    same = json['same']??'';
    id = json['id'];
    title = json['title']??'-';
    body = json['body']??'-';
    type = json['type']??'-';
    type_id = json['type_id']??'-';
    created_at = json['created_at']??'';

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['same'] = this.same;
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    data['type'] = this.type;
    data['type_id'] = this.type_id;
    data['created_at'] = this.created_at;
    return data;
  }
}
