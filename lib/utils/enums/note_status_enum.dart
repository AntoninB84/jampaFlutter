enum NoteStatusEnum {
  todo,
  done;
  
  static NoteStatusEnum fromString(String status) {
    return NoteStatusEnum.values.firstWhere(
      (e) => e.name == status,
      orElse: () => NoteStatusEnum.todo,
    );
  }
}