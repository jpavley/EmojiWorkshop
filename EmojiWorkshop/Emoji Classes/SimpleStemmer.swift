//
//  SimpleStemmer.swift
//  EmojiWorkshop
//
//  Created by John Pavley on 1/3/18.
//  Copyright © 2018 Epic Loot. All rights reserved.
//

import Foundation

class SimpleStemmer {
    
    var stemMap = [String: String]()
    
    init(stemMap: [String: String]) {
        self.stemMap = stemMap
    }
    
    init?(sourceFileName: String) {
        
        if let txtPath = Bundle.main.path(forResource: sourceFileName, ofType: "txt") {
            do {
                
                let stemText = try String(contentsOfFile: txtPath, encoding: .utf8)
                let stemLines = stemText.split(separator: "\n")
                
                for line in stemLines {
                    
                    if line.contains(":") {
                        // text before ":" is key, text after ":" is value
                        let parts = line.split(separator: ":")
                        
                        let key = String(parts[0])
                        let val = String(parts[1])
                        
                        stemMap[key] = val
                    }
                }
            } catch {
                
                print("file not found")
                return nil
            }
        }
    }

    
    func getStem(for term: String) -> String? {
        return stemMap[term.lowercased()]
    }
    
}
