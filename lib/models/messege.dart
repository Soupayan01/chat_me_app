class Messege {
  Messege({
    required this.msg,
    required this.read,
    required this.toId,
    required this.type,
    required this.fromId,
    required this.sent,
  });
  late final String msg;
  late final String read;
  late final String toId;
  late final Type type;
  late final String fromId;
  late final String sent;

  Messege.fromJson(Map<String, dynamic> json){
    msg = json['msg'].toString();
    read = json['read'].toString();
    toId = json['told'].toString();
    type = json['type'].toString()==Type.image.name?Type.image:Type.text;
    fromId = json['fromId'].toString();
    sent = json['sent'].toString();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['msg'] = msg;
    _data['read'] = read;
    _data['told'] = toId;
    _data['type'] = type.name;
    _data['fromId'] = fromId;
    _data['sent'] = sent;
    return _data;
  }
}
enum Type {text,image}