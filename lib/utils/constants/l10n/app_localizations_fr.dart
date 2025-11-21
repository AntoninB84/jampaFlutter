// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get notes => 'Notes';

  @override
  String get categories => 'Catégories';

  @override
  String get note_types => 'Types de notes';

  @override
  String get settings => 'Paramètres';

  @override
  String get generic_error_message => 'Une erreur s\'est produite';

  @override
  String get confirm => 'Confirmer';

  @override
  String get cancel => 'Retour';

  @override
  String get delete => 'Supprimer';

  @override
  String get create => 'Créer';

  @override
  String get edit => 'Modifier';

  @override
  String get save => 'Enregistrer';

  @override
  String get search => 'Rechercher';

  @override
  String get monday => 'Lundi';

  @override
  String get tuesday => 'Mardi';

  @override
  String get wednesday => 'Mercredi';

  @override
  String get thursday => 'Jeudi';

  @override
  String get friday => 'Vendredi';

  @override
  String get saturday => 'Samedi';

  @override
  String get sunday => 'Dimanche';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get tomorrow => 'Demain';

  @override
  String get everyday => 'Tous les jours';

  @override
  String get passed => 'Passées';

  @override
  String get datetime_hint => 'Choisir une date et une heure';

  @override
  String get no_results_found => 'Aucun résultat trouvé';

  @override
  String get create_category_title => 'Créer une catégorie';

  @override
  String get create_category_name_field_title => 'Nom de la catégorie';

  @override
  String get create_category_name_field_hint => 'Entrez le nom de la catégorie';

  @override
  String get create_category_name_exists_already =>
      'Cette catégorie existe déjà';

  @override
  String get create_category_name_invalid_length =>
      'Le nom de la catégorie doit comporter entre 3 et 120 caractères';

  @override
  String get create_category_success_feedback => 'Catégorie créée avec succès';

  @override
  String get edit_category_title => 'Modifier la catégorie';

  @override
  String get edit_category_success_feedback => 'Catégorie modifiée avec succès';

  @override
  String get delete_category_confirmation_title => 'Supprimer la catégorie';

  @override
  String delete_category_confirmation_message(Object categoryName) {
    return 'Êtes-vous sûr de vouloir supprimer la catégorie: $categoryName?';
  }

  @override
  String get delete_category_error_message =>
      'Une erreur s\'est produite lors de la suppression de la catégorie';

  @override
  String get delete_category_success_feedback =>
      'Catégorie supprimée avec succès';

  @override
  String get create_note_type_title => 'Créer un type de note';

  @override
  String get create_note_type_name_field_title => 'Nom du type de note';

  @override
  String get create_note_type_name_field_hint =>
      'Entrez le nom du type de note';

  @override
  String get create_note_type_name_exists_already =>
      'Ce type de note existe déjà';

  @override
  String get create_note_type_name_invalid_length =>
      'Le nom du type de note doit comporter entre 3 et 120 caractères';

  @override
  String get create_note_type_success_feedback =>
      'Type de note créé avec succès';

  @override
  String get edit_note_type_title => 'Modifier le type de note';

  @override
  String get edit_note_type_success_feedback =>
      'Type de note modifié avec succès';

  @override
  String get delete_note_type_confirmation_title => 'Supprimer le type de note';

  @override
  String delete_note_type_confirmation_message(Object noteTypeName) {
    return 'Êtes-vous sûr de vouloir supprimer le type de note: $noteTypeName?';
  }

  @override
  String get delete_note_type_error_message =>
      'Une erreur s\'est produite lors de la suppression du type de note';

  @override
  String get delete_note_type_success_feedback =>
      'Type de note supprimé avec succès';

  @override
  String get create_note_title => 'Créer une note';

  @override
  String get create_note_title_field_title => 'Titre de la note';

  @override
  String get create_note_title_field_hint => 'Entrez le titre de la note';

  @override
  String get create_note_title_invalid_length =>
      'Le titre de la note doit comporter entre 3 et 120 caractères';

  @override
  String get create_note_content_field_title => 'Contenu de la note';

  @override
  String get create_note_content_field_hint => 'Entrez le contenu de la note';

  @override
  String get create_note_content_invalid_length =>
      'Le contenu de la note ne peut pas être vide';

  @override
  String get create_note_categories_field_title => 'Catégories';

  @override
  String get create_note_type_field_title => 'Type de note';

  @override
  String create_note_single_date_count(Object count) {
    return 'Dates ($count)';
  }

  @override
  String create_note_recurrent_date_count(Object count) {
    return 'Récurrences ($count)';
  }

  @override
  String get create_note_add_single_date_button => 'Ajouter une date';

  @override
  String get create_note_add_recurrent_date_button => 'Ajouter une récurrence';

  @override
  String get save_note_success_feedback => 'Note enregistrée avec succès';

  @override
  String get create_date_title => 'Ajouter une date';

  @override
  String get create_recurrence_title => 'Ajouter une récurrence';

  @override
  String get create_start_date_field_title => 'Début de l\'événement';

  @override
  String get create_end_date_field_title => 'Fin de l\'événement (optionnelle)';

  @override
  String get create_date_timeline_error =>
      'La date de fin ne peut pas être antérieure à la date de début';

  @override
  String create_date_alarm_count(Object count) {
    return 'Rappels ($count)';
  }

  @override
  String get create_date_add_alarm_button => 'Ajouter un rappel';

  @override
  String get delete_single_date_confirmation_title => 'Supprimer la date';

  @override
  String delete_single_date_confirmation_message(
    Object date,
    String isFromEdit,
  ) {
    String _temp0 = intl.Intl.selectLogic(isFromEdit, {
      'true':
          'Cette action est irréversible et indépendante de la modification de la note.',
      'other': '',
    });
    return 'Êtes-vous sûr de vouloir supprimer la date: $date? $_temp0';
  }

  @override
  String get delete_recurrent_date_confirmation_title =>
      'Supprimer la récurrence';

  @override
  String delete_recurrent_date_confirmation_message(
    Object date,
    String isFromEdit,
  ) {
    String _temp0 = intl.Intl.selectLogic(isFromEdit, {
      'true':
          'Cette action est irréversible et indépendante de la modification de la note.',
      'other': '',
    });
    return 'Êtes-vous sûr de vouloir supprimer la récurrence: $date? $_temp0';
  }

  @override
  String get delete_date_success_feedback => 'Date supprimée avec succès';

  @override
  String get delete_recurrence_success_feedback =>
      'Récurrence supprimée avec succès';

  @override
  String get create_single_date_success_feedback => 'Date ajoutée avec succès';

  @override
  String get edit_single_date_success_feedback => 'Date modifiée avec succès';

  @override
  String get create_recurrent_date_success_feedback =>
      'Récurrence ajoutée avec succès';

  @override
  String get edit_recurrent_date_success_feedback =>
      'Récurrence modifiée avec succès';

  @override
  String recurrent_date_day_interval_display_text(Object count) {
    return 'Tous les $count jours';
  }

  @override
  String recurrent_date_years_interval_display_text(Object count) {
    return 'Tous les $count ans';
  }

  @override
  String recurrent_date_month_date_display_text(Object count) {
    return 'Tous les $count du mois';
  }

  @override
  String recurrent_date_weekday_display_text(Object weekdays) {
    return 'Toutes les semaines, le: $weekdays';
  }

  @override
  String get date_recurrence_days => 'Jours';

  @override
  String get date_recurrence_weeks => 'Semaines';

  @override
  String get date_recurrence_months => 'Mois';

  @override
  String get date_recurrence_years => 'Années';

  @override
  String get create_recurrent_date_field_title => 'Récurrence';

  @override
  String get create_recurrent_date_interval_field_title => 'Intervalle';

  @override
  String get create_recurrent_date_interval_field_hint =>
      'Entrez l\'intervalle';

  @override
  String get create_recurrent_date_invalid_interval =>
      'L\'intervalle doit être un nombre entier positif';

  @override
  String get create_recurrent_date_type_field_title => 'Type de récurrence';

  @override
  String get create_recurrent_date_month_day_field_title => 'Jour du mois';

  @override
  String get create_recurrent_date_month_day_field_hint =>
      'Entrez le jour du mois (1-31)';

  @override
  String get create_recurrent_date_invalid_month_day =>
      'Le jour du mois doit être un nombre entier entre 1 et 31';

  @override
  String get create_recurrent_date_weekdays_field_title =>
      'Jours de la semaine';

  @override
  String get create_recurrent_date_no_weekday_selected =>
      'Veuillez sélectionner au moins un jour de la semaine';

  @override
  String get create_recurrent_date_recurrence_end_field_title =>
      'Fin de la récurrence (optionnelle)';

  @override
  String get create_recurrent_date_recurrence_end_error =>
      'La date de fin de la récurrence doit être postérieure à la date de début';

  @override
  String get edit_note_title => 'Modifier la note';

  @override
  String get edit_note_success_feedback => 'Note modifiée avec succès';

  @override
  String get delete_note_confirmation_title => 'Supprimer la note';

  @override
  String delete_note_confirmation_message(Object noteTitle) {
    return 'Êtes-vous sûr de vouloir supprimer la note: $noteTitle?';
  }

  @override
  String get delete_note_error_message =>
      'Une erreur s\'est produite lors de la suppression de la note';

  @override
  String get delete_note_success_feedback => 'Note supprimée avec succès';

  @override
  String get alarm_title => 'Rappel';

  @override
  String get alarm_set_button => 'Définir le rappel';

  @override
  String get alarm_no_alarms => 'Aucun rappel défini';

  @override
  String alarm_display_text(num count, Object index, Object unit) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ${unit}s avant',
      one: '1 $unit avant',
      zero: 'Aucun délai',
    );
    return 'Alarme $index: $_temp0';
  }

  @override
  String get alarm_delete_button => 'Supprimer le rappel';

  @override
  String get alarm_add_success_feedback => 'Rappel ajouté avec succès';

  @override
  String get alarm_edit_success_feedback => 'Rappel modifié avec succès';

  @override
  String get alarm_delete_confirmation_title => 'Supprimer le rappel';

  @override
  String alarm_delete_confirmation_message(Object index, String isFromEdit) {
    String _temp0 = intl.Intl.selectLogic(isFromEdit, {
      'true':
          'Cette action est irréversible et indépendante de la modification de la note.',
      'other': '',
    });
    return 'Êtes-vous sûr de vouloir supprimer le rappel $index? $_temp0';
  }

  @override
  String get alarm_delete_success_feedback => 'Rappel supprimé avec succès';

  @override
  String get alarm_offset_type_days => 'Jour';

  @override
  String get alarm_offset_type_hours => 'Heure';

  @override
  String get alarm_offset_type_minutes => 'Minute';

  @override
  String get alarm_offset_type_field_title => 'Type de décalage';

  @override
  String get alarm_offset_value_field_title => 'Valeur du décalage';

  @override
  String get alarm_offset_value_field_hint => 'Entrez la valeur du décalage';

  @override
  String get alarm_offset_value_invalid =>
      'La valeur du décalage doit être positive et strictement numérique';

  @override
  String get alarm_silent_checkbox_title => 'Rappel silencieux';

  @override
  String get show_note => '';

  @override
  String get show_note_schedules_and_alarms => 'Dates et rappels';

  @override
  String show_note_next_occurrence(Object date) {
    return 'Prochaine date : $date';
  }

  @override
  String show_note_previous_occurrence(Object date) {
    return 'Dernière date : $date';
  }

  @override
  String get show_note_no_schedules => 'Aucune date programmée';
}
