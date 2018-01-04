//
//  SimpleStemmer.swift
//  EmojiWorkshop
//
//  Created by John Pavley on 1/3/18.
//  Copyright © 2018 Epic Loot. All rights reserved.
//

import Foundation

class SimpleStemmer {
    
    let stemMap: [String: String]
    
    init(stemMap: [String: String]) {
        self.stemMap = stemMap
    }
    
    func getStem(for term: String) -> String? {
        return stemMap[term]
    }
    
}
