import 'package:help_desck_app/models/sector.model.dart';
import 'package:help_desck_app/models/user.dart';

class SolicitationModel{
   int? solicitation_id;
   String? code;
   UserModel? user_requested;
   bool? was_solved;
   String? description;
   String? status;
   List<dynamic>? solutions;
   String? created_at;
   String? updated_at;
   String? closed_at;
   SectorModel? sector;

  SolicitationModel({
     this.solicitation_id,
     this.code,
     this.user_requested,
     this.was_solved,
     this.description,
     this.status,
     this.solutions,
      this.sector,
     this.created_at,
     this.updated_at,
     this.closed_at,
  });

  SolicitationModel.fromJson(Map<dynamic, dynamic> json)
      : solicitation_id = json["solicitation_id"],
        code = json["code"],
        user_requested = UserModel.fromJson(json["user_requested"]),
        was_solved = json["was_solved"],
        description = json["description"],
        status = json["status"],
        solutions = json["solutions"],
        created_at = json["created_at"],
        updated_at = json["updated_at"],
        sector = SectorModel.fromJson(json["sector"]),
        closed_at = json["closed_at"];

   Map<String, dynamic> toJson() => {
     'solicitation_id': solicitation_id,
   };

}

class ResponseGetSolicitations{
  final List<dynamic> solicitations;
  final int totalSize;

  ResponseGetSolicitations(
      {required this.solicitations, required this.totalSize});

  factory ResponseGetSolicitations.fromJson(Map<dynamic, dynamic> json) {
    return ResponseGetSolicitations(
        solicitations: json["solicitations"],
        totalSize: json["totalSize"]
    );
  }
}

class SolicitationCreateModel{
  SectorModel? sector;
  String? description;

  Map toJson() {
    Map<String, dynamic> sector = this.sector!.toJson();
    Map<String, dynamic> service = {
      'description': description.toString(),
      'sector': sector
    };
    return service;
  }
}

class SolutionCreateModel{
  SolicitationModel? solicitation;
  String? description;

  Map toJson() {
    Map<String, dynamic> Idsolicitation = solicitation!.toJson();
    Map<String, dynamic> solution = {
      'description': description.toString(),
      'solicitation': Idsolicitation
    };
    return solution;
  }
}


