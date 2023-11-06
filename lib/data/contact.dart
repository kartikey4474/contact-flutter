class Contact {
  final String name;
  final String phone;
  final String email;
  final String address;

  Contact(
      {this.name = '', this.phone = '', this.email = '', this.address = ''});

  Contact copyWith({
    String? name,
    String? phone,
    String? email,
    String? address,
  }) {
    return Contact(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
    );
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
    };
  }

  @override
  String toString() {
    return '''Contact: {
      name: $name\n
      phone: $phone\n
      email: $email\n
      address: $address\n
    }''';
  }
}
