class User {
  String id;
  String managerId;
  String employeeId;
  String role;
  String name;
  String surname;
  String nationality;
  String phone;
  String viber;
  String whatsApp;
  String managerPhone;
  String managerViber;
  String managerWhatsApp;
  String authHeader;

  User();

  User create(Map<String, String> data) {
    id = data['id'];
    managerId = data['managerId'];
    employeeId = data['employeeId'];
    role = data['role'];
    name = data['name'];
    surname = data['surname'];
    nationality = data['nationality'];
    phone = data['phone'];
    viber = data['viber'];
    whatsApp = data['whatsApp'];
    managerPhone = data['managerPhone'];
    managerViber = data['managerViber'];
    managerWhatsApp = data['managerWhatsApp'];
    authHeader = data['authorization'];
    return this;
  }
}
