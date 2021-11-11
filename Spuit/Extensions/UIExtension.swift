//
//  UIExtension.swift
//  Spuit
//
//  Created by mc309 on 9/16/21.
//

import Cocoa

class NSLabel: NSTextField {
    
    convenience init() {
        self.init(frame: .zero)
        self.textColor = .white
        self.isEditable = false
        self.isBordered = false
        self.isSelectable = false
        self.alignment = .left
        self.backgroundColor = .clear
    }
    
    var lineNumber: Int = 1 {
        didSet {
            self.maximumNumberOfLines = lineNumber
            self.cell?.usesSingleLineMode = false
            self.cell?.truncatesLastVisibleLine = true
        }
    }
    
}

extension NSView {
    
    func setCornerRadius(_ radius: CGFloat) {
        self.wantsLayer = true
        self.layer?.cornerRadius = radius
    }
    
    func setBorder(width: CGFloat, color: NSColor) {
        self.wantsLayer = true
        self.layer?.masksToBounds = true
        self.layer?.borderWidth = width
        self.layer?.borderColor = color.cgColor
    }
    
    var bgColor: NSColor {
        get {
            self.wantsLayer = true
            if let bg = self.layer?.backgroundColor {
                return NSColor(cgColor: bg) ?? .clear
            } else {
                return .clear
            }
        }
        set (newValue) {
            self.wantsLayer = true
            self.layer?.backgroundColor = newValue.cgColor
        }
    }
    
}
