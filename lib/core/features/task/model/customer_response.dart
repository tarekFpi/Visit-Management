class Customer {
  int id;
  String name;
  String phone;
  String email;
  String address;
  String lastVisitDate;
  String visitStatus;
  String notes;
  String syncStatus;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.lastVisitDate,
    required this.visitStatus,
    required this.notes,
    required this.syncStatus,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json['id'],
    name: json['name'],
    phone: json['phone'],
    email: json['email'],
    address: json['address'],
    lastVisitDate: json['lastVisitDate'],
    visitStatus: json['visitStatus'],
    notes: json['notes'] ?? "",
    syncStatus: "synced",
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "phone": phone,
    "email": email,
    "address": address,
    "lastVisitDate": lastVisitDate,
    "visitStatus": visitStatus,
    "notes": notes,
    "syncStatus": syncStatus,
  };
}