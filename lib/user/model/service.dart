
// Model of Services.json
class Service {
  final int id;
  final String title;

  Service({required this.id, required this.title});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      title: json['title'],
    );
  }
}
