//
//  DBManager.swift
//  Spuit
//
//  Created by mc309 on 9/16/21.
//

import Cocoa
import SQLite

class DBManager: NSObject {

    static let SI = DBManager()
    var db: Connection!
    override init() {
        super.init()
        do {
            let docsPath = Bundle.main.resourcePath! + "/db.sqlite"
            print(docsPath)
            db = try Connection(docsPath)
        } catch {
            
        }
    }
    
    func initialize() {
        
    }
    
    func getColorName(color: NSColor) -> (String) {
        let decVal = UInt64(strtoul(color.hexString, nil, 16))
        var colorName: String = "none"
        do {
            for row in try db.prepare("SELECT name from colorNames where dec <= \(decVal) order by dec desc limit 1") {
                if let row = row[0] {
                    colorName = String(describing: row)
                }
            }
            return (colorName)
            
        } catch {
            return (colorName)
        }
    }
    
    func addHistoryColor(colorName: String, r: String, g: String, b: String, a: String, formatType: Int) {
        let historyColors = Table("historyColors")
        let colorNameCol = Expression<String>("colorName")
        let rCol = Expression<String>("r")
        let gCol = Expression<String>("g")
        let bCol = Expression<String>("b")
        let aCol = Expression<String>("a")
        let formatTypeCol = Expression<Int>("formatType")
        
        let historyColorsQuery = historyColors.filter(colorNameCol == colorName)
        do {
            try db.run(historyColorsQuery.delete())
        } catch {
            print(error)
        }
        
        let insert = historyColors.insert(colorNameCol <- colorName, rCol <- r, gCol <- g, bCol <- b, aCol <- a, formatTypeCol <- formatType)
        do {
            let rowId = try db.run(insert)
            print(insert)
            print(rowId)
        } catch {
            print(error)
        }
    }
    
    
    
}
