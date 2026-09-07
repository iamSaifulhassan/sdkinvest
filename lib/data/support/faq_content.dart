import '../models/support/faq_item.dart';

/// FAQ entries, mirroring sdkinvesting.com/faq. Content only — `FaqPage`
/// renders it, the same way the legal documents are data rather than screens.
const List<FaqItem> kFaqItems = [
  FaqItem(
    question: 'What is the SDK Score?',
    answer:
        'The SDK Score evaluates multiple fundamental and technical metrics '
        'to generate a single composite score from 0 to 100.',
  ),
  FaqItem(
    question: 'Is SDK Investing financial advice?',
    answer:
        'No, SDK Investing is an educational and research-support platform. '
        'It does not provide personalized financial advice.',
  ),
  FaqItem(
    question: 'How often are scores updated?',
    answer:
        'Scores are updated automatically on a daily basis after market close.',
  ),
  FaqItem(
    question: 'Can a Strong Buy stock still decline?',
    answer:
        'Yes. The market is unpredictable and no scoring system guarantees '
        'performance. Always use proper risk management.',
  ),
  FaqItem(
    question: 'Why does valuation matter?',
    answer:
        "Valuation ensures you are not overpaying for a company's earnings "
        'or assets.',
  ),
  FaqItem(
    question: 'Why does momentum matter?',
    answer:
        'Momentum identifies trends and institutional buying pressure, '
        'confirming the fundamental thesis.',
  ),
];
