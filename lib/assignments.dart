class Assignments {
  final String type;
  final String title;
  final String cDate;
  final String dueDate;
  final String details;

  Assignments({
    required this.type,
    required this.title,
    required this.cDate,
    required this.dueDate,
    required this.details,
  });
}

List<Assignments> assignmentList = [
  Assignments(
    type: 'assignment',
    title: 'Introduction To Flutter ',
    cDate: 'August 26, 2025',
    dueDate: 'September 4, 2025',
    details: 'Presentations will be done Friday (September 5, 2025). Be prepared to do your presentations.',
  ),
  Assignments(
    type: 'assignment',
    title: 'group work',
    cDate: 'August 18, 2025 ',
    dueDate: 'August 26, 2025', 
    details: 'You are required to create a Firebase CRUD application that students can use to keep track of assignments and important dates. Each student should be able to register and login to the ap. They should be able to view their important information, edit them and delete them.',
    ),
];
