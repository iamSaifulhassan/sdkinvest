import '../models/legal/legal_document.dart';

/// Terms & Conditions, mirroring sdkinvesting.com/terms. Content only —
/// `LegalDocumentPage` renders it, the same as [kDisclaimerDocument].
///
/// No effective date is published for this document, so the date chip is
/// left empty rather than invented.
const LegalDocument kTermsDocument = LegalDocument(
  title: 'Terms & Conditions',
  subtitle: 'Rules and regulations for using SDK Intelligent Investing.',
  effectiveDate: '',
  sections: [
    LegalSection(
      number: 1,
      heading: 'Acceptance of Terms',
      blocks: [
        LegalBlock.paragraph(
          'By accessing and using this service, you accept and agree to be '
          'bound by the terms and provision of this agreement.',
        ),
      ],
    ),
    LegalSection(
      number: 2,
      heading: 'Educational Purposes Only',
      blocks: [
        LegalBlock.paragraph(
          'All content, including the SDK Score, is for educational and '
          'research purposes only. We do not provide personalized financial '
          'advice.',
        ),
      ],
    ),
    LegalSection(
      number: 3,
      heading: 'User Conduct',
      blocks: [
        LegalBlock.paragraph(
          'You agree to use the service only for lawful purposes and in a way '
          "that does not infringe the rights of, restrict or inhibit anyone "
          "else's use and enjoyment of the website.",
        ),
      ],
    ),
  ],
);
