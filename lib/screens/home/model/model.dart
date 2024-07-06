class TaskModel {
  String task;
  String id;
  String description;
  String docid;
  String image_url;
  bool status;

  TaskModel(
      {required this.task,
      required this.status,
      required this.id,
      required this.docid,
      required this.description,
      required this.image_url});
}
