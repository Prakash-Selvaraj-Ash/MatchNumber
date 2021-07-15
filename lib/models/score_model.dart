import 'dart:convert';

class ScoreModel {
  String name;
  int score;
  ScoreModel({
    required this.name,
    required this.score,
  });

  ScoreModel copyWith({
    String? name,
    int? score,
  }) {
    return ScoreModel(
      name: name ?? this.name,
      score: score ?? this.score,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'score': score,
    };
  }

  factory ScoreModel.fromMap(Map<String, dynamic> map) {
    return ScoreModel(
      name: map['name'].toString(),
      score: int.parse(map['score'].toString()),
    );
  }

  String toJson() => json.encode(toMap());

  factory ScoreModel.fromJson(String source) =>
      ScoreModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ScoreModel(name: $name, score: $score)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ScoreModel && other.name == name && other.score == score;
  }

  @override
  int get hashCode => name.hashCode ^ score.hashCode;
}
