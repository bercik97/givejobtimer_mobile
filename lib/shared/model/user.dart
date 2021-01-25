class User {
  String id;
  String managerId;
  String employeeId;
  String role;
  String name;
  String surname;
  String nationality;
  String companyId;
  String companyName;
  String groupId;
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
    companyId = data['companyId'];
    companyName = data['companyName'];
    groupId = data['groupId'];
    authHeader = data['authorization'];
    return this;
  }

  void update(Map<String, Object> fieldsValues) {
    name = fieldsValues['name'];
    surname = fieldsValues['surname'];
    nationality = fieldsValues['nationality'];
  }
}
