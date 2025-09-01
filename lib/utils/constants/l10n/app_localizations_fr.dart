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
  String get settings => 'Paramètres';

  @override
  String get generic_error_message => 'Une erreur s\'est produite';

  @override
  String get confirm => 'Confirmer';

  @override
  String get cancel => 'Annuler';

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
  String create_note_single_date_count(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dates',
      one: '1 date',
      zero: 'Aucune date',
    );
    return '$_temp0';
  }

  @override
  String create_note_recurrent_date_count(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dates récurrentes',
      one: '1 date récurrente',
      zero: 'Aucune date récurrente',
    );
    return '$_temp0';
  }

  @override
  String get create_note_add_single_date_button => 'Ajouter une date';

  @override
  String get create_note_add_recurrent_date_button =>
      'Ajouter une date récurrente';

  @override
  String get create_note_success_feedback => 'Note créée avec succès';

  @override
  String get create_date_title => 'Ajouter une date';

  @override
  String get create_start_date_field_title => 'Date de début';

  @override
  String get create_end_date_field_title => 'Date de fin (optionnelle)';

  @override
  String get create_date_timeline_error =>
      'La date de fin ne peut pas être antérieure à la date de départ';

  @override
  String delete_date_confirmation_title(String isRecurrent) {
    String _temp0 = intl.Intl.selectLogic(isRecurrent, {
      'true': 'Supprimer la date récurrente',
      'other': 'Supprimer la date',
    });
    return '$_temp0';
  }

  @override
  String delete_date_confirmation_message(Object date, String isRecurrent) {
    String _temp0 = intl.Intl.selectLogic(isRecurrent, {
      'true': 'date récurrente',
      'other': 'date',
    });
    return 'Êtes-vous sûr de vouloir supprimer la $_temp0: $date?';
  }

  @override
  String get delete_date_success_feedback => 'Date supprimée avec succès';

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
}
