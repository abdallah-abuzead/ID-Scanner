class CardData {
  String?
      // id,
      nationalId,
      // expirationDate,
      name,
      address,
      // job,
      gender,
      // religion,
      // maritalStatus,
      // releaseDate,
      // info,
      birthdate,
      birthPlace,
      croppedPersonalImage,
      croppedIdImage;

  CardData();

  CardData.fromMap(Map<String, dynamic> jsonCardData) {
    // id = jsonCardData['id'];
    nationalId = jsonCardData['national_id'];
    // expirationDate = jsonCardData['expiration_date'];
    name = jsonCardData['name'];
    address = jsonCardData['address'];
    // job = jsonCardData['job'];
    gender = jsonCardData['gender'];
    // religion = jsonCardData['religion'];
    // maritalStatus = jsonCardData['marital_status'];
    // releaseDate = jsonCardData['release_date'];
    // info = jsonCardData['info'];
    birthdate = jsonCardData['birthdate'];
    birthPlace = jsonCardData['birth_place'];
    croppedPersonalImage = jsonCardData['cropped_personal_image'];
    croppedIdImage = jsonCardData['cropped_id_image'];
  }

  Map<String, dynamic> toMap() => {
        // 'id': id,
        'national_id': nationalId,
        // 'expiration_date': expirationDate,
        'name': name,
        'address': address,
        // 'job': job,
        'gender': gender,
        // 'religion': religion,
        // 'marital_status': maritalStatus,
        // 'release_date': releaseDate,
        // 'info': info,
        'birthdate': birthdate,
        'birth_place': birthPlace,
        'cropped_personal_image': croppedPersonalImage,
        'cropped_id_image': croppedIdImage,
      };
}
