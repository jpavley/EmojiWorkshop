//
//  SimpleSubstituter.swift
//  Emoji Spy
//
//  Created by John Pavley on 1/14/18.
//  Copyright © 2018 Epic Loot. All rights reserved.
//

import Foundation

class SimpleSubstituter {
    
    var substituteMap = [String: String]()
    
    init(substituteMap: [String: String]) {
        self.substituteMap = substituteMap
    }
    
    init?(sourceFileName: String) {
        
        if let txtPath = Bundle.main.path(forResource: sourceFileName, ofType: "txt") {
            do {
                
                let substituteText = try String(contentsOfFile: txtPath, encoding: .utf8)
                let substituteLines = substituteText.split(separator: "\n")
                
                for line in substituteLines {
                    
                    if line.contains(":") {
                        
                        // text before ":" is key, text after ":" is value
                        let parts = line.split(separator: ":")
                        let key = String(parts[0])
                        
                        // if there is only a key, as in the case of stop words
                        // then supply an empty string as the value
                        let val = parts.count > 1 ? String(parts[1]) : ""
                        substituteMap[key] = val
                    }
                }
            } catch {
                
                print("file not found")
                return nil
            }
        }
    }
    
    
    func getSubstitutes(for term: String) -> [String]? {
        
        let initialResult = substituteMap[term.lowercased()]?.lowercased()
        let finalResult = initialResult?.components(separatedBy: " ")
        return finalResult
    }
    
}
