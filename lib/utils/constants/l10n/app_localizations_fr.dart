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
  String get create_category_create_button_label => 'Créer';

  @override
  String get create_category_cancel_button_label => 'Annuler';

  @override
  String get create_category_success_feedback => 'Catégorie créée avec succès';

  @override
  String get delete_category_confirmation_title => 'Supprimer la catégorie';

  @override
  String delete_category_confirmation_message(Object categoryName) {
    return 'Êtes-vous sûr de vouloir supprimer la catégorie: $categoryName?';
  }
}
