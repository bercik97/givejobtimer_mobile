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
}
