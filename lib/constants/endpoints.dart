class Endpoints {
  static final baseUrl = 'http://localhost:9000';
  static final user = '/api/user';
  static final param = '/api/param';
  static final login = '$user/login';
  static final signUp = '$user/register';
  static final logout = '$user/logout';
  static final species = '$param/species';
  static final breeds = '$param/breed';
  static final updateUser = '$user/update';
  static final city = '/param/city';
  static final pet = '/api/pet';
  static final petSave = '$pet/save';
  static final petDelete = '$pet/delete';
  static final petByUser = '$pet/user';
  static final medicalRecord = '$pet/medical/record';
  static final medicalRecordByPet = '$pet/medical/record/pet';
  static final saveMedicalRecord = '$medicalRecord/save';
}
