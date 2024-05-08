class UserModel {
  final String fullName;
  final String imageLink;
  final String login;
  final double level;
  final List<SkillModel> skills;
  final List<ProjectModel> projects;
  final DateTime? blackHole;
  final DateTime createdAt;
  final int correctionPoint;

  UserModel(
      {required this.fullName,
      required this.imageLink,
      required this.login,
      required this.createdAt,
      required this.level,
      required this.skills,
      required this.correctionPoint,
        required this.projects,
      this.blackHole});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    double level = 0;
    List<dynamic> cursusUsers = json['cursus_users'];
    List<SkillModel> skills = [];
    DateTime? blackHole;
    for (var cursusUser in cursusUsers) {
      if (cursusUser['cursus']['slug'] == '42cursus') {
        level = cursusUser['level'];
        blackHole = DateTime.tryParse(cursusUser['blackholed_at'] ?? "lol");
        for (var skill in cursusUser['skills']) {
          skills.add(SkillModel.fromJson(skill));
        }
      }
    }

    return UserModel(
        fullName: json['usual_full_name'],
        login: json['login'],
        imageLink: json['image']['link'],
        createdAt: DateTime.parse(json['created_at']),
        level: level,
        projects: (json['projects_users'] as List)
            .map((data) => ProjectModel.fromJson(data))
            .toList(),
        correctionPoint: json['correction_point'],
        blackHole: blackHole,
        skills: skills);
  }
}

class SkillModel {
  final String name;
  final double level;

  SkillModel({required this.name, required this.level});

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(name: json['name'], level: json['level']);
  }
}

class ProjectModel {
  final String name;
  final int mark;
  final DateTime dateTime;
  final String status;
  final int retried;

  ProjectModel(
      {required this.name,
      required this.mark,
      required this.status,
      required this.retried,
      required this.dateTime});

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
        name: json['project']['name'],
        mark: json['final_mark'] ?? 0,
        status: json['status'],
        retried: json['occurrence'],
        dateTime: DateTime.parse(json['updated_at'])
    );
  }
}
