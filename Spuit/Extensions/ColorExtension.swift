//
//  ColorExtension.swift
//  Spuit
//
//  Created by mc309 on 9/16/21.
//

import Cocoa

extension NSColor {
    @nonobjc class var blackAlpha0_5: NSColor { return NSColor(red:0, green:0, blue:0, alpha:0.8) }

    var hexString: String {
        let red = Int(round(self.redComponent * 0xFF))
        let green = Int(round(self.greenComponent * 0xFF))
        let blue = Int(round(self.blueComponent * 0xFF))
        let hexString = NSString(format: "%02X%02X%02X", red, green, blue)
        return hexString as String
    }
    
    
}
