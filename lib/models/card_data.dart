class CardData {
  String? id, nationalId, expirationDate, name, address, job, gender, religion, maritalStatus, releaseDate;

  CardData();

  CardData.fromMap(Map<String, dynamic> cardData) {
    id = cardData['id'];
    nationalId = cardData['national_id'];
    expirationDate = cardData['expiration_date'];
    name = cardData['name'];
    address = cardData['address'];
    job = cardData['job'];
    gender = cardData['gender'];
    religion = cardData['religion'];
    maritalStatus = cardData['marital_status'];
    releaseDate = cardData['release_date'];
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'national_id': nationalId,
        'expiration_date': expirationDate,
        'name': name,
        'address': address,
        'job': job,
        'gender': gender,
        'religion': religion,
        'marital_status': maritalStatus,
        'release_date': releaseDate,
      };
}
