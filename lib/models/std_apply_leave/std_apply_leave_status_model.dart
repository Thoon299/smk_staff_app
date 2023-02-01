class StdApplyLeaveStatusModel {
  String? data;


  StdApplyLeaveStatusModel(
      {this.data,

      });

  StdApplyLeaveStatusModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;

    return data;

  }
}