import 'package:flutter_note/util/db_helper.dart';

class Note {
  int id;
  String content;
  int createTime;
  int updateTime;

  Note();

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnContent: content,
      columnCreateTime: createTime,
      columnUpdateTime: updateTime
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Note.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    content = map[columnContent];
    createTime = map[columnCreateTime];
    updateTime = map[columnUpdateTime];
  }
}
