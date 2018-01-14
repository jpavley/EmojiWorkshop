//
//  SimpleSynonymer.swift
//  Emoji Spy
//
//  Created by John Pavley on 1/14/18.
//  Copyright © 2018 Epic Loot. All rights reserved.
//

import Foundation

class SimpleSynonymer {
    
    var synonymMap = [String: String]()
    
    init(synonymMap: [String: String]) {
        self.synonymMap = synonymMap
    }
    
    init?(sourceFileName: String = "EmojiSynonyms") {
        
        if let txtPath = Bundle.main.path(forResource: sourceFileName, ofType: "txt") {
            do {
                
                let synonymText = try String(contentsOfFile: txtPath, encoding: .utf8)
                let synonymLines = synonymText.split(separator: "\n")
                
                for line in synonymLines {
                    
                    if line.contains(":") {
                        // text before ":" is key, text after ":" is value
                        let parts = line.split(separator: ":")
                        let key = String(parts[0])
                        // if there is only a key, as in the case of stop words
                        // then supply an empty string as the value
                        let val = parts.count > 1 ? String(parts[1]) : ""
                        synonymMap[key] = val
                    }
                }
            } catch {
                
                print("file not found")
                return nil
            }
        }
    }
    
    
    func getSynonym(for term: String) -> String? {
        return synonymMap[term.lowercased()]
    }
    
}
