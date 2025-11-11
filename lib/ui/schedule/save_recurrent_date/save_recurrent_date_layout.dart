
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_cubit.dart';
import 'package:jampa_flutter/bloc/notes/create/create_note_form_helpers.dart';
import 'package:jampa_flutter/bloc/schedule/save_recurrent_date/save_recurrent_date_bloc.dart';
import 'package:jampa_flutter/ui/alarm/widgets/save_alarm_list_dialog.dart';
import 'package:jampa_flutter/ui/schedule/widgets/inputs/recurrence_interval_input.dart';
import 'package:jampa_flutter/ui/schedule/widgets/inputs/recurrence_type_selector.dart';
import 'package:jampa_flutter/ui/schedule/widgets/inputs/recurrence_weekdays_multiselector.dart';
import 'package:jampa_flutter/ui/widgets/headers.dart';
import 'package:jampa_flutter/ui/widgets/inputs/datetime_input_field.dart';
import 'package:jampa_flutter/ui/widgets/cancel_button.dart';
import 'package:jampa_flutter/ui/widgets/snackbar.dart';
import 'package:jampa_flutter/utils/extensions/app_context_extension.dart';
import 'package:jampa_flutter/utils/forms/month_day_validator.dart';
import 'package:jampa_flutter/utils/forms/positive_number_validator.dart';

import '../../../utils/constants/styles/sizes.dart';
import '../../../utils/enums/recurrence_type_enum.dart';
import '../../widgets/error_text.dart';


class SaveRecurrentDateLayout extends StatelessWidget {
  const SaveRecurrentDateLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaveRecurrentDateBloc, SaveRecurrentDateState>(
      listener: (context, state){
        if(state.hasSubmitted == true){
          if(state.initialRecurrentDateFormElementIndex != null){
            if(state.isSavingPersistentDate ?? false){
              // Database updated successfully
              SnackBarX.showSuccess(context, 
                  context.strings.edit_recurrent_date_success_feedback);
            }else{
              //Edit the existing single date in the CreateNoteCubit state
              context.read<CreateNoteCubit>().onUpdateRecurrenceElement(
                state.initialRecurrentDateFormElementIndex!,
                state.newRecurrentDateFormElements,
              );
            }
          }else{
            if(state.isSavingPersistentDate ?? false){
              // Successfully created and saved to database
              SnackBarX.showSuccess(context,
                  context.strings.create_recurrent_date_success_feedback);
            }else{
              //Add the created single date to the CreateNoteCubit state
              context.read<CreateNoteCubit>()
                  .onAddRecurrenceElement(state.newRecurrentDateFormElements);
            }
          }
          // Navigate back
          context.pop();
          context.read<SaveRecurrentDateBloc>().add(ResetState());
        }else{
          SnackBarX.showError(context, context.strings.generic_error_message);
        }
      },
      listenWhen: (previous, current){
        return (previous.hasSubmitted == false && current.hasSubmitted == true);
      },
      builder: (context, state){
        return SingleChildScrollView(
          child: Column(
            children: [
              Headers.noActionHeader(
                context: context,
                title: context.strings.create_recurrence_title,
              ),
              const SizedBox(height: kGap16),
              RecurrenceTypeSelector(
                value: state.newRecurrentDateFormElements.selectedRecurrenceType,
                onChanged: (value) => context.read<SaveRecurrentDateBloc>().add(
                  SelectRecurrenceType(recurrenceType: value)
                )
              ),
              const SizedBox(height: kGap16),
              Builder(
                builder: (context){
                  if(state.newRecurrentDateFormElements.selectedRecurrenceType.isIntervalDays) {
                    // Show interval input for days
                    return RecurrenceIntervalTextField(
                        value: state.newRecurrentDateFormElements
                            .selectedRecurrenceDaysInterval?.toString() ?? '',
                        // isValid: ,
                        validator: state.intervalDaysValidator,
                        onChanged: (value){
                          context.read<SaveRecurrentDateBloc>().add(
                            ChangeRecurrenceDayInterval(interval: value)
                          );
                        },
                        hintText: context.strings.create_recurrent_date_interval_field_hint,
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
                    // Show interval input for years
                    return RecurrenceIntervalTextField(
                        value: state.newRecurrentDateFormElements
                            .selectedRecurrenceYearsInterval?.toString() ?? '',
                        validator: state.intervalYearsValidator,
                        onChanged: (value){
                          context.read<SaveRecurrentDateBloc>().add(
                              ChangeRecurrenceYearInterval(interval: value)
                          );
                        },
                        hintText: context.strings.create_recurrent_date_interval_field_hint,
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
                    // Show month day input
                    return RecurrenceIntervalTextField(
                        value: state.newRecurrentDateFormElements
                            .selectedRecurrenceMonthDate?.toString() ?? '',
                        validator: state.monthDateValidator,
                        onChanged: (value){
                          context.read<SaveRecurrentDateBloc>().add(
                              ChangeRecurrenceMonthDate(day: value)
                          );
                        },
                        hintText: context.strings.create_recurrent_date_month_day_field_hint,
                        errorWidget: state.monthDateValidator.isNotValid ? ErrorText(
                            errorText: (){
                              if (state.monthDateValidator.displayError?.isInvalidValue ?? false) {
                                return context.strings.create_recurrent_date_invalid_month_day;
                              }
                              return context.strings.generic_error_message;
                            }()
                        ) : null
                    );
                  }else {
                    // Show weekday multi selector
                    return RecurrenceWeekdaysMultiSelector(
                        selectedWeekdays: state.newRecurrentDateFormElements.selectedRecurrenceWeekdays ?? [],
                        onWeekdaySelected: (values) => context.read<SaveRecurrentDateBloc>().add(
                          ChangeRecurrenceWeekDays(weekDays: values)
                        ),
                        validator: (values){
                          if(values == null || values.isEmpty){
                            return context.strings.create_recurrent_date_no_weekday_selected;
                          }
                          return null;
                        }
                    );
                  }
                }
              ),
              const SizedBox(height: kGap16),
              DatetimeInputField(
                label: context.strings.create_start_date_field_title,
                initialDateTime: state.newRecurrentDateFormElements.selectedStartDateTime,
                onDateTimeSelected: (dateTime) {
                  context.read<SaveRecurrentDateBloc>().add(
                      SelectStartDateTime(dateTime: dateTime)
                  );
                },
              ),
              const SizedBox(height: kGap16),
              DatetimeInputField(
                label: context.strings.create_end_date_field_title,
                initialDateTime: state.newRecurrentDateFormElements.selectedEndDateTime,
                errorText: state.isValidEndDate ? null : context.strings.create_date_timeline_error,
                onDateTimeSelected: (dateTime) {
                  context.read<SaveRecurrentDateBloc>().add(
                      SelectEndDateTime(dateTime: dateTime)
                  );
                },
              ),
              const SizedBox(height: kGap16),
              DatetimeInputField(
                label: context.strings.create_recurrent_date_recurrence_end_field_title,
                initialDateTime: state.newRecurrentDateFormElements.selectedRecurrenceEndDate,
                errorText: state.isValidEndRecurrenceDate ? null : context.strings.create_recurrent_date_recurrence_end_error,
                onDateTimeSelected: (dateTime) {
                  context.read<SaveRecurrentDateBloc>().add(
                      SelectRecurrenceEndDateTime(dateTime: dateTime)
                  );
                },
              ),
              const SizedBox(height: kGap16),
              AlarmListButton(
                isSavingPersistentData: state.scheduleId != null,
                blocContext: context,
                elements: state.newRecurrentDateFormElements.alarmsForRecurrence,
              ),
              const SizedBox(height: kGap32,),
              SubmitSingleDateButton(),
              const SizedBox(height: kGap16,),
              CancelButton(
                onPressed: () {
                  context.read<SaveRecurrentDateBloc>().add(ResetState());
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class AlarmListButton extends StatelessWidget {
  const AlarmListButton({super.key,
    required this.blocContext,
    required this.elements,
    this.isSavingPersistentData = false
  });

  final BuildContext blocContext;
  final List elements;
  final bool isSavingPersistentData;

  @override
  Widget build(BuildContext listContext) {
    return SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        style: ButtonStyle(
            shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                )
            )
        ),
        onPressed: () {
          showDialog(
              context: listContext,
              builder: (dialogContext) {
                return SaveAlarmListDialog(
                  isForRecurrentDate: true,
                  isSavingPersistentData: isSavingPersistentData,
                  listElements: elements as List<AlarmFormElements>,
                  onDateDeleted: (value) {
                    blocContext.read<SaveRecurrentDateBloc>()
                        .add(RemoveAlarmForRecurrence(index: value));
                    },
                );
              }
          );
        },
        child: Text(listContext.strings.create_date_alarm_count(elements.length)
        ),
      ),
    );
  }
}

class SubmitSingleDateButton extends StatelessWidget {
  const SubmitSingleDateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SaveRecurrentDateBloc, SaveRecurrentDateState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.isValidFormValues
              ? () => context.read<SaveRecurrentDateBloc>().add(OnSubmit())
              : null,
          child: Text(state.initialRecurrentDateFormElementIndex != null
              ? context.strings.edit : context.strings.create),
        );
      },
    );
  }
}