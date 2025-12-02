/// This enum represents the status of a note, either 'to-do' or 'done'.
enum NoteStatusEnum {
  todo,
  done;
  
  static NoteStatusEnum fromString(String status) {
    return .values.firstWhere(
      (e) => e.name == status,
      orElse: () => .todo,
    );
  }
}