
class AnnouncementList {
  List<PostData>? postData;

  AnnouncementList({this.postData, });

  factory AnnouncementList.fromJson(Map<String,dynamic> json){
    List<dynamic> data = json['data'];
    List<PostData> postData = <PostData>[];

    data.forEach((element) {
      var item = PostData.fromJson(element);
      postData.add(item);
    });


    return AnnouncementList(
      postData: postData,
    );
  }
}

class PostData {
  String? id;
  String? title;
  String? message;
  String? publish_date;

  PostData(
      {this.id,
        this.title,
        this.message,
        this.publish_date,
      });

  PostData.fromJson(Map<String, dynamic> json) {
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
