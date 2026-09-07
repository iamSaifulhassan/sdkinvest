import '../models/legal/legal_document.dart';

/// The Investment Disclaimer, mirroring sdkinvesting.com/disclaimer. Content
/// only — `LegalDocumentPage` renders it. Non-ASCII punctuation is written as
/// escapes so the copy survives any editor/encoding round-trip.
const LegalDocument kDisclaimerDocument = LegalDocument(
  title: 'Disclaimer',
  subtitle: 'Investment Disclaimer and User Acknowledgment',
  effectiveDate: 'August 17, 2026',
  footer: '© SDK Investing LLC. All rights reserved.',
  sections: [
    LegalSection.preamble([
      LegalBlock.paragraph(
        'Please read this Investment Disclaimer and User Acknowledgment '
        'carefully before creating an account, subscribing to, or using the '
        'SDK Investing website, mobile application, reports, alerts, scores, '
        'rankings, model signals, educational materials, or related services '
        '(collectively, the “SDK Platform”).',
      ),
      LegalBlock.paragraph(
        'By creating an account, purchasing a subscription, or otherwise '
        'accessing the SDK Platform, you acknowledge that you have read, '
        'understood, and agreed to this Investment Disclaimer and User '
        'Acknowledgment.',
      ),
    ]),
    LegalSection(
      number: 1,
      heading: 'Educational and Informational Purposes Only',
      blocks: [
        LegalBlock.paragraph(
          'SDK Investing provides financial information, market data, '
          'analytical tools, educational materials, proprietary quantitative '
          'scores, classifications, rankings, and model-generated signals for '
          'general educational and informational purposes only.',
        ),
        LegalBlock.paragraph(
          'The information provided through the SDK Platform is not intended '
          'to constitute, and should not be interpreted as, individualized '
          'investment, financial, legal, accounting, or tax advice.',
        ),
        LegalBlock.paragraph(
          'Nothing provided through the SDK Platform constitutes an offer, '
          'solicitation, recommendation, or personalized instruction to '
          'purchase, sell, hold, short, exercise an option on, or otherwise '
          'transact in any security or other financial instrument.',
        ),
      ],
    ),
    LegalSection(
      number: 2,
      heading:
          'SDK Scores and Model Signals Are Not Personalized Investment '
          'Recommendations',
      blocks: [
        LegalBlock.paragraph(
          'SDK Investing uses a proprietary analytical methodology to evaluate '
          'securities based on multiple financial and market factors.',
        ),
        LegalBlock.paragraph(
          'The SDK methodology may include factors such as:',
        ),
        LegalBlock.bullets([
          'Valuation',
          'Growth',
          'Profitability',
          'Momentum',
          'Earnings Quality',
          'Financial Strength',
          'Other financial, fundamental, market, or quantitative information '
              'incorporated into the SDK methodology',
        ]),
        LegalBlock.paragraph(
          'The resulting SDK Score and classifications such as:',
        ),
        LegalBlock.bullets(['Strong Buy', 'Buy', 'Hold', 'Trim', 'Sell']),
        LegalBlock.paragraph(
          'are SDK MODEL SIGNALS generated through the SDK analytical '
          'methodology.',
        ),
        LegalBlock.paragraph(
          'These terms describe the output of the SDK model. They do not '
          'constitute personalized recommendations or instructions to buy, '
          'hold, trim, or sell a security.',
        ),
        LegalBlock.paragraph(
          "An SDK Model Signal is intended to communicate the model's "
          'assessment of the security based upon the information available to '
          'the model at that time.',
        ),
      ],
    ),
    LegalSection(
      number: 3,
      heading: 'SDK Does Not Consider Your Personal Circumstances',
      blocks: [
        LegalBlock.paragraph(
          'SDK Scores, rankings, Top 5 lists, Watchlists, Comparisons, '
          'Portfolio displays, alerts, and Model Signals are not based upon an '
          'assessment of your individual:',
        ),
        LegalBlock.bullets([
          'Financial condition',
          'Net worth',
          'Income',
          'Investment experience',
          'Investment objectives',
          'Risk tolerance',
          'Tax situation',
          'Liquidity requirements',
          'Age',
          'Time horizon',
          'Existing portfolio concentration',
          'Estate-planning considerations',
          'Personal or family circumstances',
        ]),
        LegalBlock.paragraph(
          'A security receiving a favorable SDK Model Signal may be '
          'inappropriate for a particular investor.',
        ),
        LegalBlock.paragraph(
          'Likewise, a security receiving an unfavorable SDK Model Signal may '
          'still be appropriate for another investor depending upon that '
          "investor's individual circumstances.",
        ),
        LegalBlock.paragraph(
          'Users should therefore not interpret an SDK Score or Model Signal '
          'as determining whether a particular investment is suitable for them.',
        ),
      ],
    ),
    LegalSection(
      number: 4,
      heading: 'Portfolio and Watchlist Features',
      blocks: [
        LegalBlock.paragraph(
          'The Portfolio and Watchlist functions are designed to help users '
          'organize, monitor, and analyze securities.',
        ),
        LegalBlock.paragraph(
          "The inclusion of a security in a user's Portfolio or Watchlist does "
          'not create an advisory relationship between SDK Investing and the '
          'user.',
        ),
        LegalBlock.paragraph(
          'Unless SDK Investing expressly states otherwise in a separate '
          'written agreement, the SDK Platform does not provide individualized '
          'portfolio management, discretionary investment management, or '
          'personalized asset-allocation services.',
        ),
        LegalBlock.paragraph(
          'Portfolio information entered by a user may be used to display and '
          'organize SDK analytical information, but the existence of a '
          'Portfolio feature should not be interpreted as an agreement by SDK '
          'Investing to manage, supervise, or recommend transactions for that '
          'portfolio.',
        ),
      ],
    ),
    LegalSection(
      number: 5,
      heading: 'No Investment Advisory, Brokerage, or Fiduciary Relationship',
      blocks: [
        LegalBlock.paragraph(
          'Use of the SDK Platform does not create an investment advisory, '
          'brokerage, financial-planning, fiduciary, attorney-client, '
          'accountant-client, or tax-advisory relationship between the user '
          'and SDK Investing LLC, its owners, officers, employees, developers, '
          'contractors, data providers, or affiliates.',
        ),
        LegalBlock.paragraph(
          'SDK Investing does not take custody of user investment assets and '
          'does not have discretionary authority over users’ brokerage or '
          'financial accounts.',
        ),
        LegalBlock.paragraph(
          'SDK Investing does not execute securities transactions on behalf of '
          'users.',
        ),
        LegalBlock.paragraph(
          'Users remain solely responsible for determining whether any '
          'investment or investment strategy is appropriate for them.',
        ),
      ],
    ),
    LegalSection(
      number: 6,
      heading: 'Investing Involves Risk',
      blocks: [
        LegalBlock.paragraph('All investing involves risk.'),
        LegalBlock.paragraph(
          'Securities and other financial instruments may increase or decrease '
          'substantially in value, and investors may lose some or all of the '
          'money invested.',
        ),
        LegalBlock.paragraph(
          'Certain investments may involve substantially greater risks than '
          'others, including but not limited to:',
        ),
        LegalBlock.bullets([
          'Individual stocks',
          'Small-capitalization securities',
          'Emerging-growth companies',
          'Options',
          'Leveraged investments',
          'Exchange-traded funds',
          'International securities',
          'Cryptocurrency and digital assets',
          'Highly volatile or speculative investments',
        ]),
        LegalBlock.paragraph(
          'Market conditions can change rapidly and without warning.',
        ),
        LegalBlock.paragraph(
          'No SDK Score, Model Signal, ranking, analysis, alert, projection, '
          'estimate, commentary, or other information eliminates investment '
          'risk.',
        ),
      ],
    ),
    LegalSection(
      number: 7,
      heading: 'No Guarantee of Performance',
      blocks: [
        LegalBlock.paragraph(
          'SDK Investing makes no guarantee or representation regarding future '
          'investment performance.',
        ),
        LegalBlock.paragraph(
          'Past performance does not guarantee future results.',
        ),
        LegalBlock.paragraph(
          'A security that previously received a high SDK Score may '
          'subsequently decline substantially in value.',
        ),
        LegalBlock.paragraph(
          'A security with a low SDK Score may subsequently increase '
          'substantially in value.',
        ),
        LegalBlock.paragraph(
          'SDK Scores and Model Signals may change as financial results, '
          'market prices, economic conditions, company fundamentals, analyst '
          'information, or other inputs change.',
        ),
        LegalBlock.paragraph(
          'No SDK Score or classification should be interpreted as a guarantee '
          'that a security will achieve any particular return, price target, '
          'or investment outcome.',
        ),
      ],
    ),
    LegalSection(
      number: 8,
      heading: 'Model Limitations',
      blocks: [
        LegalBlock.paragraph(
          'The SDK methodology is a quantitative and analytical framework and, '
          'like all investment models, has limitations.',
        ),
        LegalBlock.paragraph(
          'No mathematical or analytical model can incorporate every factor '
          'that may influence the future price or performance of a security.',
        ),
        LegalBlock.paragraph(
          'Factors not fully reflected in an SDK Score may include, among '
          'other things:',
        ),
        LegalBlock.bullets([
          'Unexpected company developments',
          'Changes in management',
          'Regulatory actions',
          'Litigation',
          'Political or geopolitical events',
          'Interest-rate changes',
          'Economic recessions',
          'Industry disruption',
          'Competitive developments',
          'Acquisitions or divestitures',
          'Accounting restatements',
          'Market sentiment',
          'Liquidity events',
          'Natural disasters',
          'Cybersecurity incidents',
          'Changes in investor expectations',
          'Sudden market volatility',
        ]),
        LegalBlock.paragraph(
          'Model results should therefore be considered one analytical input '
          'among many rather than a substitute for independent judgment and '
          'due diligence.',
        ),
      ],
    ),
    LegalSection(
      number: 9,
      heading: 'Data Availability and Confidence',
      blocks: [
        LegalBlock.paragraph(
          'SDK Investing may classify analyses according to the amount, '
          'quality, and availability of underlying information.',
        ),
        LegalBlock.paragraph('These classifications may include:'),
        LegalBlock.bullets([
          'Full Data — sufficient information is available for the '
              "model's standard analysis.",
          'Limited Data — one or more relevant data elements may be '
              'unavailable or incomplete.',
          'Provisional Score — the score is based on available '
              'information but should be interpreted with additional caution '
              'because important inputs may be incomplete, unavailable, or '
              'subject to confirmation.',
          'Insufficient Data — insufficient information is available to '
              'generate a reliable SDK Score or Model Signal.',
        ]),
        LegalBlock.paragraph(
          'Users should consider these designations when interpreting SDK '
          'Scores.',
        ),
        LegalBlock.paragraph(
          'A high numerical score derived from incomplete information should '
          'not be assumed to have the same degree of analytical confidence as '
          'a score based upon complete information.',
        ),
      ],
    ),
    LegalSection(
      number: 10,
      heading: 'Third-Party Financial and Market Data',
      blocks: [
        LegalBlock.paragraph(
          'SDK Investing relies in part upon financial, fundamental, pricing, '
          'market, corporate, analyst, and other information supplied by '
          'third-party data providers and publicly available sources.',
        ),
        LegalBlock.paragraph(
          'SDK Investing endeavors to use information believed to be reliable '
          'but cannot guarantee that third-party information is always:',
        ),
        LegalBlock.bullets([
          'Accurate',
          'Complete',
          'Current',
          'Timely',
          'Error-free',
          'Continuously available',
        ]),
        LegalBlock.paragraph(
          'Financial information may be delayed, revised, corrected, restated, '
          'or temporarily unavailable.',
        ),
        LegalBlock.paragraph(
          'Errors or omissions in underlying information may affect an SDK '
          'Score or Model Signal.',
        ),
        LegalBlock.paragraph(
          'SDK Investing is not responsible for errors originating from '
          'third-party information providers except to the extent otherwise '
          'required by applicable law.',
        ),
      ],
    ),
    LegalSection(
      number: 11,
      heading: 'Timing of Information',
      blocks: [
        LegalBlock.paragraph(
          'SDK Scores and other information reflect information available to '
          'the SDK system at a particular point in time.',
        ),
        LegalBlock.paragraph(
          'Company fundamentals, securities prices, earnings forecasts, market '
          'conditions, and other inputs may change between updates.',
        ),
        LegalBlock.paragraph(
          'Accordingly, an SDK Score displayed at one time may not reflect '
          'information released immediately afterward.',
        ),
        LegalBlock.paragraph(
          'Users should independently verify material information before '
          'making an investment decision.',
        ),
      ],
    ),
    LegalSection(
      number: 12,
      heading: 'Historical, Backtested, Simulated, or Hypothetical Results',
      blocks: [
        LegalBlock.paragraph(
          'From time to time, SDK Investing may present historical analyses, '
          'model comparisons, backtested results, hypothetical portfolios, '
          'simulated results, or educational examples.',
        ),
        LegalBlock.paragraph('Such results have inherent limitations.'),
        LegalBlock.paragraph(
          'Hypothetical or backtested results do not represent actual trading '
          'in an actual account unless specifically identified as such.',
        ),
        LegalBlock.paragraph(
          'They may not fully reflect transaction costs, taxes, liquidity '
          'constraints, bid-ask spreads, market impact, investment timing, '
          'behavioral decisions, or other conditions encountered during actual '
          'investing.',
        ),
        LegalBlock.paragraph(
          'No historical, hypothetical, simulated, or backtested result should '
          'be interpreted as a promise or prediction of future performance.',
        ),
      ],
    ),
    LegalSection(
      number: 13,
      heading: 'Independent Research and Professional Advice',
      blocks: [
        LegalBlock.paragraph(
          'Users should perform their own independent research before '
          'purchasing, selling, or holding any investment.',
        ),
        LegalBlock.paragraph(
          'SDK Investing should not be used as the sole basis for a material '
          'financial decision.',
        ),
        LegalBlock.paragraph(
          'Where appropriate, users should consult qualified professionals, '
          'which may include a registered investment adviser, financial '
          'professional, tax adviser, certified public accountant, or attorney '
          "who can evaluate the user's particular circumstances.",
        ),
      ],
    ),
    LegalSection(
      number: 14,
      heading: 'User Is Responsible for Investment Decisions',
      blocks: [
        LegalBlock.paragraph(
          'All investment decisions are made solely by the user.',
        ),
        LegalBlock.paragraph(
          'By using SDK Investing, you acknowledge that you are responsible '
          'for:',
        ),
        LegalBlock.bullets([
          'Evaluating the risks of an investment',
          'Determining whether an investment is appropriate for you',
          'Determining the amount you invest',
          'Determining when to purchase or sell an investment',
          'Monitoring your investments',
          'Understanding potential tax consequences',
          'Conducting additional research when appropriate',
        ]),
        LegalBlock.paragraph(
          'SDK Investing does not assume responsibility for investment '
          'decisions made by users based upon SDK Scores, Model Signals, '
          'rankings, analyses, educational materials, or other information '
          'provided through the SDK Platform.',
        ),
      ],
    ),
    LegalSection(
      number: 15,
      heading: 'Potential Ownership and Conflicts of Interest',
      blocks: [
        LegalBlock.paragraph(
          'SDK Investing LLC, its owners, officers, contributors, or '
          'affiliated persons may from time to time own, purchase, sell, or '
          'otherwise have a financial interest in securities that are '
          'analyzed, displayed, discussed, ranked, or scored through the SDK '
          'Platform.',
        ),
        LegalBlock.paragraph(
          'The existence of such a position does not alter the established SDK '
          'scoring methodology.',
        ),
        LegalBlock.paragraph(
          'SDK Investing does not intend to modify individual security scores '
          'for the purpose of benefiting an owner, officer, contributor, '
          'affiliate, advertiser, or other interested party.',
        ),
        LegalBlock.paragraph(
          'Where a specific relationship creates a material conflict requiring '
          'additional disclosure, SDK Investing may provide an additional '
          'disclosure as appropriate.',
        ),
      ],
    ),
    LegalSection(
      number: 16,
      heading: 'No Payment for Favorable SDK Scores',
      blocks: [
        LegalBlock.paragraph(
          'Unless clearly and specifically disclosed to users, companies and '
          'issuers do not pay SDK Investing to receive favorable SDK Scores or '
          'Model Signals.',
        ),
        LegalBlock.paragraph(
          'SDK Scores should be generated according to the established SDK '
          'methodology rather than according to advertising, sponsorship, '
          'affiliate, issuer, or promotional considerations.',
        ),
        LegalBlock.paragraph(
          'Any sponsored or paid content, if introduced in the future, should '
          'be separately and clearly identified as such.',
        ),
      ],
    ),
    LegalSection(
      number: 17,
      heading: 'Affiliate and Sponsored Relationships',
      blocks: [
        LegalBlock.paragraph(
          'If SDK Investing receives compensation from an affiliate '
          'relationship, sponsorship, advertisement, referral arrangement, or '
          'other commercial relationship connected with content appearing on '
          'the SDK Platform, the existence of the relationship will be '
          'disclosed where required.',
        ),
        LegalBlock.paragraph(
          'Such compensation does not constitute a guarantee regarding the '
          'quality, suitability, or investment performance of the product or '
          'service involved.',
        ),
      ],
    ),
    LegalSection(
      number: 18,
      heading: 'No Warranty',
      blocks: [
        LegalBlock.paragraph(
          'To the fullest extent permitted by applicable law, the SDK Platform '
          'and its information are provided on an “as is” and '
          '“as available” basis.',
        ),
        LegalBlock.paragraph('SDK Investing does not warrant that:'),
        LegalBlock.bullets([
          'The SDK Platform will always be available or uninterrupted;',
          'All information will be complete or error-free;',
          'Every SDK Score will reflect every relevant factor;',
          'Data providers will always provide information without '
              'interruption;',
          'Model Signals will predict future securities performance; or',
          'Use of the SDK Platform will result in investment profits or '
              'prevent investment losses.',
        ]),
        LegalBlock.paragraph(
          'Nothing in this section excludes any warranty or right that cannot '
          'legally be excluded under applicable law.',
        ),
      ],
    ),
    LegalSection(
      number: 19,
      heading: 'Limitation of Liability',
      blocks: [
        LegalBlock.paragraph(
          'To the fullest extent permitted by applicable law, SDK Investing '
          'LLC and its owners, officers, employees, contractors, developers, '
          'contributors, licensors, affiliates, and data providers shall not '
          'be liable for investment losses or other damages arising from a '
          "user's reliance upon SDK Scores, Model Signals, rankings, analyses, "
          'market information, educational material, third-party data, or '
          'other content made available through the SDK Platform.',
        ),
        LegalBlock.paragraph(
          'Nothing in this Disclaimer is intended to waive, limit, or exclude '
          'any liability or legal right that cannot lawfully be waived, '
          'limited, or excluded.',
        ),
      ],
    ),
    LegalSection(
      number: 20,
      heading: 'No Tax, Accounting, or Legal Advice',
      blocks: [
        LegalBlock.paragraph(
          'Information available through SDK Investing should not be '
          'interpreted as tax, accounting, estate-planning, or legal advice.',
        ),
        LegalBlock.paragraph(
          'Tax treatment and legal consequences vary substantially among '
          'users.',
        ),
        LegalBlock.paragraph(
          'Users should consult appropriately qualified professionals '
          'regarding these matters.',
        ),
      ],
    ),
    LegalSection(
      number: 21,
      heading: 'Changes to SDK Scores and Methodology',
      blocks: [
        LegalBlock.paragraph(
          'SDK Investing may periodically improve, revise, or update its '
          'analytical methodology, data sources, scoring methodology, '
          'classifications, or presentation.',
        ),
        LegalBlock.paragraph(
          'When material methodology changes are implemented, SDK Investing '
          'should endeavor to identify the applicable methodology or version '
          'where appropriate.',
        ),
        LegalBlock.paragraph(
          'Scores generated under different versions of the SDK methodology '
          'may not be directly comparable.',
        ),
      ],
    ),
    LegalSection(
      number: 22,
      heading: 'Acceptance and Acknowledgment',
      blocks: [
        LegalBlock.paragraph(
          'By creating an SDK Investing account or subscribing to the SDK '
          'Platform, you affirmatively acknowledge and agree that:',
        ),
        LegalBlock.numbered([
          'You have read and understood this Investment Disclaimer and User '
              'Acknowledgment.',
          'SDK Investing provides general educational, informational, and '
              'analytical content.',
          'SDK Scores and Strong Buy, Buy, Hold, Trim, and Sell '
              'classifications are SDK MODEL SIGNALS and are not '
              'individualized investment recommendations.',
          'SDK Investing has not evaluated your individual financial '
              'circumstances or determined whether any particular investment '
              'is appropriate for you.',
          'Investing involves substantial risk, including the possible loss '
              'of some or all invested capital.',
          'Past performance and SDK Scores do not guarantee future investment '
              'results.',
          'Financial and market information may be incomplete, delayed, '
              'incorrect, or subsequently revised.',
          'You will conduct your own due diligence and obtain professional '
              'advice when appropriate.',
          'You are solely responsible for your investment decisions and '
              'transactions.',
          'Your use of SDK Investing does not create an investment advisory, '
              'brokerage, fiduciary, legal, accounting, or tax-advisory '
              'relationship.',
        ]),
        LegalBlock.paragraph(
          'If you do not understand or agree to these provisions, you should '
          'not create an account, purchase a subscription, or use the SDK '
          'Platform.',
        ),
      ],
    ),
  ],
);
