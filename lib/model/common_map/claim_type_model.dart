class Claim {
  final String id;
  final String value;

  Claim({
    required this.id,
    required this.value,
  });

  // Factory constructor to create a Claim from a map
  factory Claim.fromMap(Map<String, dynamic> map) {
    return Claim(
      id: map['id'] ?? '',
      value: map['value'] ?? '',
    );
  }

  // Method to convert a Claim to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'value': value,
    };
  }

  // Factory constructor to create a Claim from JSON
  factory Claim.fromJson(Map<String, dynamic> json) {
    return Claim(
      id: json['id'] ?? '',
      value: json['value'] ?? '',
    );
  }

  // Method to convert a Claim to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
    };
  }
}
