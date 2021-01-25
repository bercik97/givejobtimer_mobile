import 'package:flutter/cupertino.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';

class ValidatorService {
  static String validateLoginCode(String loginCode, BuildContext context) {
    return loginCode.isEmpty ? getTranslated(context, 'loginCodeIsRequired') : null;
  }

  static String validateUpdatingGroupName(String groupName, BuildContext context) {
    if (groupName.isEmpty) {
      return getTranslated(context, 'groupNameCannotBeEmpty');
    } else if (groupName.length > 26) {
      return getTranslated(context, 'groupNameWrongLength');
    }
    return null;
  }

  static String validateUpdatingGroupDescription(String groupDescription, BuildContext context) {
    if (groupDescription.isEmpty) {
      return getTranslated(context, 'groupDescriptionCannotBeEmpty');
    } else if (groupDescription.length > 100) {
      return getTranslated(context, 'groupDescriptionWrongLength');
    }
    return null;
  }

  static String validateWorkplace(String workplace, BuildContext context) {
    if (workplace.isEmpty) {
      return getTranslated(context, 'workplaceIsRequired');
    } else if (workplace.length > 200) {
      return getTranslated(context, 'workplaceWrongLength');
    }
    return null;
  }

  static String validateSettingManuallyWorkTimes(int fromHours, int fromMinutes, int toHours, int toMinutes, BuildContext context) {
    if (fromHours.isNegative || toHours.isNegative) {
      return getTranslated(context, 'hoursCannotBeLowerThan0');
    } else if (fromHours > 24 || toHours > 24) {
      return getTranslated(context, 'hoursCannotBeHigherThan24');
    } else if (fromMinutes.isNegative || toMinutes.isNegative) {
      return getTranslated(context, 'minutesCannotBeLowerThan0');
    } else if (fromMinutes > 59 || toMinutes > 59) {
      return getTranslated(context, 'minutesCannotBeHigherThan59');
    } else if (fromHours == 0 && toHours == 0 && fromMinutes == 0 && toMinutes == 0) {
      return getTranslated(context, 'workTimeFromAndToEmpty');
    } else if (fromHours > toHours) {
      return getTranslated(context, 'hoursFromCannotBeHigherThanHoursTo');
    } else if (fromHours == toHours && fromMinutes > toMinutes) {
      return getTranslated(context, 'timeOfStartCannotStartLaterThanFinish');
    }
    return null;
  }
}
