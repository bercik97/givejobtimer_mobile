import 'package:flutter/cupertino.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/internationalization/model/language.dart';

class LanguageUtil {

  static List<Language> getLanguages() {
    return <Language>[
      Language(1, '🇬🇧', 'GBR', 'en'),
      Language(2, '🇵🇱', 'POL', 'pl'),
      Language(3, '🇺🇦', 'UKR', 'uk'),
    ];
  }

  static String findFlagByNationality(String nationality) {
    switch (nationality) {
      case 'EN': return '🇬🇧';
      case 'PL': return '🇵🇱';
      case 'UK': return '🇺🇦';
      default: return '🇬🇧';
    }
  }

  static String convertShortNameToFullName(BuildContext context, String nationality) {
    switch (nationality) {
      case 'EN': return getTranslated(context, 'england');
      case 'PL': return getTranslated(context, 'poland');
      case 'UK': return getTranslated(context, 'ukraine');
      default: return getTranslated(context, 'england');
    }
  }
}
