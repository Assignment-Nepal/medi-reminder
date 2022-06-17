


import 'JagaMe.dart';

class DependantProfile {
  String Dallergies,
      DuserName,
      Dage,
      Dgender,
      DbloodGroup,
      DbloodPressure,
      DbloodSugar,
      Dheight,
      Dweight,
      DphoneNumber,
      Dpicture,
      dependantUid;

  List<Relative> relatives ;

  DependantProfile(this.dependantUid);
  setData (Map<String, dynamic> data) {
    this.dependantUid = data['uidD'];
    this.DphoneNumber = data['phoneNumberD'];
    this.Dage = data['ageD'];
    this.DbloodGroup = data['bloodGroupD'];
    this.DbloodPressure = data['bloodPressureD'];
    this.DbloodSugar = data['bloodSugarD'];
    this.Dgender = data['genderD'];
    this.Dheight = data['heightD'];
    this.Dpicture = data['pictureD'];
    this.Dweight = data['weightD'];
    this.DuserName = data['userNameD'];
    this.Dallergies = data['allergiesD'];
    return this;
  }

  getAllRelatives(var data) {
    this.relatives = [];
    for (var relative in data) {
      Relative _relative = Relative();
      _relative.getData(relative);
      this.relatives.add(_relative);
    }
  }

  deleteRelative(String documentID) {
    Relative _relative = Relative();
    bool found = false;
    for (var r in this.relatives) {
      if (r.documentID == documentID) _relative = r;
    }
    if (found) {
      this.relatives.remove(_relative);
    }
  }
}
