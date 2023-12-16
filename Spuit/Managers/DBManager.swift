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
    
    func getColorName(color: NSColor) -> (String, String) {
        let decVal = UInt64(strtoul(color.hexString, nil, 16))
        var colorName: String = "none"
        do {
            let query1 = "SELECT name FROM colorNames WHERE hexColor = '\(color.hexString)' ORDER BY dec DESC limit 1"
            for row in try db.prepare(query1) {
                if let row = row[0] {
                    colorName = String(describing: row)
                }
            }
            
            if colorName == "none" {
                let query2 = "SELECT name FROM colorNames WHERE dec = \(decVal) ORDER BY dec DESC limit 1"
                for row in try db.prepare(query2) {
                    if let row = row[0] {
                        colorName = String(describing: row)
                    }
                }
            }
            
            if colorName == "none" {
                let query3 = "SELECT name, dec, ABS(dec-\(decVal)) AS dec FROM colorNames ORDER BY dec ASC limit 1"
                for row in try db.prepare(query3) {
                    if let row = row[0] {
                        colorName = String(describing: row)
                    }
                }
            }
            print("color.hexString : \(color.hexString)")
            print("decVal : \(decVal)")
            print("colorName : \(colorName)")
            
            let newColorName = matchString(_string: colorName)
            return (newColorName, color.hexString)
            
        } catch {
            return (colorName, color.hexString)
        }
    }
    
    func matchString (_string : String) -> String { // 문자열 변경 실시
        let strArr = Array(_string) // 문자열 한글자씩 확인을 위해 배열에 담는다
        
        let pattern = "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9]$" // 정규식 : 한글, 영어, 숫자만 허용 (공백, 특수문자 제거)
        //let pattern = "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9\\s]$" // 정규식 : 한글, 영어, 숫자, 공백만 허용 (특수문자 제거)
        
        // 문자열 길이가 한개 이상인 경우만 패턴 검사 수행
        var resultString = ""
        if strArr.count > 0 {
            if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
                var index = 0
                while index < strArr.count { // string 문자 하나 마다 개별 정규식 체크
                    let checkString = regex.matches(in: String(strArr[index]), options: [], range: NSRange(location: 0, length: 1))
                    if checkString.count == 0 {
                        index += 1 // 정규식 패턴 외의 문자가 포함된 경우
                    }
                    else { // 정규식 포함 패턴의 문자
                        resultString += String(strArr[index]) // 리턴 문자열에 추가
                        index += 1
                    }
                }
            }
            return resultString
        }
        else {
            return _string // 원본 문자 다시 리턴
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
