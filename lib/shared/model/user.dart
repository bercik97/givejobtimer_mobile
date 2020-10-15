class User {
  String id;
  String role;
  String name;
  String surname;
  String nationality;
  String phone;
  String viber;
  String whatsApp;
  String authHeader;

  User();

  User create(Map<String, String> data) {
    id = data['id'];
    role = data['role'];
    name = data['name'];
    surname = data['surname'];
    nationality = data['nationality'];
    phone = data['phone'];
    viber = data['viber'];
    whatsApp = data['whatsApp'];
    authHeader = data['authorization'];
    return this;
  }
}
