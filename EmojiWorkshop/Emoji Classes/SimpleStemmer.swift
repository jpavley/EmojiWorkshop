//
//  SimpleStemmer.swift
//  EmojiWorkshop
//
//  Created by John Pavley on 1/3/18.
//  Copyright © 2018 Epic Loot. All rights reserved.
//

import Foundation

class SimpleStemmer: SimpleSubstituter {
    
    init(stemMap: [String: String]) {
        super.init(substituteMap: stemMap)
    }
    
    override init?(sourceFileName: String = "EmojiStems") {
        super.init(sourceFileName: sourceFileName)
    }
    
    func getStems(for term: String) -> [String]? {
        return super.getSubstitutes(for: term)
    }
}
