import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 's_en.dart';
import 's_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/s.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Kisaan Saathi'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Your farming, Our responsibility'**
  String get appTagline;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navNews.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get navNews;

  /// No description provided for @navAlarm.
  ///
  /// In en, this message translates to:
  /// **'Alarm'**
  String get navAlarm;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @homeSeeds.
  ///
  /// In en, this message translates to:
  /// **'Seeds'**
  String get homeSeeds;

  /// No description provided for @homeSeedsSub.
  ///
  /// In en, this message translates to:
  /// **'Seeds'**
  String get homeSeedsSub;

  /// No description provided for @homeFertilizers.
  ///
  /// In en, this message translates to:
  /// **'Fertilizers'**
  String get homeFertilizers;

  /// No description provided for @homeFertilizersSub.
  ///
  /// In en, this message translates to:
  /// **'Fertilizers'**
  String get homeFertilizersSub;

  /// No description provided for @homePesticides.
  ///
  /// In en, this message translates to:
  /// **'Pesticides'**
  String get homePesticides;

  /// No description provided for @homePesticidesSub.
  ///
  /// In en, this message translates to:
  /// **'Pesticides'**
  String get homePesticidesSub;

  /// No description provided for @homeTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get homeTools;

  /// No description provided for @homeToolsSub.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get homeToolsSub;

  /// No description provided for @homeIrrigation.
  ///
  /// In en, this message translates to:
  /// **'Irrigation'**
  String get homeIrrigation;

  /// No description provided for @homeIrrigationSub.
  ///
  /// In en, this message translates to:
  /// **'Irrigation'**
  String get homeIrrigationSub;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @termsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Terms & Privacy Policy'**
  String get termsPrivacy;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @whatsappNotInstalled.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp is not installed'**
  String get whatsappNotInstalled;

  /// No description provided for @alarmTitle.
  ///
  /// In en, this message translates to:
  /// **'Alarm / Reminder'**
  String get alarmTitle;

  /// No description provided for @addAlarm.
  ///
  /// In en, this message translates to:
  /// **'Add Alarm'**
  String get addAlarm;

  /// No description provided for @noAlarms.
  ///
  /// In en, this message translates to:
  /// **'No Alarms'**
  String get noAlarms;

  /// No description provided for @pressPlusToAdd.
  ///
  /// In en, this message translates to:
  /// **'Press + button below to add an alarm'**
  String get pressPlusToAdd;

  /// No description provided for @alarmHint.
  ///
  /// In en, this message translates to:
  /// **'Watering fields, spraying medicines,\nsowing seeds - all reminders!'**
  String get alarmHint;

  /// No description provided for @enterTaskName.
  ///
  /// In en, this message translates to:
  /// **'Enter Task Name'**
  String get enterTaskName;

  /// No description provided for @taskHintExample.
  ///
  /// In en, this message translates to:
  /// **'e.g.: Water the fields'**
  String get taskHintExample;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @alarmSet.
  ///
  /// In en, this message translates to:
  /// **'Alarm set'**
  String get alarmSet;

  /// No description provided for @swipeToDelete.
  ///
  /// In en, this message translates to:
  /// **'← Swipe to delete'**
  String get swipeToDelete;

  /// No description provided for @periodNight.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get periodNight;

  /// No description provided for @periodMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get periodMorning;

  /// No description provided for @periodNoon.
  ///
  /// In en, this message translates to:
  /// **'Noon'**
  String get periodNoon;

  /// No description provided for @periodEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get periodEvening;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @selectLanguageHindi.
  ///
  /// In en, this message translates to:
  /// **'भाषा चुनें'**
  String get selectLanguageHindi;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hindiDescription.
  ///
  /// In en, this message translates to:
  /// **'Use the app in Hindi'**
  String get hindiDescription;

  /// No description provided for @englishDescription.
  ///
  /// In en, this message translates to:
  /// **'Use the app in English'**
  String get englishDescription;

  /// No description provided for @changeLanguageLater.
  ///
  /// In en, this message translates to:
  /// **'You can change the language later'**
  String get changeLanguageLater;

  /// No description provided for @detailAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get detailAbout;

  /// No description provided for @detailFieldPreparation.
  ///
  /// In en, this message translates to:
  /// **'Field Preparation'**
  String get detailFieldPreparation;

  /// No description provided for @detailSoilType.
  ///
  /// In en, this message translates to:
  /// **'Soil Type'**
  String get detailSoilType;

  /// No description provided for @detailSeedRate.
  ///
  /// In en, this message translates to:
  /// **'Seed Rate'**
  String get detailSeedRate;

  /// No description provided for @detailSowingMethod.
  ///
  /// In en, this message translates to:
  /// **'Sowing Method'**
  String get detailSowingMethod;

  /// No description provided for @detailIrrigation.
  ///
  /// In en, this message translates to:
  /// **'Irrigation'**
  String get detailIrrigation;

  /// No description provided for @detailFertilizer.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer'**
  String get detailFertilizer;

  /// No description provided for @detailPestControl.
  ///
  /// In en, this message translates to:
  /// **'Pest Control'**
  String get detailPestControl;

  /// No description provided for @detailDiseaseControl.
  ///
  /// In en, this message translates to:
  /// **'Disease Control'**
  String get detailDiseaseControl;

  /// No description provided for @detailHarvesting.
  ///
  /// In en, this message translates to:
  /// **'Harvesting'**
  String get detailHarvesting;

  /// No description provided for @detailYield.
  ///
  /// In en, this message translates to:
  /// **'Yield'**
  String get detailYield;

  /// No description provided for @detailHowToUse.
  ///
  /// In en, this message translates to:
  /// **'How to Use'**
  String get detailHowToUse;

  /// No description provided for @detailBestFor.
  ///
  /// In en, this message translates to:
  /// **'Best For'**
  String get detailBestFor;

  /// No description provided for @detailMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get detailMaintenance;

  /// No description provided for @detailSafetyTips.
  ///
  /// In en, this message translates to:
  /// **'Safety Tips'**
  String get detailSafetyTips;

  /// No description provided for @detailPriceRange.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get detailPriceRange;

  /// No description provided for @detailAdvantages.
  ///
  /// In en, this message translates to:
  /// **'Advantages'**
  String get detailAdvantages;

  /// No description provided for @detailDisadvantages.
  ///
  /// In en, this message translates to:
  /// **'Disadvantages'**
  String get detailDisadvantages;

  /// No description provided for @detailSuitableCrops.
  ///
  /// In en, this message translates to:
  /// **'Suitable Crops'**
  String get detailSuitableCrops;

  /// No description provided for @detailWaterEfficiency.
  ///
  /// In en, this message translates to:
  /// **'Water Efficiency'**
  String get detailWaterEfficiency;

  /// No description provided for @detailCost.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get detailCost;

  /// No description provided for @watchVideo.
  ///
  /// In en, this message translates to:
  /// **'Watch Video'**
  String get watchVideo;

  /// No description provided for @seedGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'Seed Guide'**
  String get seedGuideTitle;

  /// No description provided for @toolGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'Tool Guide'**
  String get toolGuideTitle;

  /// No description provided for @irrigationGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'Irrigation Guide'**
  String get irrigationGuideTitle;

  /// No description provided for @fertilizerPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Fertilizers'**
  String get fertilizerPageTitle;

  /// No description provided for @searchSeedsHint.
  ///
  /// In en, this message translates to:
  /// **'Search seeds...'**
  String get searchSeedsHint;

  /// No description provided for @searchToolsHint.
  ///
  /// In en, this message translates to:
  /// **'Search tools...'**
  String get searchToolsHint;

  /// No description provided for @searchIrrigationHint.
  ///
  /// In en, this message translates to:
  /// **'Search irrigation...'**
  String get searchIrrigationHint;

  /// No description provided for @searchFertilizersHint.
  ///
  /// In en, this message translates to:
  /// **'Search fertilizers...'**
  String get searchFertilizersHint;

  /// No description provided for @noSeedsFound.
  ///
  /// In en, this message translates to:
  /// **'No seeds found'**
  String get noSeedsFound;

  /// No description provided for @noToolsFound.
  ///
  /// In en, this message translates to:
  /// **'No tools found'**
  String get noToolsFound;

  /// No description provided for @noIrrigationFound.
  ///
  /// In en, this message translates to:
  /// **'No irrigation methods found'**
  String get noIrrigationFound;

  /// No description provided for @noItemsFound.
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get noItemsFound;

  /// No description provided for @tryDifferentSearch.
  ///
  /// In en, this message translates to:
  /// **'Try a different search'**
  String get tryDifferentSearch;

  /// No description provided for @noSeedsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No seeds available'**
  String get noSeedsAvailable;

  /// No description provided for @noToolsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No tools available'**
  String get noToolsAvailable;

  /// No description provided for @noIrrigationAvailable.
  ///
  /// In en, this message translates to:
  /// **'No methods available'**
  String get noIrrigationAvailable;

  /// No description provided for @informationPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Irrigation Information'**
  String get informationPageTitle;

  /// No description provided for @watchDemoVideo.
  ///
  /// In en, this message translates to:
  /// **'Watch Demo Video'**
  String get watchDemoVideo;

  /// No description provided for @irrigationTitle.
  ///
  /// In en, this message translates to:
  /// **'Irrigation'**
  String get irrigationTitle;

  /// No description provided for @irrigationDescription1.
  ///
  /// In en, this message translates to:
  /// **'Wheat: Irrigate every 20–25 days depending on soil moisture.'**
  String get irrigationDescription1;

  /// No description provided for @irrigationDescription2.
  ///
  /// In en, this message translates to:
  /// **'Rice: Requires standing water – keep fields flooded regularly.'**
  String get irrigationDescription2;

  /// No description provided for @irrigationDescription3.
  ///
  /// In en, this message translates to:
  /// **'Vegetables: Light irrigation every 4–5 days is ideal.'**
  String get irrigationDescription3;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return SEn();
    case 'hi':
      return SHi();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
