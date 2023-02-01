class StfPerModel {
  String? appLev_can_view;
  String? appLeve_can_add;
  String? appLev_can_edit;
  String? appLev_can_delete;
  String? stdAtt_can_view;
  String? stdAtt_can_add;
  String? stdAtt_can_edit;
  String? stdAtt_can_delete;

  StfPerModel(
      {this.appLev_can_view,
        this.appLeve_can_add,
        this.appLev_can_edit,
        this.appLev_can_delete,
        this.stdAtt_can_view,
        this.stdAtt_can_add,
        this.stdAtt_can_edit,
        this.stdAtt_can_delete,
      });

  StfPerModel.fromJson(Map<String, dynamic> json) {
    appLev_can_view = json['appLev_can_view']??'0';
    appLeve_can_add = json['appLeve_can_add']??'0';
    appLev_can_edit = json['appLev_can_edit']??'0';
    appLev_can_delete = json['appLev_can_delete']??'0';
    stdAtt_can_view = json['stdAtt_can_view']??'0';
    stdAtt_can_add = json['stdAtt_can_add']??'0';
    stdAtt_can_edit = json['stdAtt_can_edit']??'0';
    stdAtt_can_delete = json['stdAtt_can_delete']??'0';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appLev_can_view'] = this.appLev_can_view;
    data['appLeve_can_add'] = this.appLeve_can_add;
    data['appLev_can_edit'] = this.appLev_can_edit;
    data['appLev_can_delete'] = this.appLev_can_delete;
    data['stdAtt_can_view'] = this.stdAtt_can_view;
    data['stdAtt_can_add'] = this.stdAtt_can_add;
    data['stdAtt_can_edit'] = this.stdAtt_can_edit;
    data['stdAtt_can_delete'] = this.stdAtt_can_delete;

    return data;

  }
}