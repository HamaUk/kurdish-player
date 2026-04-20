// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// The translations for Kurdish (`ckb`).
class AppLocalizationsCkb extends AppLocalizationsEn {
  AppLocalizationsCkb([String locale = 'ckb']) : super(locale);

  @override
  String get accountCreateFormItemLabelClientId => 'بەستەری کلاینت';

  @override
  String get accountCreateFormItemLabelClientPwd => 'وشەی نهێنی کلاینت';

  @override
  String get accountCreateFormItemLabelOauthUrl => 'بەستەری OAuth';

  @override
  String get accountCreateFormItemLabelRefreshToken => 'تۆکن';

  @override
  String get accountUseProxy => 'بەکارهێنانی پڕۆکسی';

  @override
  String get actAs => 'وەک';

  @override
  String get audioDecoderLabel => 'کۆدکەری دەنگ';

  @override
  String get autoCheckForUpdates => 'پشکنینی ئۆتۆماتیکی بۆ نوێکردنەوە';

  @override
  String get buttonActivate => 'چالاککردن';

  @override
  String get buttonAirDate => 'بەرواری پەخش';

  @override
  String get buttonAll => 'هەمووی';

  @override
  String get buttonCancel => 'پاشگەزبوونەوە';

  @override
  String get buttonCast => 'پەخشکردن';

  @override
  String get buttonCollapse => 'کۆکردنەوە';

  @override
  String get buttonComplete => 'تەواو';

  @override
  String get buttonConfirm => 'پ پشتڕاستکردنەوە';

  @override
  String get buttonDelete => 'سڕینەوە';

  @override
  String get buttonDownload => 'داگرتن';

  @override
  String get buttonEdit => 'دەسکاریکردن';

  @override
  String get buttonEditMetadata => 'دەسکاریکردنی زانیارییەکان';

  @override
  String get buttonFavorite => 'دڵخوازەکان';

  @override
  String get buttonHome => 'سەرەکی';

  @override
  String get buttonMore => 'پتر';

  @override
  String get buttonName => 'ناو';

  @override
  String get buttonNewFolder => 'بوخچەی نوێ';

  @override
  String get buttonPause => 'وەستان';

  @override
  String get buttonPlay => 'پەخشکردن';

  @override
  String get buttonProperty => 'تایبەتمەندی';

  @override
  String get buttonRefresh => 'نوێکردنەوە';

  @override
  String get buttonRemoveDownload => 'سڕینەوەی داگیراو';

  @override
  String get buttonRename => 'گۆڕینی ناو';

  @override
  String get buttonReset => 'دیسان ڕێکخستنەوە';

  @override
  String get buttonResume => 'بەردەوامبوون';

  @override
  String get buttonSubmit => 'ناردن';

  @override
  String get buttonSubtitle => 'زیادکردنی ژێرنووس';

  @override
  String get buttonSyncLibrary => 'هاوکاتکردنی کتێبخانە';

  @override
  String get buttonTrailer => 'ترەیلەر';

  @override
  String get buttonUnwatched => 'نەبینراو';

  @override
  String get buttonView => 'بینین';

  @override
  String get buttonWatchNow => 'ئێستا ببینە';

  @override
  String get buttonWatched => 'بینراو';

  @override
  String get checkForUpdates => 'پشکنین بۆ نوێکردنەوە';

  @override
  String get checkingUpdates => 'پشکنین بۆ نوێکردنەوە...';

  @override
  String get confirmTextExit => 'بۆ چوونە دەرەوە دووبارە دایبگرەوە';

  @override
  String get confirmTextLogin => 'دەتەوێت بچیتە ناو ئەم هەژمارە؟';

  @override
  String get confirmTextResetData => 'ئایا دڵنیای لە ڕێکخستنەوەی داتا؟';

  @override
  String get deleteConfirmText => 'ئایا دڵنیای لە سڕینەوە؟';

  @override
  String get homeTabLive => 'ڕاستەوخۆ';

  @override
  String get homeTabMovie => 'فیلم';

  @override
  String get homeTabSettings => 'ڕێکخستنەکان';

  @override
  String get homeTabTV => 'زنجیرەکان';

  @override
  String get iptvDefaultSource => 'سەرچاوەی IPTV ئاسایی';

  @override
  String get noData => 'هیچ داتایەک نییە';

  @override
  String get pageTitleAccount => 'هەژمار';

  @override
  String get pageTitleAdd => 'زیادکردن';

  @override
  String get pageTitleEdit => 'دەسکاریکردن';

  @override
  String get pageTitleLogin => 'چوونەژوورەوە';

  @override
  String get search => 'گەڕان';

  @override
  String get searchHint => 'گەڕان بۆ فیلم، زنجیرە و ئەکتەرەکان';

  @override
  String get settingsTitle => 'ڕێکخستنەکان';

  @override
  String systemLanguage(String language) {
    String _temp0 = intl.Intl.selectLogic(language, {
      'zh': 'چینی',
      'en': 'ئینگلیزی',
      'ckb': 'کوردی',
      'other': 'ئۆتۆ',
    });
    return '$_temp0';
  }

  @override
  String systemTheme(String theme) {
    String _temp0 = intl.Intl.selectLogic(theme, {
      'light': 'ڕۆشن',
      'dark': 'تاریك',
      'other': 'ئۆتۆ',
    });
    return '$_temp0';
  }

  @override
  String get titlePlaylist => 'لیستی پەخش';

  @override
  String get updateNow => 'ئێستا نوێ بکەرەوە';

  @override
  String get versionDeprecatedTip => 'ئەم وەشانە کۆنە، تکایە نوێی بکەرەوە';

  @override
  String get onboardingTitle => 'بەخێرهاتیت بۆ KURDISH PLAYER';

  @override
  String get onboardingSubtitle => 'سەرچاوەیەک هەڵبژێرە بۆ دەستپێکردنی سەیرکردن';

  @override
  String get onboardingM3uUrl => 'زیادکردنی M3U بە بەستەر';

  @override
  String get onboardingM3uFile => 'زیادکردنی M3U بە فایل';

  @override
  String get onboardingXtream => 'زیادکردنی Xtream API';

  @override
  String get onboardingSinglePlay => 'پەخشکردنی تاقانە (URL)';

  @override
  String get titleEditM3U => 'فایلێکی M3U هەڵبژێرە';

  @override
  String get liveCreateFormItemLabelUrl => 'بەستەری ڕاستەوخۆ (URL)';

  @override
  String get liveCreateFormItemHelperUrl => 'تەنها سەرچاوەکانی بە شێوەی m3u پشتگیری دەکرێن';

  @override
  String get formValidatorRequired => 'ئەم خانەیە پێویستە';

  @override
  String get formValidatorUrl => 'تکایە بەستەرێکی دروست بنووسە';

  @override
  String get formValidatorYear => 'تکایە ساڵێکی دروست بنووسە';

  @override
  String get loginFormItemLabelUsername => 'ناوی بەکارهێنەر';

  @override
  String get loginFormItemLabelPwd => 'وشەی نهێنی';

}
