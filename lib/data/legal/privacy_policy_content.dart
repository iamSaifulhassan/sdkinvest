import '../models/legal/legal_document.dart';

/// Privacy Policy, mirroring sdkinvesting.com/privacy-policy. Content only —
/// `LegalDocumentPage` renders it, the same as [kDisclaimerDocument].
///
/// No effective date is published for this document, so the date chip is
/// left empty rather than invented.
const LegalDocument kPrivacyPolicyDocument = LegalDocument(
  title: 'Privacy Policy',
  subtitle: 'How we handle and protect your data.',
  effectiveDate: '',
  sections: [
    LegalSection(
      number: 1,
      heading: 'Information Collection',
      blocks: [
        LegalBlock.paragraph(
          'We collect information you provide directly to us when you create '
          'an account, update your profile, use the interactive features of '
          'the service, or communicate with us.',
        ),
      ],
    ),
    LegalSection(
      number: 2,
      heading: 'Use of Information',
      blocks: [
        LegalBlock.paragraph(
          'We use the information we collect to provide, maintain, and '
          'improve our services. We may also use the information to send you '
          'technical notices, updates, and support messages.',
        ),
      ],
    ),
    LegalSection(
      number: 3,
      heading: 'Data Security',
      blocks: [
        LegalBlock.paragraph(
          'We take reasonable measures to help protect information about you '
          'from loss, theft, misuse and unauthorized access, disclosure, '
          'alteration and destruction.',
        ),
      ],
    ),
  ],
);
