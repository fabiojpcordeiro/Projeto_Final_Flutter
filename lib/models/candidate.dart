import 'dart:typed_data';

class Candidate {
  final int id;
  final String name;
  final String email;
  final String phone;
  final int stateId;
  final String? stateName;
  final int cityId;
  final String? cityName;
  final String? bio;
  final String? profilePhotoUrl;
  final String? birthdate;
  final String? resume;
  Uint8List? photo;

  Candidate({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.stateId,
    required this.cityId,
    this.stateName,
    this.cityName,
    this.bio,
    this.profilePhotoUrl,
    this.birthdate,
    this.resume,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      stateId: json['state_id'],
      stateName: json['state_name'],
      cityId: json['city_id'],
      cityName: json['city_name'],
      bio: json['bio'],
      profilePhotoUrl: json['profile_photo'],
      birthdate: json['birthdate'],
      resume: json['resume'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'state_id': stateId,
      'city_id': cityId,
      'bio': bio,
      'profile_photo': profilePhotoUrl,
      'birthdate': birthdate,
      'resume': resume,
    };
  }
}
