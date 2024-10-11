class FeedbackModel {
  String firstName;
  String lastName;
  int id;
  int parentId;
  int childId;
  String subject;
  String feedback;
  DateTime createdAt;
  DateTime updatedAt;
  String admissionNo;

  FeedbackModel({
    required this.firstName,
    required this.lastName,
    required this.id,
    required this.parentId,
    required this.childId,
    required this.subject,
    required this.feedback,
    required this.createdAt,
    required this.updatedAt,
    required this.admissionNo,
  });

  // Factory constructor to create a Feedback object from JSON
  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      firstName: json['first_name'],
      lastName: json['last_name'],
      id: json['id'],
      parentId: json['parent_id'],
      childId: json['child_id'],
      subject: json['subject'],
      feedback: json['feedback'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      admissionNo: json['admission_no'],
    );
  }

  // Method to convert a Feedback object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'id': id,
      'parent_id': parentId,
      'child_id': childId,
      'subject': subject,
      'feedback': feedback,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'admission_no': admissionNo,
    };
  }
}
