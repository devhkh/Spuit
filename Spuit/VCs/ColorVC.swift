//
//  ColorVC.swift
//  Spuit
//
//  Created by mc309 on 12/27/21.
//

import Cocoa
import SnapKit

class ColorVC: NSViewController {
    
    deinit {
        print("deinit - " + theClassName)
    }
    
    var colorName: String = "" {
        didSet {
            colorNameLabel.stringValue = colorName
        }
    }
    var colorFormat: ColorFormat = .swift_NSColor {
        didSet {
            switch colorFormat {
            case .swift_UIColor:
                colorFormatImageView.image = NSImage(named: "icn_ios")
            case .swift_NSColor:
                colorFormatImageView.image = NSImage(named: "icn_macos")
            case .dart:
                colorFormatImageView.image = NSImage(named: "icn_dart")
            }
        }
    }
    
    lazy var colorNameLabel: NSLabel = {
        let v = NSLabel()
        v.textColor = .black
        v.font = NSFont.systemFont(ofSize: 14)
        v.lineBreakMode = .byTruncatingTail
        return v
    }()
    
    lazy var colorFormatImageView: NSImageView = {
        let v = NSImageView()
        return v
    }()
    
    override func loadView() {
        view = NSView()
        view.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        view.addSubview(colorFormatImageView)
        view.addSubview(colorNameLabel)
        
        colorFormatImageView.snp.makeConstraints { make in
            make.centerY.equalTo(view)
            make.left.equalTo(view).offset(10)
            make.size.equalTo(30)
        }
        
        colorNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(view)
            make.left.equalTo(colorFormatImageView.snp.right).offset(5)
            make.right.equalTo(view).inset(10)
        }
        
        view.bgColor = NSColor(red: 1.00, green: 1.00, blue:1.00, alpha: 1.00)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
    }
}



