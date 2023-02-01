
class StfLevBalListModel {
  List<ListData>? listData;

  StfLevBalListModel({this.listData, });

  factory StfLevBalListModel.fromJson(Map<String,dynamic> json){
    List<dynamic> data = json['data'];
    List<ListData> listData = <ListData>[];

    data.forEach((element) {
      var item = ListData.fromJson(element);
      listData.add(item);
    });


    return StfLevBalListModel(
      listData: listData,
    );
  }
}

class ListData {
  String? type;
  String? leave_from;
  String? leave_to;
  String? leave_days;
  String? date;
  String? status;

  ListData(
      {this.type,
        this.leave_from,
        this.leave_to,
        this.leave_days,
        this.date,
        this.status
      });

  ListData.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    leave_from = json['leave_from']??0;
    leave_to = json['leave_to']??0;
    leave_days = json['leave_days']??0;
    date = json['date']??'';
    status = json['status']??'pending';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['leave_from'] = this.leave_from;
    data['leave_to'] = this.leave_to;
    data['leave_days'] = this.leave_days;
    data['date'] = this.date;
    data['status'] = this.status;

    return data;

  }
}
