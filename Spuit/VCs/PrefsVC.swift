//
//  PrefsVC.swift
//  Spuit
//
//  Created by mc309 on 9/20/21.
//

import Cocoa
import Preferences
import SnapKit
import LaunchAtLogin
import DSFToggleButton
import KeyboardShortcuts
import Defaults

enum ColorFormat: Int, CaseIterable, Defaults.Serializable {
    case swift_UIColor = 0
    case swift_NSColor
//    case objc_UIColor
//    case objc_NSColor
    
    var string: String {
        switch self {
        case .swift_UIColor:
            return "Swift - UIColor"
        case .swift_NSColor:
            return "Swift - NSColor"
//        case .objc_UIColor:
//            return "Objective-C - UIColor"
//        case .objc_NSColor:
//            return "Objective-C - NSColor"
        }
    }
}

enum ColorHistorySize: Int, CaseIterable, Defaults.Serializable {
    case ten = 10
    case twenty = 20
    case thirty = 30
    case forty = 40
    case fifty = 50
    
    var string: String {
        switch self {
        case .ten:
            return "10"
        case .twenty:
            return "20"
        case .thirty:
            return "30"
        case .forty:
            return "40"
        case .fifty:
            return "50"
        }
    }
}

extension Defaults.Keys {
    static let selectedFormat = Key<ColorFormat>("ColorFormat", default: .swift_UIColor)
    static let selectedHistorySize = Key<ColorHistorySize>("ColorHistorySize", default: .ten)
}

extension Preferences.PaneIdentifier {
    static let general = Self("general")
}

class PrefsVC: NSViewController, PreferencePane {
    
    let preferencePaneIdentifier = Preferences.PaneIdentifier.general
    let preferencePaneTitle = "General"
    let toolbarItemIcon = NSImage(systemSymbolName: "gearshape", accessibilityDescription: "General preferences")!
    
    lazy var behaviorTitle: NSLabel = {
        let v = NSLabel()
        v.font = NSFont.boldSystemFont(ofSize: 14)
        v.stringValue = "Behavior"
        v.textColor = .black
        return v
    }()
    
    lazy var launchAtLoginButton: DSFToggleButton = {
        let v = DSFToggleButton()
        if LaunchAtLogin.isEnabled == true {
            v.state = .on
        } else {
            v.state = .off
        }
        return v
    }()
    
    lazy var launchAtLoginTitle: NSLabel = {
        let v = NSLabel()
        v.font = NSFont.systemFont(ofSize: 12)
        v.stringValue = "Launch at login"
        v.textColor = .black
        return v
    }()
    
    
    lazy var historyTitle: NSLabel = {
        let v = NSLabel()
        v.font = NSFont.boldSystemFont(ofSize: 14)
        v.stringValue = "Color History"
        v.textColor = .black
        return v
    }()
    
    lazy var historyDesc: NSLabel = {
        let v = NSLabel()
        v.font = NSFont.systemFont(ofSize: 12)
        v.stringValue = "Max color history size"
        v.textColor = .black
        return v
    }()
    
    lazy var historiesButton: NSPopUpButton = {
        let v = NSPopUpButton()
        v.pullsDown = true
        for value in ColorHistorySize.allCases {
            v.addItem(withTitle: String(value.rawValue))
        }
        return v
    }()
    
    lazy var formatsTitle: NSLabel = {
        let v = NSLabel()
        v.font = NSFont.boldSystemFont(ofSize: 14)
        v.stringValue = "ColorFormat"
        v.textColor = .black
        return v
    }()
    
    lazy var formatsDesc: NSLabel = {
        let v = NSLabel()
        v.font = NSFont.systemFont(ofSize: 12)
        v.stringValue = ""
        v.textColor = .black
        return v
    }()
    
    lazy var formatsButton: NSPopUpButton = {
        let v = NSPopUpButton()
        v.pullsDown = true
        let selectedFormat = Defaults[.selectedFormat]
        v.title = selectedFormat.string
        v.addItem(withTitle: selectedFormat.string)
        for format in ColorFormat.allCases {
            if format.string != selectedFormat.string {
                v.addItem(withTitle: format.string)
            }
        }
        return v
    }()
    
    lazy var shortcutTitle: NSLabel = {
        let v = NSLabel()
        v.font = NSFont.boldSystemFont(ofSize: 14)
        v.stringValue = "Shortcut"
        v.textColor = .black
        return v
    }()
    
    lazy var shortcutDesc: NSLabel = {
        let v = NSLabel()
        v.font = NSFont.systemFont(ofSize: 12)
        v.stringValue = ""
        v.textColor = .black
        return v
    }()
    
    lazy var shortcutRecorderView: NSSearchField = {
        let v = KeyboardShortcuts.RecorderCocoa(for: .spuitShortcut)
        return v
    }()
    
    override func loadView() {
        view = NSView()
        view.snp.makeConstraints { make in
            make.width.equalTo(230)
        }
        
        view.addSubview(behaviorTitle)
        view.addSubview(launchAtLoginButton)
        view.addSubview(launchAtLoginTitle)
        
        view.addSubview(historyTitle)
        view.addSubview(historyDesc)
        view.addSubview(historiesButton)
        
        view.addSubview(formatsTitle)
        view.addSubview(formatsDesc)
        view.addSubview(formatsButton)
       
        view.addSubview(shortcutTitle)
        view.addSubview(shortcutDesc)
        view.addSubview(shortcutRecorderView)
        
        behaviorTitle.snp.makeConstraints { make in
            make.top.equalTo(view).offset(20)
            make.left.equalTo(view).offset(20)
        }
        
        launchAtLoginTitle.snp.makeConstraints { make in
            make.top.equalTo(behaviorTitle.snp.bottom).offset(5)
            make.left.equalTo(behaviorTitle)
        }
        
        launchAtLoginButton.snp.makeConstraints { make in
            make.top.equalTo(launchAtLoginTitle)
            make.right.equalTo(view.snp.right).offset(-20)
        }
        
        
        historyTitle.snp.makeConstraints { make in
            make.top.equalTo(launchAtLoginTitle.snp.bottom).offset(20)
            make.left.equalTo(behaviorTitle)
        }
        
        historyDesc.snp.makeConstraints { make in
            make.top.equalTo(historyTitle.snp.bottom).offset(5)
            make.left.equalTo(behaviorTitle)
        }
        
        historiesButton.snp.makeConstraints { make in
            make.top.equalTo(historyDesc)
            make.right.equalTo(view.snp.right).offset(-20)
        }
        
        formatsTitle.snp.makeConstraints { make in
            make.top.equalTo(historyDesc.snp.bottom).offset(20)
            make.left.equalTo(behaviorTitle)
        }
        
        formatsDesc.snp.makeConstraints { make in
            make.top.equalTo(formatsTitle.snp.bottom).offset(5)
            make.left.equalTo(behaviorTitle)
        }
        
        formatsButton.snp.makeConstraints { make in
            make.top.equalTo(formatsTitle.snp.bottom).offset(5)
            make.right.equalTo(view).offset(-20)
        }
        
        
        shortcutTitle.snp.makeConstraints { make in
            make.top.equalTo(formatsButton.snp.bottom).offset(20)
            make.left.equalTo(behaviorTitle)
        }
        
        shortcutDesc.snp.makeConstraints { make in
            make.top.equalTo(shortcutTitle.snp.bottom).offset(5)
            make.left.equalTo(behaviorTitle)
        }
        
        shortcutRecorderView.snp.makeConstraints { make in
            make.top.equalTo(shortcutTitle.snp.bottom).offset(5)
            make.right.equalTo(view).offset(-20)
            make.bottom.equalTo(view).offset(-20)
        }
        
        launchAtLoginButton.target = self
        launchAtLoginButton.action = #selector(launchAtLoginPressed(button:))
        
        formatsButton.target = self
        formatsButton.action = #selector(formatButtonPressed(button:))
        
        historiesButton.target = self
        historiesButton.action = #selector(historyButtonPressed(button:))
    }
    
    @objc func launchAtLoginPressed(button: DSFToggleButton) {
        LaunchAtLogin.isEnabled = button.isEnabled
    }
    
    @objc func formatButtonPressed(button: NSPopUpButton) {
        var selectedFormat: ColorFormat? = nil
        if let item = formatsButton.selectedItem {
            for format in ColorFormat.allCases {
                if format.string == item.title {
                    selectedFormat = format
                }
            }
        }
        formatsButton.removeAllItems()
        if let selectedFormat = selectedFormat {
            formatsButton.title = selectedFormat.string
            formatsButton.addItem(withTitle: selectedFormat.string)
            for format in ColorFormat.allCases {
                if format.string != selectedFormat.string {
                    formatsButton.addItem(withTitle: format.string)
                }
            }
            Defaults[.selectedFormat] = selectedFormat
        }
    }
    
    @objc func historyButtonPressed(button: NSPopUpButton) {
        var selectedHistory: ColorHistorySize? = nil
        if let item = historiesButton.selectedItem {
            for history in ColorHistorySize.allCases {
                if history.string == item.title {
                    selectedHistory = history 
                }
            }
        }
        historiesButton.removeAllItems()
        if let selectedHistory = selectedHistory {
            historiesButton.title = selectedHistory.string
            historiesButton.addItem(withTitle: selectedHistory.string)
            for format in ColorHistorySize.allCases {
                if format.string != selectedHistory.string {
                    historiesButton.addItem(withTitle: format.string)
                }
            }
            Defaults[.selectedHistorySize] = selectedHistory
        }
    }
    
}
