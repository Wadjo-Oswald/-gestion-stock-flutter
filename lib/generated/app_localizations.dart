import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
    Locale('fr'),
    Locale('en'),
  ];

  /// No description provided for @loginTitle.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get loginTitle;

  /// No description provided for @email.
  ///
  /// In fr, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @password.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get password;

  /// No description provided for @loginButton.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get loginButton;

  /// No description provided for @homeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get homeTitle;

  /// No description provided for @addProduct.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un produit'**
  String get addProduct;

  /// No description provided for @productList.
  ///
  /// In fr, this message translates to:
  /// **'Liste des produits'**
  String get productList;

  /// No description provided for @salesHistory.
  ///
  /// In fr, this message translates to:
  /// **'Historique des ventes'**
  String get salesHistory;

  /// No description provided for @language.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get language;

  /// No description provided for @products.
  ///
  /// In fr, this message translates to:
  /// **'Produits'**
  String get products;

  /// No description provided for @dashboard.
  ///
  /// In fr, this message translates to:
  /// **'Tableau de bord'**
  String get dashboard;

  /// No description provided for @restock.
  ///
  /// In fr, this message translates to:
  /// **'Réapprovisionnement'**
  String get restock;

  /// No description provided for @restockShort.
  ///
  /// In fr, this message translates to:
  /// **'Réapprov.'**
  String get restockShort;

  /// No description provided for @logout.
  ///
  /// In fr, this message translates to:
  /// **'Déconnexion'**
  String get logout;

  /// No description provided for @logoutConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment vous déconnecter ?'**
  String get logoutConfirmation;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @yes.
  ///
  /// In fr, this message translates to:
  /// **'Oui'**
  String get yes;

  /// No description provided for @sales.
  ///
  /// In fr, this message translates to:
  /// **'Ventes'**
  String get sales;

  /// No description provided for @offlineWarning.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes hors ligne. Les données seront synchronisées plus tard.'**
  String get offlineWarning;

  /// No description provided for @noSalesRecorded.
  ///
  /// In fr, this message translates to:
  /// **'Aucune vente enregistrée.'**
  String get noSalesRecorded;

  /// No description provided for @userNotLoggedIn.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateur non connecté'**
  String get userNotLoggedIn;

  /// No description provided for @date.
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @total.
  ///
  /// In fr, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @print.
  ///
  /// In fr, this message translates to:
  /// **'Imprimer'**
  String get print;

  /// No description provided for @restockHistory.
  ///
  /// In fr, this message translates to:
  /// **'Historique des réapprovisionnements'**
  String get restockHistory;

  /// No description provided for @error.
  ///
  /// In fr, this message translates to:
  /// **'Erreur'**
  String get error;

  /// No description provided for @noRestocksFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucun réapprovisionnement trouvé.'**
  String get noRestocksFound;

  /// No description provided for @unknownProduct.
  ///
  /// In fr, this message translates to:
  /// **'Produit inconnu'**
  String get unknownProduct;

  /// No description provided for @oldQuantity.
  ///
  /// In fr, this message translates to:
  /// **'Ancienne quantité'**
  String get oldQuantity;

  /// No description provided for @newQuantity.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle quantité'**
  String get newQuantity;

  /// No description provided for @productModified.
  ///
  /// In fr, this message translates to:
  /// **'Produit modifié ✅'**
  String get productModified;

  /// No description provided for @confirmDeletion.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer la suppression'**
  String get confirmDeletion;

  /// No description provided for @confirmDeleteQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment supprimer'**
  String get confirmDeleteQuestion;

  /// No description provided for @delete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get delete;

  /// No description provided for @productDeleted.
  ///
  /// In fr, this message translates to:
  /// **'Produit supprimé ✅'**
  String get productDeleted;

  /// No description provided for @addToSale.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter à la vente'**
  String get addToSale;

  /// No description provided for @add.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get add;

  /// No description provided for @insufficientStock.
  ///
  /// In fr, this message translates to:
  /// **'Stock insuffisant ❌'**
  String get insufficientStock;

  /// No description provided for @currentSale.
  ///
  /// In fr, this message translates to:
  /// **'Vente en cours'**
  String get currentSale;

  /// No description provided for @qty.
  ///
  /// In fr, this message translates to:
  /// **'Qté'**
  String get qty;

  /// No description provided for @validateSale.
  ///
  /// In fr, this message translates to:
  /// **'Valider la vente'**
  String get validateSale;

  /// No description provided for @saleValidated.
  ///
  /// In fr, this message translates to:
  /// **'Vente validée ✅'**
  String get saleValidated;

  /// No description provided for @productsLowStock.
  ///
  /// In fr, this message translates to:
  /// **'produit(s) avec stock faible'**
  String get productsLowStock;

  /// No description provided for @search.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher'**
  String get search;

  /// No description provided for @items.
  ///
  /// In fr, this message translates to:
  /// **'articles'**
  String get items;

  /// No description provided for @productExists.
  ///
  /// In fr, this message translates to:
  /// **'Ce produit existe déjà ❌'**
  String get productExists;

  /// No description provided for @productAdded.
  ///
  /// In fr, this message translates to:
  /// **'Produit ajouté ✅'**
  String get productAdded;

  /// No description provided for @edit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get edit;

  /// No description provided for @name.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get name;

  /// No description provided for @quantity.
  ///
  /// In fr, this message translates to:
  /// **'Quantité'**
  String get quantity;

  /// No description provided for @price.
  ///
  /// In fr, this message translates to:
  /// **'Prix'**
  String get price;

  /// No description provided for @requiredField.
  ///
  /// In fr, this message translates to:
  /// **'Ce champ est requis'**
  String get requiredField;

  /// No description provided for @save.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get save;

  /// No description provided for @totalSoldToday.
  ///
  /// In fr, this message translates to:
  /// **'Total vendu aujourd’hui'**
  String get totalSoldToday;

  /// No description provided for @totalSoldThisWeek.
  ///
  /// In fr, this message translates to:
  /// **'Total vendu cette semaine'**
  String get totalSoldThisWeek;

  /// No description provided for @top3SoldProducts.
  ///
  /// In fr, this message translates to:
  /// **'Top 3 produits vendus'**
  String get top3SoldProducts;

  /// No description provided for @sold.
  ///
  /// In fr, this message translates to:
  /// **'vendu(s)'**
  String get sold;

  /// No description provided for @loadingError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors du chargement des données.'**
  String get loadingError;

  /// No description provided for @activitySummary.
  ///
  /// In fr, this message translates to:
  /// **'Résumé de l\'activité'**
  String get activitySummary;

  /// No description provided for @restocks.
  ///
  /// In fr, this message translates to:
  /// **'Réapprovisionnements'**
  String get restocks;

  /// No description provided for @registerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Inscription'**
  String get registerTitle;

  /// No description provided for @invalidEmail.
  ///
  /// In fr, this message translates to:
  /// **'Email invalide'**
  String get invalidEmail;

  /// No description provided for @enterpriseName.
  ///
  /// In fr, this message translates to:
  /// **'Nom de l\'entreprise'**
  String get enterpriseName;

  /// No description provided for @confirmPassword.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le mot de passe'**
  String get confirmPassword;

  /// No description provided for @minPasswordLength.
  ///
  /// In fr, this message translates to:
  /// **'Minimum 6 caractères'**
  String get minPasswordLength;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In fr, this message translates to:
  /// **'Les mots de passe ne correspondent pas'**
  String get passwordsDontMatch;

  /// No description provided for @signUp.
  ///
  /// In fr, this message translates to:
  /// **'S\'inscrire'**
  String get signUp;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In fr, this message translates to:
  /// **'Déjà un compte ? Se connecter'**
  String get alreadyHaveAccount;

  /// No description provided for @changeLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Changer langue'**
  String get changeLanguage;

  /// No description provided for @passwordTooShort.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe trop court'**
  String get passwordTooShort;

  /// No description provided for @registerButton.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get registerButton;

  /// No description provided for @loginError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la connexion'**
  String get loginError;

  /// No description provided for @login.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get login;

  /// No description provided for @french.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get french;

  /// No description provided for @about.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get about;

  /// No description provided for @aboutDescription.
  ///
  /// In fr, this message translates to:
  /// **'WandaStock est une application de gestion de stock simple et efficace, créée par Wadjcode.'**
  String get aboutDescription;

  /// No description provided for @contactMe.
  ///
  /// In fr, this message translates to:
  /// **'Contactez-moi'**
  String get contactMe;

  /// No description provided for @contactEmail.
  ///
  /// In fr, this message translates to:
  /// **'Email : wadjooswald22@gmail.com'**
  String get contactEmail;

  /// No description provided for @featuresTitle.
  ///
  /// In fr, this message translates to:
  /// **'Fonctionnalités de l\'application'**
  String get featuresTitle;

  /// No description provided for @feature1.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter des produits'**
  String get feature1;

  /// No description provided for @feature2.
  ///
  /// In fr, this message translates to:
  /// **'Modifier et supprimer des produits'**
  String get feature2;

  /// No description provided for @feature3.
  ///
  /// In fr, this message translates to:
  /// **'Ventes avec historique'**
  String get feature3;

  /// No description provided for @feature4.
  ///
  /// In fr, this message translates to:
  /// **'Réapprovisionnements avec historique'**
  String get feature4;

  /// No description provided for @feature5.
  ///
  /// In fr, this message translates to:
  /// **'Mode hors ligne'**
  String get feature5;

  /// No description provided for @feature6.
  ///
  /// In fr, this message translates to:
  /// **'Multi-langue (Français / Anglais)'**
  String get feature6;

  /// No description provided for @appName.
  ///
  /// In fr, this message translates to:
  /// **'WandaStock'**
  String get appName;

  /// No description provided for @location.
  ///
  /// In fr, this message translates to:
  /// **'Douala, Cameroun'**
  String get location;

  /// No description provided for @english.
  ///
  /// In fr, this message translates to:
  /// **'Anglais'**
  String get english;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
