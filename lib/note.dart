final String dbNote = 'note.db';
final String tableNote = 'tb_note';
final String columnId = '_id';
final String columnContent = 'content';
final String columnCreateTime = 'create_time';
final String columnUpdateTime = 'update_time';

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
