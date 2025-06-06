//
//  HighlightingTextEditor.swift
//
//
//  Created by Kyle Nazario on 8/31/20.
//

import SwiftUI

#if os(macOS)
import AppKit

public typealias SystemFontAlias = NSFont
public typealias SystemColorAlias = NSColor
public typealias SymbolicTraits = NSFontDescriptor.SymbolicTraits
public typealias SystemTextView = NSTextView
public typealias SystemScrollView = NSScrollView

let defaultEditorFont = NSFont.systemFont(ofSize: NSFont.systemFontSize)
let defaultEditorTextColor = NSColor.labelColor

#else
import UIKit

public typealias SystemFontAlias = UIFont
public typealias SystemColorAlias = UIColor
public typealias SymbolicTraits = UIFontDescriptor.SymbolicTraits
public typealias SystemTextView = UITextView
public typealias SystemScrollView = UIScrollView

let defaultEditorFont = UIFont.preferredFont(forTextStyle: .body)
let defaultEditorTextColor = UIColor.label

#endif

public struct TextFormattingRule {
    public typealias AttributedKeyCallback = (String, Range<String.Index>) -> Any
    
    let key: NSAttributedString.Key?
    let calculateValue: AttributedKeyCallback?
    let fontTraits: SymbolicTraits
    let group: Int?           // ← new: which capture group to style (nil = entire match)
    
    public init(
        key: NSAttributedString.Key,
        value: Any,
        group: Int? = nil
    ) {
        self.key = key; self.calculateValue = { _,_ in value }
        self.fontTraits = []
        self.group = group
    }
    
    public init(
        key: NSAttributedString.Key,
        calculateValue: @escaping AttributedKeyCallback,
        group: Int? = nil
    ) {
        self.key = key; self.calculateValue = calculateValue
        self.fontTraits = []
        self.group = group
    }
    
    public init(
        fontTraits: SymbolicTraits,
        group: Int? = nil
    ) {
        self.key = nil; self.calculateValue = nil
        self.fontTraits = fontTraits
        self.group = group
    }
    
    init(
        key: NSAttributedString.Key? = nil,
        calculateValue: AttributedKeyCallback? = nil,
        fontTraits: SymbolicTraits = [],
        group: Int? = nil
    ) {
        self.key = key
        self.calculateValue = calculateValue
        self.fontTraits = fontTraits
        self.group = group
    }
}

public struct HighlightRule {
    let pattern: NSRegularExpression

    let formattingRules: [TextFormattingRule]

    // ------------------- convenience ------------------------

    public init(pattern: NSRegularExpression, formattingRule: TextFormattingRule) {
        self.init(pattern: pattern, formattingRules: [formattingRule])
    }

    // ------------------ most powerful initializer ------------------

    public init(pattern: NSRegularExpression, formattingRules: [TextFormattingRule]) {
        self.pattern = pattern
        self.formattingRules = formattingRules
    }
}

internal protocol HighlightingTextEditor {
    var text: String { get set }
    var highlightRules: [HighlightRule] { get }
}

public typealias OnSelectionChangeCallback = ([NSRange]) -> Void
public typealias IntrospectCallback = (_ editor: HighlightedTextEditor.Internals) -> Void
public typealias EmptyCallback = () -> Void
public typealias OnCommitCallback = EmptyCallback
public typealias OnEditingChangedCallback = EmptyCallback
public typealias OnTextChangeCallback = (_ editorContent: String) -> Void

extension HighlightingTextEditor {
    static func getHighlightedText(
        text: String,
        highlightRules: [HighlightRule]
    ) -> NSMutableAttributedString {
        let highlighted = NSMutableAttributedString(string: text)
        let all = NSRange(location: 0, length: text.utf16.count)
        
        let editorFont = defaultEditorFont
        let editorTextColor = defaultEditorTextColor
        highlighted.addAttribute(.font, value: editorFont, range: all)
        highlighted.addAttribute(.foregroundColor, value: editorTextColor, range: all)
        
        highlightRules.forEach { rule in
            let matches = rule.pattern.matches(in: text, options: [], range: all)
            matches.forEach { match in
                rule.formattingRules.forEach { fr in
                    // determine which range to style:
                    let targetRange: NSRange = {
                        if let g = fr.group {
                            return match.range(at: g)
                        } else {
                            return match.range
                        }
                    }()
                    
                    // 1) apply fontTraits if any:
                    if fr.fontTraits.isEmpty == false {
                        // grab existing font at start of targetRange:
                        let prevFont = highlighted
                            .attribute(.font, at: targetRange.location, effectiveRange: nil)
                        as! SystemFontAlias
                        let newDesc = prevFont.fontDescriptor
                            .withSymbolicTraits(fr.fontTraits)
                        let newFont = SystemFontAlias(
                            descriptor: newDesc ?? prevFont.fontDescriptor,
                            size: prevFont.pointSize
                        )
                        highlighted.addAttribute(.font, value: newFont, range: targetRange)
                    }
                    
                    // 2) apply key/value or callback if provided:
                    if let key = fr.key, let callback = fr.calculateValue {
                        let subRange = Range<String.Index>(targetRange, in: text)!
                        let substr = String(text[subRange])
                        let value = callback(substr, subRange)
                        highlighted.addAttribute(key, value: value, range: targetRange)
                    }
                }
            }
        }
        return highlighted
    }
}
