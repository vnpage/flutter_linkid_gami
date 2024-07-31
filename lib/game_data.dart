import 'dart:convert';

class GameData {
  String gameName;
  String token;
  String environment;
  GameData({
    required this.gameName,
    required this.token,
    required this.environment,
  });

  GameData copyWith({
    String? gameName,
    String? token,
    String? environment,
  }) {
    return GameData(
      gameName: gameName ?? this.gameName,
      token: token ?? this.token,
      environment: environment ?? this.environment,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'gameName': gameName,
      'token': token,
      'environment': environment,
    };
  }

  factory GameData.fromMap(Map<String, dynamic> map) {
    return GameData(
      gameName: map['gameName'] ?? '',
      token: map['token'] ?? '',
      environment: map['environment'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GameData.fromJson(String source) => GameData.fromMap(json.decode(source));

  @override
  String toString() => 'GameData(gameName: $gameName, token: $token, environment: $environment)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GameData && other.gameName == gameName && other.token == token && other.environment == environment;
  }

  @override
  int get hashCode => gameName.hashCode ^ token.hashCode ^ environment.hashCode;
}
