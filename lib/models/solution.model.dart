import 'package:help_desck_app/models/solicitation.model.dart';
import 'package:help_desck_app/models/user.dart';

class SolutionModel{
  final int solution_id;
  final String description;
  final SolicitationModel solicitation;
  final UserModel user;

  const SolutionModel({
    required this.solution_id,
    required this.description,
    required this.solicitation,
    required this.user,
  });

  factory SolutionModel.fromJson(Map<dynamic, dynamic> json) {
    return SolutionModel(
      solution_id: json['solution_id'],
      description: json['description'],
      solicitation: json['solicitation'],
      user: json['user'],
    );
  }

  Map<String, dynamic> toJson() => {
    'solution_id': solution_id,
    'description': description,
    'solicitation': solicitation,
    'user': user,
  };
}

