
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/ui/schedule/widgets/inputs/recurrence_interval_input.dart';
import 'package:jampa_flutter/ui/schedule/widgets/inputs/recurrence_type_selector.dart';
import 'package:jampa_flutter/ui/schedule/widgets/inputs/recurrence_weekdays_multiselector.dart';
import 'package:jampa_flutter/ui/widgets/buttons/buttons.dart';
import 'package:jampa_flutter/ui/widgets/headers.dart';
import 'package:jampa_flutter/ui/widgets/inputs/datetime_input_field.dart';
import 'package:jampa_flutter/ui/widgets/jampa_scaffolded_app_bar_widget.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:jampa_flutter/utils/forms/month_day_validator.dart';
import 'package:jampa_flutter/utils/forms/positive_number_validator.dart';

import '../../../bloc/notes/save/save_note_bloc.dart';
import '../../../bloc/schedule/recurrent_date_form/recurrent_date_form_bloc.dart';
import '../../../utils/constants/styles/sizes.dart';
import '../../../utils/enums/recurrence_type_enum.dart';
import '../../../utils/enums/ui_status.dart';
import '../../reminder/widgets/save_reminder_list.dart';
import '../../widgets/error_text.dart';

class RecurrentDateFormLayout extends StatelessWidget {
  const RecurrentDateFormLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SaveNoteBloc, SaveNoteState>(
      listener: (context, state) {
        if (state.recurrentSavingStatus.isFailure) {
          SnackBarX.showError(context, context.strings.generic_error_message);
        } else if (state.recurrentSavingStatus.isSuccess) {
          SnackBarX.showSuccess(context, context.strings.save_recurrent_date_success_feedback);
          // Back to the previous screen after success
          context.pop();
        }
      },
      listenWhen: (previous, current) {
        return previous.recurrentSavingStatus != current.recurrentSavingStatus;
      },
      child: BlocBuilder<RecurrentDateFormBloc, RecurrentDateFormState>(
        builder: (context, state) {
          return JampaScaffoldedAppBarWidget(
              leading: Buttons.backButtonIcon(
                  context: context,
                  onPressed: (){
                    // Navigate back
                    context.pop();
                  }
              ),
              actions: [
                Buttons.saveButtonIcon(
                  context: context,
                  onPressed: state.isValidFormValues
                      ? () => context.read<RecurrentDateFormBloc>()
                      .add(OnSubmitRecurrentDateEvent())
                      : null,
                )
              ],
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Headers.basicHeader(
                    context: context,
                    title: context.strings.create_recurrent_schedule_title,
                  ),
                  const SizedBox(height: kGap16),

                  // Recurrence type selector, always visible
                  RecurrenceTypeSelector(
                      value: state.newRecurrentDateFormElements.selectedRecurrenceType,
                      onChanged: (value) => context.read<RecurrentDateFormBloc>().add(
                          SelectRecurrenceTypeEvent(recurrenceType: value)
                      )
                  ),
                  const SizedBox(height: kGap16),

                  // Conditional input based on selected recurrence type
                  Builder(
                      builder: (context){
                        if(state.newRecurrentDateFormElements.selectedRecurrenceType.isIntervalDays) {
                          // Show interval input for days interval
                          return RecurrenceIntervalTextField(
                              value: state.newRecurrentDateFormElements
                                  .selectedRecurrenceDaysInterval?.toString() ?? '',
                              validator: state.intervalDaysValidator,
                              onChanged: (value){
                                // Update days interval in bloc
                                context.read<RecurrentDateFormBloc>().add(
                                    ChangeRecurrenceDayIntervalEvent(interval: value)
                                );
                              },
                              hintText: context.strings.create_recurrent_date_interval_field_hint,
                              // TODO improve error handling
                              errorWidget: state.intervalDaysValidator.isNotValid ? ErrorText(
                                  errorText: (){
                                    if (state.intervalDaysValidator.displayError?.isInvalidValue ?? false) {
                                      return context.strings.create_recurrent_date_invalid_interval;
                                    }
                                    return context.strings.generic_error_message;
                                  }()
                              ) : null
                          );
                        }else if(state.newRecurrentDateFormElements.selectedRecurrenceType.isIntervalYears) {
                          // Show interval input for years interval
                          return RecurrenceIntervalTextField(
                              value: state.newRecurrentDateFormElements
                                  .selectedRecurrenceYearsInterval?.toString() ?? '',
                              validator: state.intervalYearsValidator,
                              onChanged: (value){
                                // Update years interval in bloc
                                context.read<RecurrentDateFormBloc>().add(
                                    ChangeRecurrenceYearIntervalEvent(interval: value)
                                );
                              },
                              hintText: context.strings.create_recurrent_date_interval_field_hint,
                              // TODO improve error handling
                              errorWidget: state.intervalYearsValidator.isNotValid ? ErrorText(
                                  errorText: (){
                                    if (state.intervalYearsValidator.displayError?.isInvalidValue ?? false) {
                                      return context.strings.create_recurrent_date_invalid_interval;
                                    }
                                    return context.strings.generic_error_message;
                                  }()
                              ) : null
                          );
                        }else if(state.newRecurrentDateFormElements.selectedRecurrenceType.isDayBasedMonthly) {
                          // Show month day input (e.g., 15th of every month)
                          return RecurrenceIntervalTextField(
                              value: state.newRecurrentDateFormElements
                                  .selectedRecurrenceMonthDate?.toString() ?? '',
                              validator: state.monthDateValidator,
                              onChanged: (value){
                                // Update month date in bloc
                                context.read<RecurrentDateFormBloc>().add(
                                    ChangeRecurrenceMonthDateEvent(day: value)
                                );
                              },
                              hintText: context.strings.create_recurrent_date_month_day_field_hint,
                              //TODO improve error handling
                              errorWidget: state.monthDateValidator.isNotValid ? ErrorText(
                                  errorText: (){
                                    if (state.monthDateValidator.displayError?.isInvalidValue ?? false) {
                                      return context.strings.create_recurrent_date_invalid_month_day;
                                    }
                                    return context.strings.generic_error_message;
                                  }()
                              ) : null
                          );
                        }else if(state.newRecurrentDateFormElements.selectedRecurrenceType.isDayBasedWeekly) {
                          // Show weekday multi selector (e.g., every Monday and Wednesday)
                          return RecurrenceWeekdaysMultiSelector(
                              selectedWeekdays: state.newRecurrentDateFormElements.selectedRecurrenceWeekdays ?? [],
                              onWeekdaySelected: (values) => context.read<RecurrentDateFormBloc>().add(
                                  ChangeRecurrenceWeekDaysEvent(weekDays: values)
                              ),
                              validator: (values){
                                // Validate that at least one weekday is selected
                                //TODO create a proper validator class for this ?
                                if(values == null || values.isEmpty){
                                  return context.strings.create_recurrent_date_no_weekday_selected;
                                }
                                return null;
                              }
                          );
                        } else {
                          return kEmptyWidget;
                        }
                      }
                  ),
                  const SizedBox(height: kGap16),

                  // DateTime input fields
                  DatetimeInputField(
                    label: context.strings.create_schedule_start_date_field_title,
                    initialDateTime: state.newRecurrentDateFormElements.selectedStartDateTime,
                    onDateTimeSelected: (dateTime) {
                      context.read<RecurrentDateFormBloc>().add(
                          SelectStartDateTimeEvent(dateTime: dateTime)
                      );
                    },
                  ),
                  const SizedBox(height: kGap16),

                  // End date input field
                  DatetimeInputField(
                    label: context.strings.create_schedule_end_date_field_title,
                    initialDateTime: state.newRecurrentDateFormElements.selectedEndDateTime,
                    errorText: state.isValidEndDate ? null : context.strings.create_schedule_timeline_error,
                    onDateTimeSelected: (dateTime) {
                      context.read<RecurrentDateFormBloc>().add(
                          SelectEndDateTimeEvent(dateTime: dateTime)
                      );
                    },
                  ),
                  const SizedBox(height: kGap16),

                  // Recurrence end date input field
                  DatetimeInputField(
                    label: context.strings.create_recurrent_date_recurrence_end_field_title,
                    initialDateTime: state.newRecurrentDateFormElements.selectedRecurrenceEndDate,
                    errorText: state.isValidEndRecurrenceDate ? null : context.strings.create_recurrent_date_recurrence_end_error,
                    onDateTimeSelected: (dateTime) {
                      context.read<RecurrentDateFormBloc>().add(
                          SelectRecurrenceEndDateTimeEvent(dateTime: dateTime)
                      );
                    },
                  ),
                  const SizedBox(height: kGap16),

                  // Reminder list for the recurrent date
                  SaveReminderList(
                    scheduleId: state.newRecurrentDateFormElements.scheduleId,
                    isEditing: state.isEditing,
                  ),
                  const SizedBox(height: kGap32,),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}