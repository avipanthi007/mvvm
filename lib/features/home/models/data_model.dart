import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class TodoModel {
  String title;
  String description;
  bool disableText;
  TodoModel({
    required this.title,
    required this.description,
    required this.disableText,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'disableText': disableText,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      title: map['title'] as String,
      description: map['description'] as String,
      disableText: map['disableText'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoModel.fromJson(String source) =>
      TodoModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
