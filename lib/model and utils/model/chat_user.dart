class ChatUser {
  ChatUser({
    required this.image,
    required this.status,
    required this.username,
    required this.createdAt,
    required this.isOnline,
    required this.id,
    required this.lastActive,
    required this.email,
    required this.pushToken,
    required this.bloodType,
    required this.location,
    required this.contact,
  });
  late String image;
  late String status;
  late String bloodType;
  late String username;
  late String createdAt;
  late bool isOnline;
  late String id;
  late String lastActive;
  late String email;
  late String pushToken;
  late String location;
  late String contact;

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    status = json['status'] ?? '';
    username = json['username'] ?? '';
    createdAt = json['created_at'] ?? '';
    isOnline = json['is_online'] ?? '';
    id = json['uid'] ?? '';
    lastActive = json['last_active'] ?? '';
    email = json['email'] ?? '';
    pushToken = json['push_token'] ?? '';
    bloodType = json['bloodType'] ?? '';
    location = json['location'] ?? '';
    contact = json['contact'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['status'] = status;
    data['username'] = username;
    data['created_at'] = createdAt;
    data['is_online'] = isOnline;
    data['uid'] = id;
    data['last_active'] = lastActive;
    data['email'] = email;
    data['push_token'] = pushToken;
    data['bloodType'] = bloodType;
    data['location'] = location;
    data['contact'] = contact;
    return data;
  }
}
