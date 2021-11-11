//
//  AppDelegate.swift
//  Spuit
//
//  Created by mc309 on 9/16/21.
//

import Cocoa
import KeyboardShortcuts
import Preferences
import Defaults
import SQLite

extension KeyboardShortcuts.Name {
    static let spuitShortcut = Self("spuitShortcut")
}

extension StringProtocol {
    var firstLowercased: String { return prefix(1).lowercased() + dropFirst() }
}

class AppDelegate: NSObject, NSApplicationDelegate {

    var windowController: NSWindowController!
    var statusItem: NSStatusItem!
    
    let historyMenu = NSMenu(title: "History")
    
    private lazy var preferencesWindowController = PreferencesWindowController(
        preferencePanes: [
            PrefsVC(),
        ]
    )
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        if #available(OSX 10.14, *) {
            NSApp.appearance = NSAppearance(named: .vibrantLight)
        } else {
            // Fallback on earlier versions
        }
        
        DBManager.SI.initialize()
        
        let window: NSWindow = NSWindow(contentRect: .zero, styleMask: [], backing: .buffered, defer: false)
        windowController = NSWindowController(window: window)
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        let itemImage = NSImage(named: "statusbar_icon")
        itemImage?.isTemplate = true
        
        statusItem.menu = NSMenu()
        statusItem.menu?.addItem(withTitle: "Spuit!", action: #selector(spuit), keyEquivalent: "")
        statusItem.menu?.addItem(NSMenuItem.separator())
        let historyMenuItem = NSMenuItem(title: "History", action: nil, keyEquivalent: "")
        statusItem.menu?.addItem(historyMenuItem)
        historyMenuItem.submenu = historyMenu
        statusItem.menu?.addItem(withTitle: "Preferences...", action: #selector(preferences), keyEquivalent: ",")
        statusItem.menu?.addItem(NSMenuItem.separator())
        statusItem.menu?.addItem(withTitle: "Quit Spuit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        statusItem.button?.image = itemImage
        getHistory()
        
        KeyboardShortcuts.onKeyUp(for: .spuitShortcut) {
            self.spuit()
        }
        windowController.showWindow(self)
    }
    
    @objc func spuit() {
        let colorSampler = NSColorSampler()
        colorSampler.show { selectedColor in
            guard let c = selectedColor else { return }
            let colorName = DBManager.SI.getColorName(color: c)
            let r = String(format: "%.2f", c.redComponent)
            let g = String(format: "%.2f", c.greenComponent)
            let b = String(format: "%.2f", c.blueComponent)
            let a = String(format: "%.2f", c.alphaComponent)
            self.addColor(colorName: colorName, r: r, g: g, b: b, a: a, isAddHistory: true)
        }
    }
    
    func addColor(colorName: String, r: String, g: String, b: String, a: String, isAddHistory: Bool) {
        var cName = String(colorName.filter { !" \n\t\r".contains($0) })
        cName = cName.firstLowercased
        
        var codeString = ""
        switch Defaults[.selectedFormat] {
        case .swift_NSColor:
            codeString = "@nonobjc class var \(cName): NSColor { return NSColor(red: \(r), green: \(g), blue:\(b), alpha: \(a)) }"
        case .swift_UIColor:
            codeString = "@nonobjc class var \(cName): NSColor { return UIColor(red: \(r), green: \(g), blue:\(b), alpha: \(a)) }"
        }
        
        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()
        pasteBoard.setString(codeString, forType: .string)
        
        if isAddHistory == true {
            let format = Defaults[.selectedFormat]
            DBManager.SI.addHistoryColor(colorName: colorName, r: r, g: g, b: b, a: a, formatType: format.rawValue)
            self.getHistory()
        }
    }
    
    @objc func getHistory() {
        historyMenu.removeAllItems()
        
        let historyColors = Table("historyColors")
        let colorName = Expression<String>("colorName")
        let index = Expression<Int>("index")
//        let r = Expression<String>("r")
//        let g = Expression<String>("g")
//        let b = Expression<String>("b")
//        let a = Expression<String>("a")
        let formatType = Expression<Int>("formatType")
        do {
            for historyColor in try DBManager.SI.db.prepare(historyColors) {
                let item = NSMenuItem()
                let format = Formats.init(rawValue: historyColor[formatType])!
                switch format {
                case .swift_UIColor:
                    item.image = NSImage(named: "icn_ios")
                case .swift_NSColor:
                    item.image = NSImage(named: "icn_macos")
                }
                let title = "\(historyColor[colorName])"
                item.tag = historyColor[index]
                item.title = title
                item.target = self
                item.action = #selector(selectedHistoryColor(item:))
                historyMenu.addItem(item)
            }
        } catch {
            print(error)
        }
    }
    
    @objc func selectedHistoryColor(item: NSMenuItem) {
        print(item.tag)
        let historyColors = Table("historyColors")
        let colorName = Expression<String>("colorName")
        let index = Expression<Int>("index")
        let r = Expression<String>("r")
        let g = Expression<String>("g")
        let b = Expression<String>("b")
        let a = Expression<String>("a")
        let historyColorsQuery = historyColors.where(index == item.tag)
        do {
            for historyColor in try DBManager.SI.db.prepare(historyColorsQuery) {
                addColor(colorName: historyColor[colorName],
                         r: historyColor[r],
                         g: historyColor[g],
                         b: historyColor[b],
                         a: historyColor[a],
                         isAddHistory: false)
            }
        } catch {
            print(error)
        }
    }
    
    @objc func preferences() {
        preferencesWindowController.show()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

