class User{

  String firstName, lastName, dateOfBirth, durationOfDiet, email, phone;

  User(
      this.firstName,
      this.lastName,
      this.dateOfBirth,
      this.durationOfDiet,
      this.email,
      this.phone,
  );

  set setFirstName(String value) {
    firstName = value;
  }

  set setLastName(String value) {
    lastName = value;
  }

  set setDateOfBirth(String value) {
    dateOfBirth = value;
  }

  set setDurationOfDiet(String value) {
    durationOfDiet = value;
  }

  set setEmail(String value) {
    email = value;
  }

  set setPhone(String value) {
    phone = value;
  }
  

}