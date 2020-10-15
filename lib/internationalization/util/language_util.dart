import 'package:flutter/cupertino.dart';
import 'package:givejobtimer_mobile/internationalization/localization/localization_constants.dart';
import 'package:givejobtimer_mobile/internationalization/model/language.dart';

class LanguageUtil {

  static List<Language> getLanguages() {
    return <Language>[
      Language(1, '🇧🇾', 'BLR', 'be'),
      Language(2, '🇬🇧', 'GBR', 'en'),
      Language(3, '🇬🇪', 'GEO', 'pt'),
      Language(4, '🇵🇱', 'POL', 'pl'),
      Language(5, '🇷🇺', 'RUS', 'ru'),
      Language(6, '🇺🇦', 'UKR', 'uk'),
    ];
  }

  static String findFlagByNationality(String nationality) {
    switch (nationality) {
      case 'BE': return '🇧🇾';
      case 'EN': return '🇬🇧';
      case 'GE': return '🇬🇪';
      case 'PL': return '🇵🇱';
      case 'RU': return '🇷🇺';
      case 'UK': return '🇺🇦';
      default: return '🇬🇧';
    }
  }

  static String convertShortNameToFullName(BuildContext context, String nationality) {
    switch (nationality) {
      case 'BE': return getTranslated(context, 'belarus');
      case 'EN': return getTranslated(context, 'england');
      case 'FR': return getTranslated(context, 'france');
      case 'GE': return getTranslated(context, 'georgia');
      case 'DE': return getTranslated(context, 'germany');
      case 'RO': return getTranslated(context, 'romania');
      case 'NL': return getTranslated(context, 'netherlands');
      case 'NO': return getTranslated(context, 'norway');
      case 'PL': return getTranslated(context, 'poland');
      case 'RU': return getTranslated(context, 'russia');
      case 'ES': return getTranslated(context, 'spain');
      case 'SE': return getTranslated(context, 'sweden');
      case 'UK': return getTranslated(context, 'ukraine');
      case 'OTHER': return getTranslated(context, 'other');
      default: return getTranslated(context, 'england');
    }
  }
}
