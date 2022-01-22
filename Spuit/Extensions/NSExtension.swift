//
//  NSExtension.swift
//  Spuit
//
//  Created by mc309 on 12/27/21.
//

import Cocoa

extension NSObject {
  var theClassName: String {
    return NSStringFromClass(type(of: self))
  }
}
