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
                        // handle multiple values
                        let values = parts.count > 1 ? String(parts[1]).split(separator: " ") : [Substring]()
                        
                        switch values.count {
                        case 1:
                            // single key
                            substituteMap[key] = String(values[0])

                        case 0:
                            // if there is only a key, as in the case of stop words
                            // then supply an empty string as the value
                            substituteMap[key] = ""
                        default:
                            // mutiple keys
                            for val in values {
                                substituteMap[key] = String(val)
                            }
                        }
                        
                        if values.count > 1 {
                            
                        }
                        substituteMap[key] = val
                    }
                }
            } catch {
                
                print("file not found")
                return nil
            }
        }
    }
    
    
    func getSubstitute(for term: String) -> String? {
        return substituteMap[term.lowercased()]
    }
    
}
