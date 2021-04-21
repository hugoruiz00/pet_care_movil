class UserProfile {
  final int id;
  final String name;
  final String lastName;
  final String phone;
  final String address;
  final int user;
  final String email;

  UserProfile({this.id, this.name, this.lastName, this.phone, this.address, this.user, this.email});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      lastName: json['lastName'],
      phone: json['phone'],
      address: json['address'],
      user: json['user'],
      email: json['email'],
    );
  }
}