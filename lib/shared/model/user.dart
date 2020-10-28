import 'package:givejobtimer_mobile/shared/dto/update_user_dto.dart';

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

  void update(UpdateUserDto dto) {
    name = dto.name;
    surname = dto.surname;
    nationality = dto.nationality;
    phone = dto.phone;
    viber = dto.viber;
    whatsApp = dto.whatsApp;
  }
}
