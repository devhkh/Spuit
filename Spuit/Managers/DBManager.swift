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
            let query = "SELECT name FROM colorNames WHERE dec = \(decVal) ORDER BY dec DESC limit 1"
            for row in try db.prepare(query) {
                if let row = row[0] {
                    colorName = String(describing: row)
                }
            }
            if colorName == "none" {
                let query2 = "SELECT name, dec, ABS(dec-'\(decVal)') AS dec FROM colorNames ORDER BY dec DESC limit 1"
                for row in try db.prepare(query2) {
                    if let row = row[0] {
                        colorName = String(describing: row)
                    }
                }
            }
            print("color.hexString : \(color.hexString)")
            print("decVal : \(decVal)")
            print("colorName : \(colorName)")
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
