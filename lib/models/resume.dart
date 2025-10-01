class Resume {
  final String name;
  final List<String> skills;
  final List<Map<String, dynamic>> projects;

  Resume({required this.name, required this.skills, required this.projects});

  factory Resume.fromJson(Map<String, dynamic> json) {
    return Resume(
      name: json['name'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      projects: List<Map<String, dynamic>>.from(json['projects'] ?? []),
    );
  }
}
