class AnnDetailModel {
  String? id;
  String? title;
  String? message;
  String? publish_date;

  AnnDetailModel(
      {this.id,
        this.title,
        this.message,
        this.publish_date,
      });


  AnnDetailModel.fromJson(Map<String, dynamic> json) {
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