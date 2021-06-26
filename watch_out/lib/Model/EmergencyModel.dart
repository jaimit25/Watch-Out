class EmergencyModel {
  String mail, name, phone, photo, time;

  EmergencyModel({this.mail, this.phone, this.name, this.photo, this.time});

  factory EmergencyModel.fromDocument(doc) {
    return EmergencyModel(
        mail: doc['mail'],
        phone: doc['phone'],
        name: doc['name'],
        photo: doc['photo'],
        time: doc['time']);
  }
}
