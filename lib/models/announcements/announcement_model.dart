
class Announcement {
  List<AData>? aData;

  Announcement({this.aData, });

  factory Announcement.fromJson(Map<String,dynamic> json){
    List<dynamic> data = json['data'];
    List<AData> aData = <AData>[];

    data.forEach((element) {
      var item = AData.fromJson(element);
      aData.add(item);
    });


    return Announcement(
      aData: aData,
    );
  }
}

class AData {
  String? id;
  String? title;
  String? message;
  String? publish_date;

  AData(
      {this.id,
        this.title,
        this.message,
        this.publish_date,
      });

  AData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title']??'-';
    message = json['message']??'-';
    publish_date = json['publish_date']??'-';

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['message'] = this.message;
    data['publish_date'] = this.publish_date;
    return data;
  }
}
