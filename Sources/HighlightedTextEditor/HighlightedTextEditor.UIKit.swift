#if os(iOS)
//
//  HighlightedTextEditor.UIKit.swift
//
//
//  Created by Kyle Nazario on 5/26/21.
//

import SwiftUI
import UIKit

public struct HighlightedTextEditor: UIViewRepresentable, HighlightingTextEditor {
    public struct Internals {
        public let textView: SystemTextView
        public let scrollView: SystemScrollView?
    }

    @Binding var text: String {
        didSet {
            onTextChange?(text)
        }
    }

    let highlightRules: [HighlightRule]

    private(set) var onEditingChanged: OnEditingChangedCallback?
    private(set) var onCommit: OnCommitCallback?
    private(set) var onTextChange: OnTextChangeCallback?
    private(set) var onSelectionChange: OnSelectionChangeCallback?
    private(set) var introspect: IntrospectCallback?

    public init(
        text: Binding<String>,
        highlightRules: [HighlightRule]
    ) {
        _text = text
        self.highlightRules = highlightRules
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.linkTextAttributes = [
//            .foregroundColor: pinkColor,
            .underlineStyle: 0
        ]
        
        updateTextViewModifiers(textView)
        runIntrospect(textView)

        return textView
    }

    public func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.isScrollEnabled = false
        context.coordinator.updatingUIView = true

        let highlightedText = HighlightedTextEditor.getHighlightedText(
            text: text,
            highlightRules: highlightRules
        )

        if let range = uiView.markedTextNSRange {
            uiView.setAttributedMarkedText(highlightedText, selectedRange: range)
        } else {
            uiView.attributedText = highlightedText
        }
        updateTextViewModifiers(uiView)
        runIntrospect(uiView)
        uiView.isScrollEnabled = true
        uiView.selectedTextRange = context.coordinator.selectedTextRange
        context.coordinator.updatingUIView = false
    }

    private func runIntrospect(_ textView: UITextView) {
        guard let introspect = introspect else { return }
        let internals = Internals(textView: textView, scrollView: nil)
        introspect(internals)
    }

    private func updateTextViewModifiers(_ textView: UITextView) {
        // BUGFIX #19: https://stackoverflow.com/questions/60537039/change-prompt-color-for-uitextfield-on-mac-catalyst
        let textInputTraits = textView.value(forKey: "textInputTraits") as? NSObject
        textInputTraits?.setValue(textView.tintColor, forKey: "insertionPointColor")
    }

    public final class Coordinator: NSObject, UITextViewDelegate {
        var parent: HighlightedTextEditor
        var selectedTextRange: UITextRange?
        var updatingUIView = false

        init(_ markdownEditorView: HighlightedTextEditor) {
            self.parent = markdownEditorView
        }

        public func textViewDidChange(_ textView: UITextView) {
            // For Multistage Text Input
            guard textView.markedTextRange == nil else { return }

            parent.text = textView.text
            selectedTextRange = textView.selectedTextRange
        }

        public func textViewDidChangeSelection(_ textView: UITextView) {
            guard let onSelectionChange = parent.onSelectionChange,
                  !updatingUIView
            else { return }
            selectedTextRange = textView.selectedTextRange
            onSelectionChange([textView.selectedRange])
        }

        public func textViewDidBeginEditing(_ textView: UITextView) {
            parent.onEditingChanged?()
        }

        public func textViewDidEndEditing(_ textView: UITextView) {
            parent.onCommit?()
        }
        // inside HighlightedTextEditor.UIKit.Coordinator:
        public func textView(
            _ textView: UITextView,
            shouldInteractWith url: URL,
            in characterRange: NSRange,
            interaction: UITextItemInteraction
        ) -> Bool {
            guard url.scheme == "toggle" else { return true }
            // convert NSRange→String.Index range:
            if let strRange = Range(characterRange, in: parent.text) {
                let current = parent.text[strRange]
                let replacement = (current == "□") ? "☒" : "□"
                parent.text.replaceSubrange(strRange, with: replacement)
            }
            return false
        }
//        private func textView(
//            _ textView: UITextView,
//            shouldInteractWith URL: URL,
//            in textItem: UITextItem
//        ) -> Bool {
//            // same body--e.g.:
//            if URL.scheme == "toggle" {
//                // find 1-char range around textItem.range, flip "□"⇄"☒", etc.
//                return false
//            }
//            return true
//        }
    }
}

public extension HighlightedTextEditor {
    func introspect(callback: @escaping IntrospectCallback) -> Self {
        var new = self
        new.introspect = callback
        return new
    }

    func onSelectionChange(_ callback: @escaping (_ selectedRange: NSRange) -> Void) -> Self {
        var new = self
        new.onSelectionChange = { ranges in
            guard let range = ranges.first else { return }
            callback(range)
        }
        return new
    }

    func onCommit(_ callback: @escaping OnCommitCallback) -> Self {
        var new = self
        new.onCommit = callback
        return new
    }

    func onEditingChanged(_ callback: @escaping OnEditingChangedCallback) -> Self {
        var new = self
        new.onEditingChanged = callback
        return new
    }

    func onTextChange(_ callback: @escaping OnTextChangeCallback) -> Self {
        var new = self
        new.onTextChange = callback
        return new
    }
}
#endif
