class Message {
  Message({
    required this.told,
    required this.type,
    required this.msg,
    required this.fromld,
    required this.read,
    required this.sent,
  });
  late final String told;
  late final Type type;
  late final String msg;
  late final String fromld;
  late final String read;
  late final String sent;

  Message.fromJson(Map<String, dynamic> json) {
    told = json['told'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    msg = json['msg'].toString();
    fromld = json['fromld'].toString();
    read = json['read'].toString();
    sent = json['sent'].toString();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['told'] = told;
    _data['type'] = type.name;
    _data['msg'] = msg;
    _data['fromld'] = fromld;
    _data['read'] = read;
    _data['sent'] = sent;
    return _data;
  }
}

enum Type { text, image }
