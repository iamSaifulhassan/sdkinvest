import 'package:equatable/equatable.dart';

/// One question-and-answer pair on the FAQ screen.
class FaqItem extends Equatable {
  const FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  List<Object?> get props => [question, answer];
}
