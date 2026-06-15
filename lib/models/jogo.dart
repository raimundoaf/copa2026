class Jogo {
  int? id;
  String timeCasa;
  String timeVisitante;
  String data;
  String estadio;
  int? golsCasa;
  int? golsVisitante;

  Jogo({
    this.id,
    required this.timeCasa,
    required this.timeVisitante,
    required this.data,
    required this.estadio,
    this.golsCasa,
    this.golsVisitante,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'timeCasa': timeCasa,
      'timeVisitante': timeVisitante,
      'data': data,
      'estadio': estadio,
      'golsCasa': golsCasa,
      'golsVisitante': golsVisitante,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory Jogo.fromMap(Map<String, dynamic> map) {
    return Jogo(
      id: map['id'],
      timeCasa: map['timeCasa'],
      timeVisitante: map['timeVisitante'],
      data: map['data'],
      estadio: map['estadio'],
      golsCasa: map['golsCasa'],
      golsVisitante: map['golsVisitante'],
    );
  }
}