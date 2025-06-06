//
//  Markdown.swift
//
//
//  Created edu on 6/6/25.
//

import SwiftUI


private let headingRegex = try! NSRegularExpression(pattern: "^(#{1,6})\\s.*$", options: [.anchorsMatchLines])
// 1) Bold: **text**
private let boldRegex = try! NSRegularExpression(
    pattern: #"(\*\*)([^\*]+)(\*\*)"#,
    options: []
)

// 2) Italics only when not part of **…**:
private let italicRegex = try! NSRegularExpression(
    pattern: #"(?<!\*)(\*)([^*]+)(\*)(?!\*)"#,
    options: []
)
private let checkboxRegex = try! NSRegularExpression(pattern: "[□☒]", options: [])

private let underlineRegex     = try! NSRegularExpression(pattern: #"(_)([^_]+)(_)"#, options: [])
//private let italicRegex        = try! NSRegularExpression(pattern:  #"(?<!\*)\*([^*]+)\*(?!\*)"#, options: [])
//private let uListMarkerRegex   = try! NSRegularExpression(pattern: #"^(\-\s)"#, options: [.anchorsMatchLines])
private let oListMarkerRegex   = try! NSRegularExpression(pattern: #"^(\d+\.\s)"#, options: [.anchorsMatchLines])
private let checkedLineRegex   = try! NSRegularExpression(pattern: #"(☒\s)(.*)"#, options: [.anchorsMatchLines])
private let mentionRegex       = try! NSRegularExpression(pattern: #"(@[A-Za-z0-9_]+)"#, options: [])
private let tagRegex2          = try! NSRegularExpression(pattern: #"(#[A-Za-z0-9_]+)"#, options: [])

// 1) two highlights: one for ::…:: and one for ==…==
private let doubleColonHighlightRegex = try! NSRegularExpression(
    pattern: #"(::)([^:]+)(::)"#,
    options: []
)
private let doubleEqualHighlightRegex = try! NSRegularExpression(
    pattern: #"(==)([^=]+)(==)"#,
    options: []
)

// Unordered‐list markers now include "- ", "• ", or "· "
private let uListMarkerRegex = try! NSRegularExpression(
    pattern: #"^([\-•·]\s)"#,
    options: [.anchorsMatchLines]
)

// Money: $cash, $12, $12.34, €23, €23,245
private let moneyRegex = try! NSRegularExpression(
    pattern: #"([$€](?:[A-Za-z]+|\d{1,3}(?:,\d{3})*(?:\.\d+)?))"#,
    options: []
)


//#if os(macOS)
//let timeForegroundColor = NSColor.systemOrange
//let markupColor         = NSColor.systemPurple
//let dateColor           = NSColor.systemGray
//#else
//let timeForegroundColor = UIColor.systemOrange
//let markupColor         = UIColor.systemPurple
//let dateColor           = UIColor.systemGray
//#endif

// 2) Add these new regexes:

private let timeHHmmRegex       = try! NSRegularExpression(pattern: #"\b(\d{1,2}:\d{2})\b"#,       options: [])
private let yearYYYYRegex       = try! NSRegularExpression(pattern: #"\b(\d{4})\b"#,             options: [])
private let dateMMMddYYYYRegex  = try! NSRegularExpression(pattern: #"\b([A-Za-z]{1,24}\s\d{1,2},\s\d{4})\b"#, options: [])
private let dateSlashRegex      = try! NSRegularExpression(pattern: #"\b(\d{1,4}/\d{1,4}/\d{1,4})\b"#,   options: [])
private let dateDashRegex       = try! NSRegularExpression(pattern: #"\b(\d{1,4}-\d{1,4}-\d{1,4})\b"#,   options: [])
private let quotesRegex         = try! NSRegularExpression(pattern: #"(".+?")"#,                    options: [])
private let parenthesesRegex    = try! NSRegularExpression(pattern: #"(\([^()]*\))"#,               options: [])
private let commentLineRegex    = try! NSRegularExpression(pattern: #"(?m)(//.*)$"#,                options: [])

// 3) In your existing HighlightRule collection 





















private let inlineCodeRegex = try! NSRegularExpression(pattern: "`[^`]*`", options: [])
private let codeBlockRegex = try! NSRegularExpression(
    pattern: "(`){3}((?!\\1).)+\\1{3}",
    options: [.dotMatchesLineSeparators]
)
//private let headingRegex = try! NSRegularExpression(pattern: "^#{1,6}\\s.*$", options: [.anchorsMatchLines])

private let linkOrImageRegex = try! NSRegularExpression(pattern: "!?\\[([^\\[\\]]*)\\]\\((.*?)\\)", options: [])
private let linkOrImageTagRegex = try! NSRegularExpression(pattern: "!?\\[([^\\[\\]]*)\\]\\[(.*?)\\]", options: [])
//private let boldRegex = try! NSRegularExpression(pattern: "((\\*|_){2})((?!\\1).)+\\1", options: [])


private let underscoreEmphasisRegex = try! NSRegularExpression(pattern: "(?<!_)_[^_]+_(?!\\*)", options: [])
private let asteriskEmphasisRegex = try! NSRegularExpression(pattern: "(?<!\\*)(\\*)((?!\\1).)+\\1(?!\\*)", options: [])
private let boldEmphasisAsteriskRegex = try! NSRegularExpression(pattern: "(\\*){3}((?!\\1).)+\\1{3}", options: [])
private let blockquoteRegex = try! NSRegularExpression(pattern: "^>.*", options: [.anchorsMatchLines])
private let horizontalRuleRegex = try! NSRegularExpression(pattern: "\n\n(-{3}|\\*{3})\n", options: [])
private let unorderedListRegex = try! NSRegularExpression(pattern: "^(\\-|\\*)\\s", options: [.anchorsMatchLines])
private let orderedListRegex = try! NSRegularExpression(pattern: "^\\d*\\.\\s", options: [.anchorsMatchLines])
private let buttonRegex = try! NSRegularExpression(pattern: "<\\s*button[^>]*>(.*?)<\\s*/\\s*button>", options: [])
private let strikethroughRegex = try! NSRegularExpression(pattern: "(~)((?!\\1).)+\\1", options: [])
private let tagRegex = try! NSRegularExpression(pattern: "^\\[([^\\[\\]]*)\\]:", options: [.anchorsMatchLines])
private let footnoteRegex = try! NSRegularExpression(pattern: "\\[\\^(.*?)\\]", options: [])
// courtesy https://www.regular-expressions.info/examples.html
private let htmlRegex = try! NSRegularExpression(
    pattern: "<([A-Z][A-Z0-9]*)\\b[^>]*>(.*?)</\\1>",
    options: [.dotMatchesLineSeparators, .caseInsensitive]
)

#if os(macOS)
let codeFont = NSFont.monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: .regular)
let headingTraits: NSFontDescriptor.SymbolicTraits = [.bold, .expanded]
let boldTraits: NSFontDescriptor.SymbolicTraits = [.bold]
let emphasisTraits: NSFontDescriptor.SymbolicTraits = [.italic]
let boldEmphasisTraits: NSFontDescriptor.SymbolicTraits = [.bold, .italic]
let secondaryBackground = NSColor.windowBackgroundColor
let lighterColor = NSColor.gray
let pinkColor = NSColor.pink
let textColor = NSColor.labelColor
#else
//let codeFont = UIFont.monospacedSystemFont(ofSize: UIFont.systemFontSize, weight: .thin)
//let headingTraits: UIFontDescriptor.SymbolicTraits = [.traitBold, .traitExpanded]
//let boldTraits: UIFontDescriptor.SymbolicTraits = [.traitBold]
//let emphasisTraits: UIFontDescriptor.SymbolicTraits = [.traitItalic]
//let boldEmphasisTraits: UIFontDescriptor.SymbolicTraits = [.traitBold, .traitItalic]
//let secondaryBackground = UIColor.secondarySystemBackground
//let lighterColor = UIColor.systemGray
//let pinkColor = UIColor.systemPink
//let textColor = UIColor.label
#endif

import SwiftUI

// ───────────────────────────────────────────────────────────────────
// 1) SwiftUI Color properties (usable anywhere in your SwiftUI views):

public var foregColorHighlight: Color {
    Color(UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor.gray.withAlphaComponent(0.2)
        } else {
            return UIColor.white.withAlphaComponent(0.84)
        }
    })
}

public var foregColor: Color {
    Color(UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .dark {
            return UIColor.gray.withAlphaComponent(0.1)
        } else {
            return UIColor.white.withAlphaComponent(0.5)
        }
    })
}


public var bgColor: Color = {
    if #available(iOS 15.0, *) {
        Color(uiColor: UIColor { trait in
            switch trait.userInterfaceStyle {
            case .dark:
                return UIColor(hex: "#181c21")
            default:
                return UIColor(hex: "#F4F4F6")
            }
        })
    } else {
        // Fallback on earlier versions
        Color.white
    }
}()

// ───────────────────────────────────────────────────────────────────
// 2) Editor / syntax‐highlighting colors (NSColor on macOS, UIColor on iOS):

#if os(macOS)
// MARK: ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
let codeFont              = NSFont.monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: .regular)
let headingTraits: NSFontDescriptor.SymbolicTraits = [.bold, .expanded]
let boldTraits:    NSFontDescriptor.SymbolicTraits = [.bold]
let emphasisTraits: NSFontDescriptor.SymbolicTraits = [.italic]
let boldEmphasisTraits: NSFontDescriptor.SymbolicTraits = [.bold, .italic]

let secondaryBackground   = NSColor.windowBackgroundColor
let lighterColor          = NSColor.gray
let pinkColor             = NSColor.pink
let textColor             = NSColor.labelColor

// Dynamic colors for syntax:

let defaultForegroundColor = NSColor { traits in
    traits.userInterfaceStyle == .dark
    ? NSColor(hex: "#d0d9e5")
    : NSColor(hex: "#424242")
}

let markupColor = NSColor { traits in
    traits.userInterfaceStyle == .dark
    ? NSColor(hex: "#7e8ea3")
    : NSColor(hex: "#696e7e")
}

let headingColor = NSColor { traits in
    traits.userInterfaceStyle == .dark
    ? NSColor(hex: "#e8f1ff")
    : NSColor(hex: "#424242")
}

let redSymbolColor = NSColor(hex: "#de4e69") // same in both modes

let mentionColor = NSColor { traits in
    traits.userInterfaceStyle == .dark
    ? NSColor(hex: "#a7c6e5")
    : NSColor(hex: "#51657f")
}

let tagForegroundColor = NSColor { traits in
    traits.userInterfaceStyle == .dark
    ? NSColor(hex: "#d7efe6")
    : NSColor(hex: "#255d4d")
}

let tagBackgroundColor = NSColor { traits in
    traits.userInterfaceStyle == .dark
    ? NSColor(hex: "#255d4d")
    : NSColor(hex: "#d7efe6")
}

let strikethroughColor = NSColor(hex: "#737d8a") // same in both modes

let timeForegroundColor = NSColor { traits in
    traits.userInterfaceStyle == .dark
    ? NSColor(hex: "#fafafa")
    : NSColor(hex: "#51657f")
}

let timeBackgroundColor = NSColor { traits in
    traits.userInterfaceStyle == .dark
    ? NSColor(hex: "#252a31")
    : NSColor(hex: "#eff3f7")
}

let dateColor = NSColor { traits in
    traits.userInterfaceStyle == .dark
    ? NSColor(hex: "#99abc4")
    : NSColor(hex: "#8a93a0")
}

let highlightForegroundColor = NSColor { traits in
    traits.userInterfaceStyle == .dark
    ? NSColor(hex: "#f4f4f4")
    : NSColor(hex: "#424242")
}

let highlightBackgroundColor = NSColor { traits in
    traits.userInterfaceStyle == .dark
    ? NSColor(hex: "#706934")
    : NSColor(hex: "#fdef9f")
}

let commentColor = NSColor { traits in
    traits.userInterfaceStyle == .dark
    ? NSColor(hex: "#7b8189")
    : NSColor(hex: "#737d8a")
}

let codeForegroundColor = NSColor { traits in
    traits.userInterfaceStyle == .dark
    ? NSColor(hex: "#99abc4")
    : NSColor(hex: "#8a93a0")
}

let codeBackgroundColor = NSColor { traits in
    (traits.userInterfaceStyle == .dark
     ? NSColor(hex: "#252a31")
     : NSColor(hex: "#eff3f7")
    ).withAlphaComponent(0.8)
}

let footnoteColor = NSColor(hex: "#dc3b66") // same in both modes

let cashTagColor = NSColor { traits in
    traits.userInterfaceStyle == .dark
    ? NSColor(hex: "#64b075")
    : NSColor(hex: "#406b4f")
}

#else
// MARK: ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
let codeFont              = UIFont.monospacedSystemFont(ofSize: UIFont.systemFontSize, weight: .regular)
let headingTraits: UIFontDescriptor.SymbolicTraits = [.traitBold, .traitExpanded]
let boldTraits:    UIFontDescriptor.SymbolicTraits = [.traitBold]
let emphasisTraits: UIFontDescriptor.SymbolicTraits = [.traitItalic]
let boldEmphasisTraits: UIFontDescriptor.SymbolicTraits = [.traitBold, .traitItalic]

let secondaryBackground   = UIColor.secondarySystemBackground
let lighterColor          = UIColor.systemGray
let pinkColor             = UIColor.systemPink
let textColor             = UIColor.label

// Dynamic colors for syntax:

let defaultForegroundColor = UIColor { traits in
    traits.userInterfaceStyle == .dark
    ? UIColor(hex: "#d0d9e5")
    : UIColor(hex: "#424242")
}

let markupColor = UIColor { traits in
    traits.userInterfaceStyle == .dark
    ? UIColor(hex: "#7e8ea3")
    : UIColor(hex: "#696e7e")
}

let headingColor = UIColor { traits in
    traits.userInterfaceStyle == .dark
    ? UIColor(hex: "#e8f1ff")
    : UIColor(hex: "#424242")
}

let redSymbolColor = UIColor(hex: "#de4e69") // same in both modes

let mentionColor = UIColor { traits in
    traits.userInterfaceStyle == .dark
    ? UIColor(hex: "#a7c6e5")
    : UIColor(hex: "#51657f")
}

let tagForegroundColor = UIColor { traits in
    traits.userInterfaceStyle == .dark
    ? UIColor(hex: "#d7efe6")
    : UIColor(hex: "#255d4d")
}

let tagBackgroundColor = UIColor { traits in
    traits.userInterfaceStyle == .dark
    ? UIColor(hex: "#255d4d")
    : UIColor(hex: "#d7efe6")
}

let strikethroughColor = UIColor(hex: "#737d8a") // same in both modes

let timeForegroundColor = UIColor { traits in
    traits.userInterfaceStyle == .dark
    ? UIColor(hex: "#fafafa")
    : UIColor(hex: "#51657f")
}

let timeBackgroundColor = UIColor { traits in
    traits.userInterfaceStyle == .dark
    ? UIColor(hex: "#252a31")
    : UIColor(hex: "#eff3f7")
}

let dateColor = UIColor { traits in
    traits.userInterfaceStyle == .dark
    ? UIColor(hex: "#99abc4")
    : UIColor(hex: "#8a93a0")
}

let highlightForegroundColor = UIColor { traits in
    traits.userInterfaceStyle == .dark
    ? UIColor(hex: "#f4f4f4")
    : UIColor(hex: "#424242")
}

let highlightBackgroundColor = UIColor { traits in
    (traits.userInterfaceStyle == .dark
     ? UIColor(hex: "#706934")
     : UIColor(hex: "#fdef9f")
    )
}

let commentColor = UIColor { traits in
    traits.userInterfaceStyle == .dark
    ? UIColor(hex: "#7b8189")
    : UIColor(hex: "#737d8a")
}

let codeForegroundColor = UIColor { traits in
    traits.userInterfaceStyle == .dark
    ? UIColor(hex: "#99abc4")
    : UIColor(hex: "#8a93a0")
}

let codeBackgroundColor = UIColor { traits in
    (traits.userInterfaceStyle == .dark
     ? UIColor(hex: "#252a31")
     : UIColor(hex: "#eff3f7")
    ).withAlphaComponent(0.8)
}

let footnoteColor = UIColor(hex: "#dc3b66") // same in both modes

let cashTagColor = UIColor { traits in
    traits.userInterfaceStyle == .dark
    ? UIColor(hex: "#64b075")
    : UIColor(hex: "#406b4f")
}
#endif
































private let maxHeadingLevel = 6

public extension Sequence where Iterator.Element == HighlightRule {
    static var edumarkdown: [HighlightRule] {
        [
            // heading rule
            HighlightRule(
                pattern: headingRegex,
                formattingRules: [
                    // A) Full match (group 0): compute size + bold/expanded, text in headingColor
                    TextFormattingRule(
                        key: .font,
                        calculateValue: { content, _ in
                            let uncappedLevel = content.prefix { $0 == "#" }.count
                            let level = Swift.min(maxHeadingLevel, uncappedLevel)
                            let fontSize = CGFloat(maxHeadingLevel - level) * 2.5
                            + defaultEditorFont.pointSize
                            return SystemFontAlias(
                                descriptor: defaultEditorFont.fontDescriptor,
                                size: fontSize
                            ) as Any
                        },
                        group: 0
                    ),
                    TextFormattingRule(fontTraits: headingTraits, group: 0),
                    TextFormattingRule(key: .foregroundColor, value: headingColor, group: 0),
                    
                    // B) Hashes only (group 1): base font + markupColor
                    TextFormattingRule(key: .font, value: defaultEditorFont, group: 1),
                    TextFormattingRule(key: .foregroundColor, value: markupColor, group: 1)
                ]
            ),
            
            // Bold: **text**
            HighlightRule(
                pattern: boldRegex,
                formattingRules: [
                    // group 1 ("**") → monospace + systemGray
                    TextFormattingRule(key: .font,          value: codeFont,      group: 1),
                    TextFormattingRule(key: .foregroundColor, value: UIColor.systemGray, group: 1),
                    // group 3 ("**") → monospace + systemGray
                    TextFormattingRule(key: .font,          value: codeFont,      group: 3),
                    TextFormattingRule(key: .foregroundColor, value: UIColor.systemGray, group: 3),
                    // group 2 ("text") → bold + defaultForegroundColor
                    TextFormattingRule(fontTraits: boldTraits, group: 2),
                    TextFormattingRule(key: .foregroundColor, value: defaultForegroundColor, group: 2)
                ]
            ),
            
            // Italics: *text*
            HighlightRule(
                pattern: italicRegex,
                formattingRules: [
                    // group 1 ("*") → monospace + systemGray
                    TextFormattingRule(key: .font,          value: codeFont,      group: 1),
                    TextFormattingRule(key: .foregroundColor, value: UIColor.systemGray, group: 1),
                    // group 3 ("*") → monospace + systemGray
                    TextFormattingRule(key: .font,          value: codeFont,      group: 3),
                    TextFormattingRule(key: .foregroundColor, value: UIColor.systemGray, group: 3),
                    // group 2 ("text") → italic + defaultForegroundColor
                    TextFormattingRule(fontTraits: emphasisTraits, group: 2),
                    TextFormattingRule(key: .foregroundColor, value: defaultForegroundColor, group: 2)
                ]
            ),
            
            // Underline: "_text_"
            HighlightRule(
                pattern: underlineRegex,
                formattingRules: [
                    // group 1 ("_") → monospace + systemGray
                    TextFormattingRule(key: .font,          value: codeFont,      group: 1),
                    TextFormattingRule(key: .foregroundColor, value: UIColor.systemGray, group: 1),
                    // group 3 ("_") → monospace + systemGray
                    TextFormattingRule(key: .font,          value: codeFont,      group: 3),
                    TextFormattingRule(key: .foregroundColor, value: UIColor.systemGray, group: 3),
                    // group 2 ("text") → underline + defaultForegroundColor
                    TextFormattingRule(key: .underlineStyle, value: NSUnderlineStyle.single.rawValue, group: 2),
                    TextFormattingRule(key: .foregroundColor, value: defaultForegroundColor, group: 2)
                ]
            ),
            
            // Unordered‐list marker ("- ", "• ", "· ")
            HighlightRule(
                pattern: uListMarkerRegex,
                formattingRules: [
                    TextFormattingRule(fontTraits: boldTraits, group: 1),
                    TextFormattingRule(key: .foregroundColor, value: redSymbolColor, group: 1)
                ]
            ),
            
            // Ordered‐list marker ("1. ")
            HighlightRule(
                pattern: oListMarkerRegex,
                formattingRules: [
                    TextFormattingRule(fontTraits: boldTraits, group: 1),
                    TextFormattingRule(key: .foregroundColor, value: redSymbolColor, group: 1)
                ]
            ),
            
            // lines that start with "☒ "
            HighlightRule(
                pattern: checkedLineRegex,
                formattingRules: [
                    // group 1 = "☒ " → base font + markupColor
                    TextFormattingRule(key: .font,          value: defaultEditorFont, group: 1),
                    TextFormattingRule(key: .foregroundColor, value: markupColor, group: 1),
                    // group 2 = rest of line → strikethrough + strikethroughColor
                    TextFormattingRule(key: .strikethroughStyle, value: NSUnderlineStyle.single.rawValue, group: 2),
                    TextFormattingRule(key: .foregroundColor,    value: strikethroughColor, group: 2)
                ]
            ),
            
            // @mentions
            HighlightRule(
                pattern: mentionRegex,
                formattingRules: [
                    TextFormattingRule(fontTraits: boldTraits, group: 1),
                    TextFormattingRule(key: .foregroundColor, value: mentionColor, group: 1)
                ]
            ),
            
            // #tags
            HighlightRule(
                pattern: tagRegex2,
                formattingRules: [
                    TextFormattingRule(fontTraits: boldTraits, group: 1),
                    TextFormattingRule(key: .foregroundColor, value: tagForegroundColor, group: 1),
                    TextFormattingRule(key: .backgroundColor, value: tagBackgroundColor, group: 1)
                ]
            ),
            
            // Checkbox (□/☒)
            HighlightRule(
                pattern: checkboxRegex,
                formattingRules: [
                    // group 0 → if "□" then redSymbolColor, if "☒" then markupColor
                    TextFormattingRule(
                        key: .foregroundColor,
                        calculateValue: { content, _ in
                            return (content == "□") ? redSymbolColor : markupColor
                        },
                        group: 0
                    ),
                    // group 0 → tappable link (unchanged)
                    TextFormattingRule(
                        key: .link,
                        calculateValue: { _, _ in URL(string: "toggle://checkbox")! as Any },
                        group: 0
                    )
                ]
            ),
            
            // inline code (`code`)
            HighlightRule(
                pattern: inlineCodeRegex,
                formattingRules: [
                    // group 0 match entire "`…`" → monospace + codeForegroundColor + codeBackgroundColor
                    TextFormattingRule(key: .font,          value: codeFont,              group: 0),
                    TextFormattingRule(key: .foregroundColor, value: codeForegroundColor,   group: 0),
                    TextFormattingRule(key: .backgroundColor, value: codeBackgroundColor,    group: 0)
                ]
            ),
            
            // code block
            HighlightRule(
                pattern: codeBlockRegex,
                formattingRules: [
                    TextFormattingRule(key: .font,            value: codeFont,           group: 0),
                    TextFormattingRule(key: .foregroundColor, value: codeForegroundColor, group: 0),
                    TextFormattingRule(key: .backgroundColor, value: codeBackgroundColor,  group: 0)
                ]
            ),
            
            // ::highlight::  → yellowish background + systemGray markers + highlightForegroundColor text
            HighlightRule(
                pattern: doubleColonHighlightRegex,
                formattingRules: [
                    // entire "::text::" → highlightBackgroundColor
                    TextFormattingRule(key: .backgroundColor, value: highlightBackgroundColor.withAlphaComponent(0.8), group: 0),
                    // group 1 ("::") → monospace + systemGray
//                    TextFormattingRule(key: .font,          value: codeFont,      group: 1),
                    TextFormattingRule(key: .foregroundColor, value: UIColor.systemGray, group: 1),
                    // group 2 (inner text) → highlightForegroundColor
                    TextFormattingRule(key: .foregroundColor, value: highlightForegroundColor, group: 2),
                    // group 3 ("::") → monospace + systemGray
//                    TextFormattingRule(key: .font,          value: codeFont,      group: 3),
                    TextFormattingRule(key: .foregroundColor, value: UIColor.systemGray, group: 3)
                ]
            ),
            
            // ==highlight==  → same as ::…::
            HighlightRule(
                pattern: doubleEqualHighlightRegex,
                formattingRules: [
                    TextFormattingRule(key: .backgroundColor, value: highlightBackgroundColor.withAlphaComponent(0.8), group: 0),
//                    TextFormattingRule(key: .font,          value: codeFont,      group: 1),
                    TextFormattingRule(key: .foregroundColor, value: UIColor.systemGray, group: 1),
                    TextFormattingRule(key: .foregroundColor, value: highlightForegroundColor, group: 2),
//                    TextFormattingRule(key: .font,          value: codeFont,      group: 3),
                    TextFormattingRule(key: .foregroundColor, value: UIColor.systemGray, group: 3)
                ]
            ),
            
            // Money: $cash, $12, $12.34, €23, €23,245 → cashTagColor + semibold‐monospace
            HighlightRule(
                pattern: moneyRegex,
                formattingRules: [
                    TextFormattingRule(key: .foregroundColor, value: cashTagColor, group: 0),
                    TextFormattingRule(key: .font,
                                       value: SystemFontAlias.monospacedSystemFont(
                                        ofSize: defaultEditorFont.pointSize - 1.24,
                                        weight: .semibold
                                       ),
                                       group: 0
                                      )
                ]
            ),
            
            // Time HH:mm → monospace(-1.24) + timeForegroundColor
            HighlightRule(
                pattern: timeHHmmRegex,
                formattingRules: [
                    TextFormattingRule(key: .font,
                                       value: SystemFontAlias.monospacedSystemFont(
                                        ofSize: defaultEditorFont.pointSize - 1.24,
                                        weight: .semibold
                                       ),
                                       group: 1
                                      ),
                    TextFormattingRule(key: .foregroundColor, value: timeForegroundColor, group: 1)
                ]
            ),
            
            // Year YYYY → same as HH:mm
            HighlightRule(
                pattern: yearYYYYRegex,
                formattingRules: [
                    TextFormattingRule(key: .font,
                                       value: SystemFontAlias.monospacedSystemFont(
                                        ofSize: defaultEditorFont.pointSize - 1.24,
                                        weight: .semibold
                                       ),
                                       group: 1
                                      ),
                    TextFormattingRule(key: .foregroundColor, value: timeForegroundColor, group: 1)
                ]
            ),
            
            // Date MMM dd, YYYY → same as HH:mm
            HighlightRule(
                pattern: dateMMMddYYYYRegex,
                formattingRules: [
                    TextFormattingRule(key: .font,
                                       value: SystemFontAlias.monospacedSystemFont(
                                        ofSize: defaultEditorFont.pointSize - 1.24,
                                        weight: .semibold
                                       ),
                                       group: 1
                                      ),
                    TextFormattingRule(key: .foregroundColor, value: timeForegroundColor, group: 1)
                ]
            ),
            
            // Date dd/MM/YY → same as HH:mm
            HighlightRule(
                pattern: dateSlashRegex,
                formattingRules: [
                    TextFormattingRule(key: .font,
                                       value: SystemFontAlias.monospacedSystemFont(
                                        ofSize: defaultEditorFont.pointSize - 1.24,
                                        weight: .semibold
                                       ),
                                       group: 1
                                      ),
                    TextFormattingRule(key: .foregroundColor, value: timeForegroundColor, group: 1)
                ]
            ),
            
            // Date dd-MM-YY → same as HH:mm
            HighlightRule(
                pattern: dateDashRegex,
                formattingRules: [
                    TextFormattingRule(key: .font,
                                       value: SystemFontAlias.monospacedSystemFont(
                                        ofSize: defaultEditorFont.pointSize - 1.24,
                                        weight: .semibold
                                       ),
                                       group: 1
                                      ),
                    TextFormattingRule(key: .foregroundColor, value: timeForegroundColor, group: 1)
                ]
            ),
            
            // Quotes ("text") → base font + markupColor
            HighlightRule(
                pattern: quotesRegex,
                formattingRules: [
                    TextFormattingRule(key: .font, value: defaultEditorFont, group: 1),
                    TextFormattingRule(key: .foregroundColor, value: markupColor, group: 1)
                ]
            ),
            
            // Parentheses (text) → markupColor
            HighlightRule(
                pattern: parenthesesRegex,
                formattingRule: TextFormattingRule(
                    key: .foregroundColor,
                    value: markupColor,
                    group: 1
                )
            ),
            
            // Comments (//...) → commentColor + monospace(0.9×)
            HighlightRule(
                pattern: commentLineRegex,
                formattingRules: [
                    TextFormattingRule(key: .foregroundColor, value: commentColor, group: 1),
                    TextFormattingRule(key: .font,
                                       value: SystemFontAlias.monospacedSystemFont(
                                        ofSize: defaultEditorFont.pointSize * 0.9,
                                        weight: .medium
                                       ),
                                       group: 1
                                      )
                ]
            ),
    
            
            // …remaining rules…
            //
            
//            HighlightRule(
//                pattern: linkOrImageRegex,
//                formattingRule: TextFormattingRule(key: .underlineStyle, value: NSUnderlineStyle.single.rawValue)
//            ),
//            HighlightRule(
//                pattern: linkOrImageTagRegex,
//                formattingRule: TextFormattingRule(key: .underlineStyle, value: NSUnderlineStyle.single.rawValue)
//            ),
//            HighlightRule(pattern: boldRegex, formattingRule: TextFormattingRule(fontTraits: boldTraits)),
            // 1. Regex with three capture‐groups: open "**", inner text, close "**"
            
            // 2. Build HighlightRule with three TextFormattingRules, each pointing at a group:
            
//            HighlightRule(
//                pattern: asteriskEmphasisRegex,
//                formattingRule: TextFormattingRule(fontTraits: emphasisTraits)
//            ),
//            HighlightRule(
//                pattern: underscoreEmphasisRegex,
//                formattingRule: TextFormattingRule(fontTraits: emphasisTraits)
//            ),
//            HighlightRule(
//                pattern: boldEmphasisAsteriskRegex,
//                formattingRule: TextFormattingRule(fontTraits: boldEmphasisTraits)
//            ),
            HighlightRule(
                pattern: blockquoteRegex,
                formattingRule: TextFormattingRule(key: .backgroundColor, value: secondaryBackground)
            )
//            HighlightRule(
//                pattern: horizontalRuleRegex,
//                formattingRule: TextFormattingRule(key: .foregroundColor, value: lighterColor)
//            ),
//            HighlightRule(
//                pattern: unorderedListRegex,
//                formattingRule: TextFormattingRule(key: .foregroundColor, value: lighterColor)
//            ),
//            HighlightRule(
//                pattern: orderedListRegex,
//                formattingRule: TextFormattingRule(key: .foregroundColor, value: lighterColor)
//            ),
//            HighlightRule(
//                pattern: buttonRegex,
//                formattingRule: TextFormattingRule(key: .foregroundColor, value: lighterColor)
//            ),
//            HighlightRule(pattern: strikethroughRegex, formattingRules: [
//                TextFormattingRule(key: .strikethroughStyle, value: NSUnderlineStyle.single.rawValue),
//                TextFormattingRule(key: .strikethroughColor, value: textColor)
//            ]),
//            HighlightRule(
//                pattern: tagRegex,
//                formattingRule: TextFormattingRule(key: .foregroundColor, value: lighterColor)
//            ),
//            HighlightRule(
//                pattern: footnoteRegex,
//                formattingRule: TextFormattingRule(key: .foregroundColor, value: lighterColor)
//            ),
//            HighlightRule(pattern: htmlRegex, formattingRules: [
//                TextFormattingRule(key: .font, value: codeFont),
//                TextFormattingRule(key: .foregroundColor, value: lighterColor)
//            ])
        ]
    }
}



extension UIColor {
    convenience init(hex: String) {
        let hexSanitized = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hexSanitized).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hexSanitized.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
}

