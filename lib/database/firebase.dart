class FirebaseDB {
  static String? name;
  static String? phoneNumber;
  static String? DOB;
  static String? citizenshipNumber;
  static String? profileImageUrl;
  static String? citizenshipImageUrl;
  static void printall() {
    print(
        "${name} + ${phoneNumber} + ${DOB} + ${citizenshipNumber} + ${profileImageUrl} + ${citizenshipImageUrl} ");
  }
}
