import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

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
/// import 'l10n/app_localizations.dart';
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
  static const List<Locale> supportedLocales = <Locale>[Locale('fr')];

  /// No description provided for @notes.
  ///
  /// In fr, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @categories.
  ///
  /// In fr, this message translates to:
  /// **'Catégories'**
  String get categories;

  /// No description provided for @note_types.
  ///
  /// In fr, this message translates to:
  /// **'Types de notes'**
  String get note_types;

  /// No description provided for @settings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settings;

  /// No description provided for @generic_error_message.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur s\'est produite'**
  String get generic_error_message;

  /// No description provided for @confirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get delete;

  /// No description provided for @create.
  ///
  /// In fr, this message translates to:
  /// **'Créer'**
  String get create;

  /// No description provided for @edit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get edit;

  /// No description provided for @save.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get save;

  /// No description provided for @search.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher'**
  String get search;

  /// No description provided for @monday.
  ///
  /// In fr, this message translates to:
  /// **'Lundi'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In fr, this message translates to:
  /// **'Mardi'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In fr, this message translates to:
  /// **'Mercredi'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In fr, this message translates to:
  /// **'Jeudi'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In fr, this message translates to:
  /// **'Vendredi'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In fr, this message translates to:
  /// **'Samedi'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In fr, this message translates to:
  /// **'Dimanche'**
  String get sunday;

  /// No description provided for @everyday.
  ///
  /// In fr, this message translates to:
  /// **'Tous les jours'**
  String get everyday;

  /// No description provided for @no_results_found.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat trouvé'**
  String get no_results_found;

  /// No description provided for @create_category_title.
  ///
  /// In fr, this message translates to:
  /// **'Créer une catégorie'**
  String get create_category_title;

  /// No description provided for @create_category_name_field_title.
  ///
  /// In fr, this message translates to:
  /// **'Nom de la catégorie'**
  String get create_category_name_field_title;

  /// No description provided for @create_category_name_field_hint.
  ///
  /// In fr, this message translates to:
  /// **'Entrez le nom de la catégorie'**
  String get create_category_name_field_hint;

  /// No description provided for @create_category_name_exists_already.
  ///
  /// In fr, this message translates to:
  /// **'Cette catégorie existe déjà'**
  String get create_category_name_exists_already;

  /// No description provided for @create_category_name_invalid_length.
  ///
  /// In fr, this message translates to:
  /// **'Le nom de la catégorie doit comporter entre 3 et 120 caractères'**
  String get create_category_name_invalid_length;

  /// No description provided for @create_category_success_feedback.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie créée avec succès'**
  String get create_category_success_feedback;

  /// No description provided for @edit_category_title.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la catégorie'**
  String get edit_category_title;

  /// No description provided for @edit_category_success_feedback.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie modifiée avec succès'**
  String get edit_category_success_feedback;

  /// No description provided for @delete_category_confirmation_title.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la catégorie'**
  String get delete_category_confirmation_title;

  /// No description provided for @delete_category_confirmation_message.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir supprimer la catégorie: {categoryName}?'**
  String delete_category_confirmation_message(Object categoryName);

  /// No description provided for @delete_category_error_message.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur s\'est produite lors de la suppression de la catégorie'**
  String get delete_category_error_message;

  /// No description provided for @delete_category_success_feedback.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie supprimée avec succès'**
  String get delete_category_success_feedback;

  /// No description provided for @create_note_type_title.
  ///
  /// In fr, this message translates to:
  /// **'Créer un type de note'**
  String get create_note_type_title;

  /// No description provided for @create_note_type_name_field_title.
  ///
  /// In fr, this message translates to:
  /// **'Nom du type de note'**
  String get create_note_type_name_field_title;

  /// No description provided for @create_note_type_name_field_hint.
  ///
  /// In fr, this message translates to:
  /// **'Entrez le nom du type de note'**
  String get create_note_type_name_field_hint;

  /// No description provided for @create_note_type_name_exists_already.
  ///
  /// In fr, this message translates to:
  /// **'Ce type de note existe déjà'**
  String get create_note_type_name_exists_already;

  /// No description provided for @create_note_type_name_invalid_length.
  ///
  /// In fr, this message translates to:
  /// **'Le nom du type de note doit comporter entre 3 et 120 caractères'**
  String get create_note_type_name_invalid_length;

  /// No description provided for @create_note_type_success_feedback.
  ///
  /// In fr, this message translates to:
  /// **'Type de note créé avec succès'**
  String get create_note_type_success_feedback;

  /// No description provided for @edit_note_type_title.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le type de note'**
  String get edit_note_type_title;

  /// No description provided for @edit_note_type_success_feedback.
  ///
  /// In fr, this message translates to:
  /// **'Type de note modifié avec succès'**
  String get edit_note_type_success_feedback;

  /// No description provided for @delete_note_type_confirmation_title.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le type de note'**
  String get delete_note_type_confirmation_title;

  /// No description provided for @delete_note_type_confirmation_message.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir supprimer le type de note: {noteTypeName}?'**
  String delete_note_type_confirmation_message(Object noteTypeName);

  /// No description provided for @delete_note_type_error_message.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur s\'est produite lors de la suppression du type de note'**
  String get delete_note_type_error_message;

  /// No description provided for @delete_note_type_success_feedback.
  ///
  /// In fr, this message translates to:
  /// **'Type de note supprimé avec succès'**
  String get delete_note_type_success_feedback;

  /// No description provided for @create_note_title.
  ///
  /// In fr, this message translates to:
  /// **'Créer une note'**
  String get create_note_title;

  /// No description provided for @create_note_title_field_title.
  ///
  /// In fr, this message translates to:
  /// **'Titre de la note'**
  String get create_note_title_field_title;

  /// No description provided for @create_note_title_field_hint.
  ///
  /// In fr, this message translates to:
  /// **'Entrez le titre de la note'**
  String get create_note_title_field_hint;

  /// No description provided for @create_note_title_invalid_length.
  ///
  /// In fr, this message translates to:
  /// **'Le titre de la note doit comporter entre 3 et 120 caractères'**
  String get create_note_title_invalid_length;

  /// No description provided for @create_note_content_field_title.
  ///
  /// In fr, this message translates to:
  /// **'Contenu de la note'**
  String get create_note_content_field_title;

  /// No description provided for @create_note_content_field_hint.
  ///
  /// In fr, this message translates to:
  /// **'Entrez le contenu de la note'**
  String get create_note_content_field_hint;

  /// No description provided for @create_note_content_invalid_length.
  ///
  /// In fr, this message translates to:
  /// **'Le contenu de la note ne peut pas être vide'**
  String get create_note_content_invalid_length;

  /// No description provided for @create_note_categories_field_title.
  ///
  /// In fr, this message translates to:
  /// **'Catégories'**
  String get create_note_categories_field_title;

  /// No description provided for @create_note_type_field_title.
  ///
  /// In fr, this message translates to:
  /// **'Type de note'**
  String get create_note_type_field_title;

  /// No description provided for @create_note_single_date_count.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucune date} one{1 date} other{{count} dates}}'**
  String create_note_single_date_count(num count);

  /// No description provided for @create_note_recurrent_date_count.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucune date récurrente} one{1 récurrence} other{{count} récurrences}}'**
  String create_note_recurrent_date_count(num count);

  /// No description provided for @create_note_add_single_date_button.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une date'**
  String get create_note_add_single_date_button;

  /// No description provided for @create_note_add_recurrent_date_button.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une récurrence'**
  String get create_note_add_recurrent_date_button;

  /// No description provided for @create_note_success_feedback.
  ///
  /// In fr, this message translates to:
  /// **'Note créée avec succès'**
  String get create_note_success_feedback;

  /// No description provided for @create_date_title.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une date'**
  String get create_date_title;

  /// No description provided for @create_start_date_field_title.
  ///
  /// In fr, this message translates to:
  /// **'Début de l\'événement'**
  String get create_start_date_field_title;

  /// No description provided for @create_end_date_field_title.
  ///
  /// In fr, this message translates to:
  /// **'Fin de l\'événement (optionnelle)'**
  String get create_end_date_field_title;

  /// No description provided for @create_date_timeline_error.
  ///
  /// In fr, this message translates to:
  /// **'La date de fin ne peut pas être antérieure à la date de début'**
  String get create_date_timeline_error;

  /// No description provided for @create_date_alarm_count.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucun rappel} one{1 rappel} other{{count} rappels}}'**
  String create_date_alarm_count(num count);

  /// No description provided for @create_date_add_alarm_button.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un rappel'**
  String get create_date_add_alarm_button;

  /// No description provided for @delete_single_date_confirmation_title.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la date'**
  String get delete_single_date_confirmation_title;

  /// No description provided for @delete_single_date_confirmation_message.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir supprimer la date: {date}? {isFromEdit, select, true{Cette action est irréversible et indépendante de la modification de la note.} other{}}'**
  String delete_single_date_confirmation_message(
    Object date,
    String isFromEdit,
  );

  /// No description provided for @delete_recurrent_date_confirmation_title.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la récurrence'**
  String get delete_recurrent_date_confirmation_title;

  /// No description provided for @delete_recurrent_date_confirmation_message.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir supprimer la récurrence: {date}? {isFromEdit, select, true{Cette action est irréversible et indépendante de la modification de la note.} other{}}'**
  String delete_recurrent_date_confirmation_message(
    Object date,
    String isFromEdit,
  );

  /// No description provided for @delete_date_success_feedback.
  ///
  /// In fr, this message translates to:
  /// **'Date supprimée avec succès'**
  String get delete_date_success_feedback;

  /// No description provided for @delete_recurrence_success_feedback.
  ///
  /// In fr, this message translates to:
  /// **'Récurrence supprimée avec succès'**
  String get delete_recurrence_success_feedback;

  /// No description provided for @create_single_date_success_feedback.
  ///
  /// In fr, this message translates to:
  /// **'Date ajoutée avec succès'**
  String get create_single_date_success_feedback;

  /// No description provided for @edit_single_date_success_feedback.
  ///
  /// In fr, this message translates to:
  /// **'Date modifiée avec succès'**
  String get edit_single_date_success_feedback;

  /// No description provided for @create_recurrent_date_success_feedback.
  ///
  /// In fr, this message translates to:
  /// **'Récurrence ajoutée avec succès'**
  String get create_recurrent_date_success_feedback;

  /// No description provided for @edit_recurrent_date_success_feedback.
  ///
  /// In fr, this message translates to:
  /// **'Récurrence modifiée avec succès'**
  String get edit_recurrent_date_success_feedback;

  /// No description provided for @recurrent_date_day_interval_display_text.
  ///
  /// In fr, this message translates to:
  /// **'Tous les {count} jours'**
  String recurrent_date_day_interval_display_text(Object count);

  /// No description provided for @recurrent_date_years_interval_display_text.
  ///
  /// In fr, this message translates to:
  /// **'Tous les {count} ans'**
  String recurrent_date_years_interval_display_text(Object count);

  /// No description provided for @recurrent_date_month_date_display_text.
  ///
  /// In fr, this message translates to:
  /// **'Tous les {count} du mois'**
  String recurrent_date_month_date_display_text(Object count);

  /// No description provided for @recurrent_date_weekday_display_text.
  ///
  /// In fr, this message translates to:
  /// **'Tous les semaines, le: {weekdays}'**
  String recurrent_date_weekday_display_text(Object weekdays);

  /// No description provided for @date_recurrence_days.
  ///
  /// In fr, this message translates to:
  /// **'Jours'**
  String get date_recurrence_days;

  /// No description provided for @date_recurrence_weeks.
  ///
  /// In fr, this message translates to:
  /// **'Semaines'**
  String get date_recurrence_weeks;

  /// No description provided for @date_recurrence_months.
  ///
  /// In fr, this message translates to:
  /// **'Mois'**
  String get date_recurrence_months;

  /// No description provided for @date_recurrence_years.
  ///
  /// In fr, this message translates to:
  /// **'Années'**
  String get date_recurrence_years;

  /// No description provided for @create_recurrent_date_field_title.
  ///
  /// In fr, this message translates to:
  /// **'Récurrence'**
  String get create_recurrent_date_field_title;

  /// No description provided for @create_recurrent_date_interval_field_title.
  ///
  /// In fr, this message translates to:
  /// **'Intervalle'**
  String get create_recurrent_date_interval_field_title;

  /// No description provided for @create_recurrent_date_interval_field_hint.
  ///
  /// In fr, this message translates to:
  /// **'Entrez l\'intervalle'**
  String get create_recurrent_date_interval_field_hint;

  /// No description provided for @create_recurrent_date_invalid_interval.
  ///
  /// In fr, this message translates to:
  /// **'L\'intervalle doit être un nombre entier positif'**
  String get create_recurrent_date_invalid_interval;

  /// No description provided for @create_recurrent_date_type_field_title.
  ///
  /// In fr, this message translates to:
  /// **'Type de récurrence'**
  String get create_recurrent_date_type_field_title;

  /// No description provided for @create_recurrent_date_month_day_field_title.
  ///
  /// In fr, this message translates to:
  /// **'Jour du mois'**
  String get create_recurrent_date_month_day_field_title;

  /// No description provided for @create_recurrent_date_month_day_field_hint.
  ///
  /// In fr, this message translates to:
  /// **'Entrez le jour du mois (1-31)'**
  String get create_recurrent_date_month_day_field_hint;

  /// No description provided for @create_recurrent_date_invalid_month_day.
  ///
  /// In fr, this message translates to:
  /// **'Le jour du mois doit être un nombre entier entre 1 et 31'**
  String get create_recurrent_date_invalid_month_day;

  /// No description provided for @create_recurrent_date_weekdays_field_title.
  ///
  /// In fr, this message translates to:
  /// **'Jours de la semaine'**
  String get create_recurrent_date_weekdays_field_title;

  /// No description provided for @create_recurrent_date_no_weekday_selected.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner au moins un jour de la semaine'**
  String get create_recurrent_date_no_weekday_selected;

  /// No description provided for @create_recurrent_date_recurrence_end_field_title.
  ///
  /// In fr, this message translates to:
  /// **'Fin de la récurrence (optionnelle)'**
  String get create_recurrent_date_recurrence_end_field_title;

  /// No description provided for @create_recurrent_date_recurrence_end_error.
  ///
  /// In fr, this message translates to:
  /// **'La date de fin de la récurrence doit être postérieure à la date de début'**
  String get create_recurrent_date_recurrence_end_error;

  /// No description provided for @edit_note_title.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la note'**
  String get edit_note_title;

  /// No description provided for @edit_note_success_feedback.
  ///
  /// In fr, this message translates to:
  /// **'Note modifiée avec succès'**
  String get edit_note_success_feedback;

  /// No description provided for @delete_note_confirmation_title.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la note'**
  String get delete_note_confirmation_title;

  /// No description provided for @delete_note_confirmation_message.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir supprimer la note: {noteTitle}?'**
  String delete_note_confirmation_message(Object noteTitle);

  /// No description provided for @delete_note_error_message.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur s\'est produite lors de la suppression de la note'**
  String get delete_note_error_message;

  /// No description provided for @delete_note_success_feedback.
  ///
  /// In fr, this message translates to:
  /// **'Note supprimée avec succès'**
  String get delete_note_success_feedback;

  /// No description provided for @alarm_title.
  ///
  /// In fr, this message translates to:
  /// **'Rappel'**
  String get alarm_title;

  /// No description provided for @alarm_set_button.
  ///
  /// In fr, this message translates to:
  /// **'Définir le rappel'**
  String get alarm_set_button;

  /// No description provided for @alarm_no_alarms.
  ///
  /// In fr, this message translates to:
  /// **'Aucun rappel défini'**
  String get alarm_no_alarms;

  /// No description provided for @alarm_display_text.
  ///
  /// In fr, this message translates to:
  /// **'Alarme {index}: {count, plural, =0{Aucun délai} one{1 {unit} avant} other{{count} {unit}s avant}}'**
  String alarm_display_text(num count, Object index, Object unit);

  /// No description provided for @alarm_delete_button.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le rappel'**
  String get alarm_delete_button;

  /// No description provided for @alarm_add_success_feedback.
  ///
  /// In fr, this message translates to:
  /// **'Rappel ajouté avec succès'**
  String get alarm_add_success_feedback;

  /// No description provided for @alarm_edit_success_feedback.
  ///
  /// In fr, this message translates to:
  /// **'Rappel modifié avec succès'**
  String get alarm_edit_success_feedback;

  /// No description provided for @alarm_delete_confirmation_title.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le rappel'**
  String get alarm_delete_confirmation_title;

  /// No description provided for @alarm_delete_confirmation_message.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir supprimer le rappel {index}? {isFromEdit, select, true{Cette action est irréversible et indépendante de la modification de la note.} other{}}'**
  String alarm_delete_confirmation_message(Object index, String isFromEdit);

  /// No description provided for @alarm_delete_success_feedback.
  ///
  /// In fr, this message translates to:
  /// **'Rappel supprimé avec succès'**
  String get alarm_delete_success_feedback;

  /// No description provided for @alarm_offset_type_days.
  ///
  /// In fr, this message translates to:
  /// **'Jour'**
  String get alarm_offset_type_days;

  /// No description provided for @alarm_offset_type_hours.
  ///
  /// In fr, this message translates to:
  /// **'Heure'**
  String get alarm_offset_type_hours;

  /// No description provided for @alarm_offset_type_minutes.
  ///
  /// In fr, this message translates to:
  /// **'Minute'**
  String get alarm_offset_type_minutes;

  /// No description provided for @alarm_offset_type_field_title.
  ///
  /// In fr, this message translates to:
  /// **'Type de décalage'**
  String get alarm_offset_type_field_title;

  /// No description provided for @alarm_offset_value_field_title.
  ///
  /// In fr, this message translates to:
  /// **'Valeur du décalage'**
  String get alarm_offset_value_field_title;

  /// No description provided for @alarm_offset_value_field_hint.
  ///
  /// In fr, this message translates to:
  /// **'Entrez la valeur du décalage'**
  String get alarm_offset_value_field_hint;

  /// No description provided for @alarm_offset_value_invalid.
  ///
  /// In fr, this message translates to:
  /// **'La valeur du décalage doit être positive et strictement numérique'**
  String get alarm_offset_value_invalid;

  /// No description provided for @alarm_silent_checkbox_title.
  ///
  /// In fr, this message translates to:
  /// **'Rappel silencieux'**
  String get alarm_silent_checkbox_title;
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
      <String>['fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
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
