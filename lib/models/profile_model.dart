class ProfileModel {
  String? id;
  String? staff_no;
  String? name;
  String? dob;
  String? department;
  String? emergency_contact_no;
  String? email;
  String? gender;
  String? date_of_joining;
  String? image;
  String? designation;

  ProfileModel(
      {this.id,
        this.staff_no,
        this.name,
        this.dob,
        this.department,
        this.emergency_contact_no,
        this.email,
        this.gender,
        this.date_of_joining,this.image,
        this.designation,
      });

  ProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    staff_no = json['staff_no'];
    name = json['name']??'-';
    dob = json['dob']??'-';
    department = json['department']??'-';
    emergency_contact_no = json['emergency_contact_no']??'-';
    email = json['email']??'-';
    gender = json['gender']??'-';
    date_of_joining = json['date_of_joining']??'-';
    image = json['image']??'';
    designation = json['designation']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['staff_no'] = this.staff_no;
    data['name'] = this.name;
    data['dob'] = this.dob;
    data['department'] = this.department;
    data['emergency_contact_no'] = this.emergency_contact_no;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['date_of_joining']  = this.date_of_joining;
    data['image'] = this.image;
    data['designation'] = this.designation;
    return data;

  }
}