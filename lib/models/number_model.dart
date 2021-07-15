class NumberModel {
  int numberIndex;
  int numberValue;
  int color;
  bool isTouched;
  bool isRotate;
  NumberModel({
    required this.numberIndex,
    required this.numberValue,
    required this.color,
    required this.isTouched,
    required this.isRotate,
  });

  NumberModel copyWith({
    int? numberIndex,
    int? numberValue,
    int? color,
    bool? isTouched,
    bool? isRotate,
  }) {
    return NumberModel(
      numberIndex: numberIndex ?? this.numberIndex,
      numberValue: numberValue ?? this.numberValue,
      color: color ?? this.color,
      isTouched: isTouched ?? this.isTouched,
      isRotate: isRotate ?? this.isRotate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'numberIndex': numberIndex,
      'numberValue': numberValue,
      'color': color,
      'isTouched': isTouched,
      'isRotate': isRotate,
    };
  }

  @override
  String toString() {
    return 'NumberModel(numberIndex: $numberIndex, numberValue: $numberValue, color: $color, isTouched: $isTouched, isRotate: $isRotate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NumberModel &&
        other.numberIndex == numberIndex &&
        other.numberValue == numberValue &&
        other.color == color &&
        other.isTouched == isTouched &&
        other.isRotate == isRotate;
  }

  @override
  int get hashCode {
    return numberIndex.hashCode ^
        numberValue.hashCode ^
        color.hashCode ^
        isTouched.hashCode ^
        isRotate.hashCode;
  }
}
