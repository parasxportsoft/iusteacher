import 'dart:convert';

import 'package:eschool_teacher/utils/uiUtils.dart';

class DynamicFieldModel {
  String title;
  String value;
  bool isFile;
  bool isCheckbox;
  bool isTextArea;
  List<String> checkboxList;
  DynamicFieldModel({
    required this.title,
    required this.value,
    this.isFile = false,
    this.isCheckbox = false,
    this.isTextArea = false,
    this.checkboxList = const [],
  });

  String get titleDisplay => title.replaceAll("_", " ").toTitleCase();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'value': value,
      'isFile': isFile,
      'isCheckbox': isCheckbox,
      'isTextArea': isTextArea,
      'checkboxList': checkboxList,
    };
  }

  factory DynamicFieldModel.fromMap(Map<String, dynamic> map) {
    return DynamicFieldModel(
        title: map['title'] as String,
        value: map['value'] as String,
        isFile: map['isFile'] as bool,
        isCheckbox: map['isCheckbox'] as bool,
        isTextArea: map['isTextArea'] as bool,
        checkboxList: List<String>.from(
          (map['checkboxList'] as List<String>),
        ));
  }

  static List<DynamicFieldModel> generateDynamicFieldsFromAPIValues(
      {required Map<String, dynamic> dynamicField}) {
    List<DynamicFieldModel> tempDynamicFields = [];
    for (var key in dynamicField.keys) {
      if (dynamicField[key] is Map) {
        tempDynamicFields.add(DynamicFieldModel(
            title: key,
            value: (dynamicField[key] as Map<String, dynamic>)
                .keys
                .toList()
                .toString()
                .commaSeperatedListToString(),
            checkboxList:
                (dynamicField[key] as Map<String, dynamic>).keys.toList(),
            isCheckbox: true));
      } else if (dynamicField[key].toString().isFile()) {
        tempDynamicFields.add(DynamicFieldModel(
            title: key, value: dynamicField[key].toString(), isFile: true));
      } else if (dynamicField[key].toString().length > 50) {
        tempDynamicFields.add(DynamicFieldModel(
            title: key, value: dynamicField[key].toString(), isTextArea: true));
      } else {
        tempDynamicFields.add(
            DynamicFieldModel(title: key, value: dynamicField[key].toString()));
      }
    }
    return tempDynamicFields;
  }

  String toJson() => json.encode(toMap());

  factory DynamicFieldModel.fromJson(String source) =>
      DynamicFieldModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
