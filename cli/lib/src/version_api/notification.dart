class Notification {
  final String id;
  final String message;

  Notification({required this.id, required this.message});

  static Notification fromJson(Map<String, dynamic> json) {
    return Notification(id: json['id'], message: json['message']);
  }
}
