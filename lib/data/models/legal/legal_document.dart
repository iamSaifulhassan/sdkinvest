import 'package:equatable/equatable.dart';

/// The kind of content a [LegalBlock] holds. Kept as an enum + one block
/// class (rather than a subclass per kind) so the whole document stays a
/// plain `const` literal in `legal_content.dart`.
enum LegalBlockType {
  /// A run of prose.
  paragraph,

  /// An unordered list.
  bullets,

  /// An ordered list — rendered "1." "2." … in document order.
  numbered,
}

/// One piece of a [LegalSection]: either a paragraph or a list.
class LegalBlock extends Equatable {
  const LegalBlock._({
    required this.type,
    this.text = '',
    this.items = const [],
  });

  const LegalBlock.paragraph(String text)
    : this._(type: LegalBlockType.paragraph, text: text);

  const LegalBlock.bullets(List<String> items)
    : this._(type: LegalBlockType.bullets, items: items);

  const LegalBlock.numbered(List<String> items)
    : this._(type: LegalBlockType.numbered, items: items);

  final LegalBlockType type;

  /// Set for [LegalBlockType.paragraph]; empty otherwise.
  final String text;

  /// Set for [LegalBlockType.bullets]/[LegalBlockType.numbered]; empty otherwise.
  final List<String> items;

  @override
  List<Object?> get props => [type, text, items];
}

/// A numbered clause of a legal document ("1. Educational and Informational
/// Purposes Only"). [number] is null for the unnumbered preamble.
class LegalSection extends Equatable {
  const LegalSection({
    this.number,
    required this.heading,
    required this.blocks,
  });

  /// Unnumbered lead-in shown above clause 1.
  const LegalSection.preamble(List<LegalBlock> blocks)
    : this(heading: '', blocks: blocks);

  final int? number;
  final String heading;
  final List<LegalBlock> blocks;

  @override
  List<Object?> get props => [number, heading, blocks];
}

/// A long-form policy page — Disclaimer, Terms, Privacy Policy. Rendered by
/// `LegalDocumentPage`, which is the only screen these need: each document
/// is data, not its own widget tree.
class LegalDocument extends Equatable {
  const LegalDocument({
    required this.title,
    required this.subtitle,
    required this.effectiveDate,
    required this.sections,
    this.footer,
  });

  /// App-bar title, e.g. 'Disclaimer'.
  final String title;

  /// Full document name shown at the top of the body.
  final String subtitle;

  /// e.g. 'August 17, 2026'. Empty hides the effective-date chip.
  final String effectiveDate;

  final List<LegalSection> sections;

  /// Copyright / closing line under the last section.
  final String? footer;

  @override
  List<Object?> get props => [title, subtitle, effectiveDate, sections, footer];
}
