class StudentDetailModel {
  String? roll_no;
  String? admission_date;
  String? mobileno;
  String? dob;
  String? email;
  String? religion;
  String? cast;
  String? current_address;
  String? permanent_address;
  String? weight;
  String? height;
  String? measurement_date;

  String? father_name; String? father_phone; String? father_occupation;
  String? mother_name; String? mother_phone; String? mother_occupation;
  String? guardian_name; String? guardian_phone; String? guardian_email;
  String? guardian_address; String? guardian_relation; String? guardian_occupation;
  String? pickup_person_name; String? pickup_person_phno; String? pickup_person_address;
  String? pickup_person_relationship; String? pickup_person_nric;

  StudentDetailModel(
      {this.roll_no,
        this.admission_date,
        this.mobileno,
        this.dob,
        this.email,
        this.religion,
        this.cast,
        this.current_address,
        this.permanent_address,
        this.weight,
        this.height,
        this.measurement_date,

        this.father_name, this.father_phone, this.father_occupation,
        this.mother_name, this.mother_phone, this.mother_occupation,
        this.guardian_name, this.guardian_phone, this.guardian_email,
        this.guardian_address, this.guardian_relation, this.guardian_occupation,
        this.pickup_person_name, this.pickup_person_phno, this.pickup_person_address,
        this.pickup_person_relationship, this.pickup_person_nric,
      });

  StudentDetailModel.fromJson(Map<String, dynamic> json) {
    roll_no = json['roll_no']??'';
    admission_date = json['adminssion_date']??'';
    mobileno = json['mobileno']??'';
    dob = json['dob']??'';
    email = json['email']??'';
    religion = json['religion']??'';
    cast = json['cast']??'';
    current_address = json['current_address']??'-';
    permanent_address = json['permanent_address']??'-';
    weight = json['weight']??'';
    height = json['height']??'';
    measurement_date = json['measurement_date']??'';

    father_name = json['father_name']??''; father_phone = json['father_phone']??'';father_occupation = json['father_occupation']??'';
    mother_name = json['mother_name']??''; mother_phone = json['mother_phone']??''; mother_occupation = json['mother_occupation']??'';

    guardian_name = json['guardian_name']??''; guardian_phone = json['guardian_phone']??'';guardian_email = json['guardian_email']??'';
    guardian_address = json['guardian_address']??'';guardian_relation
    = json['guardian_relation']??'';guardian_occupation = json['guardian_occupation']??'';

    pickup_person_name = json['pickup_person_name']??'';pickup_person_phno = json['pickup_person_phno']??'';
    pickup_person_address = json['pickup_person_address']??'';
    pickup_person_relationship = json['pickup_person_relationship']??'';
    pickup_person_nric = json['pickup_person_nric']??'';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roll_no'] = this.roll_no;
    data['admission_date'] = this.admission_date;
    data['mobileno'] = this.mobileno;
    data['dob'] = this.dob;
    data['email'] = this.email;
    data['religion'] = this.religion;
    data['cast'] = this.cast;
    data['current_address'] = this.current_address;
    data['permanent_address']  = this.permanent_address;
    data['weight'] = this.weight;
    data['height'] = this.height;
    data['measurement_date'] = this.measurement_date;

    data['father_name'] = this.father_name; data['father_phone'] = this.father_phone; data['father_occupation'] = this.father_occupation;
    data['mother_name'] = this.mother_name; data['mother_phone'] = this.mother_phone; data['mother_occupation'] = this.mother_occupation;

    data['guardian_name'] = this.guardian_name; data['guardian_phone'] = this.guardian_phone;
    data['guardian_email'] = this.guardian_email; data['guardian_address'] = this.guardian_address;
    data['guardian_relation'] = this.guardian_relation; data['guardian_occupation'] = this.guardian_occupation;

    data['pickup_person_name'] = this.pickup_person_name; data['pickup_person_phno'] = this.pickup_person_phno;
    data['pickup_person_address'] = this.pickup_person_address; data['pickup_person_relationship'] = this.pickup_person_relationship;
    data['pickup_person_nric'] = this.pickup_person_nric;
    return data;

  }
}