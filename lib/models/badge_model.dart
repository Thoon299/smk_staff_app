class BadgeModel {
  String? badge;


  BadgeModel(
      {this.badge
      ,
      });

  BadgeModel.fromJson(Map<String, dynamic> json) {
    badge = json['badge']??'0';

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['badge'] = this.badge;

    return data;

  }
}