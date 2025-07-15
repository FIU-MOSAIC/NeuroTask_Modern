import 'package:get/get.dart';

class CardModel {
  final int id;
  final String value;
  final RxBool isFlipped;
  final RxBool isMatched;

  CardModel({
    required this.id,
    required this.value,
    bool isFlipped = false,
    bool isMatched = false,
  })  : isFlipped = isFlipped.obs,
        isMatched = isMatched.obs;

  void flip() {
    isFlipped.value = !isFlipped.value;
  }

  void markAsMatched() {
    isMatched.value = true;
  }

  @override
  String toString() {
    return 'CardModel(id: $id, value: $value, isFlipped: $isFlipped, isMatched: $isMatched)';
  }
}