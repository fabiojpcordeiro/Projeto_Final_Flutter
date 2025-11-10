class Candidate {
  final int id;
  final String name;
  final String email;
  final String phone;
  final int stateId;
  final int cityId;
  final String? bio;
  final String? profilePhoto;
  final String? birthdate;
  final String? resume;

  Candidate({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.stateId,
    required this.cityId,
    this.bio,
    this.profilePhoto,
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
      cityId: json['city_id'],
      bio: json['bio'],
      profilePhoto: json['profile_photo'],
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
      'profile_photo': profilePhoto,
      'birthdate': birthdate,
      'resume': resume,
    };
  }

}
