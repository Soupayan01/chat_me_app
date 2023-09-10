class Chatuser{


  Chatuser({
    required this.image,
    required this.lastActive,
    required this.isOnline,
    required this.id,
    required this.startAt,
    required this.pushToken,
    required this.Name,
    required this.About,
    required this.Email,
  });
  late  String image;
  late  String lastActive;
  late  bool isOnline;
  late  String id;
  late  String startAt;
  late  String pushToken;
  late  String Name;
  late  String About;
  late  String Email;
  Chatuser.fromJson(Map<String, dynamic> json){
    image = json['image'] ?? '';
    lastActive = json['last_active'] ?? '';
    isOnline = json['is_online'] ?? '';
    id = json['id'] ?? '';
    startAt = json['start_at'] ?? '';
    pushToken = json['push_token'] ?? '';
    Name = json['Name'] ?? '';
    About = json['About'] ?? '';
    Email = json['Email'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['image'] = image;
    _data['last_active'] = lastActive;
    _data['is_online'] = isOnline;
    _data['id'] = id;
    _data['start_at'] = startAt;
    _data['push_token'] = pushToken;
    _data['Name'] = Name;
    _data['About'] = About;
    _data['Email'] = Email;
    return _data;
  }
}