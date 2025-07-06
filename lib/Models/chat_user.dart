/// image : "image"
/// name : "Raj"
/// about : "i am happy"
/// push token : "nice"
/// id : "23132160045"
/// is_online : true
/// last_active : "just"
/// email : "raj@gamil.com"
/// Created_at : "20june"

class ChatUser {



  ChatUser({
      required String? image,
    required String? name,
    required String? about,
    required String? pushtoken,
    required String? id,
    required bool? isOnline,
    required String? lastActive,
    required String? email,
    required String? createdAt,}){
    _image = image;
    _name = name;
    _about = about;
    _pushtoken = pushtoken;
    _id = id;
    _isOnline = isOnline;
    _lastActive = lastActive;
    _email = email;
    _createdAt = createdAt;
}

  ChatUser.fromJson(dynamic json) {
    _image = json['image'];
    _name = json['name'];
    _about = json['about'];
    _pushtoken = json['push token'];
    _id = json['id'];
    _isOnline = json['is_online'];
    _lastActive = json['last_active'];
    _email = json['email'];
    _createdAt = json['Created_at'];
  }
  String? _image;
  String? _name;
  String? _about;
  String? _pushtoken;
  String? _id;
  bool? _isOnline;
  String? _lastActive;
  String? _email;
  String? _createdAt;
ChatUser copyWith({  String? image,
  String? name,
  String? about,
  String? pushtoken,
  String? id,
  bool? isOnline,
  String? lastActive,
  String? email,
  String? createdAt,
}) => ChatUser(  image: image ?? _image,
  name: name ?? _name,
  about: about ?? _about,
  pushtoken: pushtoken ?? _pushtoken,
  id: id ?? _id,
  isOnline: isOnline ?? _isOnline,
  lastActive: lastActive ?? _lastActive,
  email: email ?? _email,
  createdAt: createdAt ?? _createdAt,
);

  set name(String? name) => _name = name;
  set about(String? about) => _about = about;
  set image(String? image) => _image = image;


  String? get image => _image;
  String? get name => _name;
  String? get about => _about;
  String? get pushtoken => _pushtoken;
  String? get id => _id;
  bool? get isOnline => _isOnline;
  String? get lastActive => _lastActive;
  String? get email => _email;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image'] = _image;
    map['name'] = _name;
    map['about'] = _about;
    map['push token'] = _pushtoken;
    map['id'] = _id;
    map['is_online'] = _isOnline;
    map['last_active'] = _lastActive;
    map['email'] = _email;
    map['Created_at'] = _createdAt;
    return map;
  }

}