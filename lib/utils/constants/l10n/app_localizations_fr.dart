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
      'Le nom de la catégorie doit comporter entre 3 et 50 caractères';

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
      'Le nom du type de note doit comporter entre 3 et 50 caractères';

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
}
