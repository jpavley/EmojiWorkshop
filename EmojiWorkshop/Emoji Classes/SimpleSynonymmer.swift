//
//  SimpleSynonymer.swift
//  Emoji Spy
//
//  Created by John Pavley on 1/14/18.
//  Copyright © 2018 Epic Loot. All rights reserved.
//

import Foundation

class SimpleSynonymmer: SimpleSubstituter {
    
    init(synonymMap: [String: String]) {
        super.init(substituteMap: synonymMap)
    }

    
    override init?(sourceFileName: String = "EmojiSynonyms") {
        super.init(sourceFileName: sourceFileName)
        
        //print(super.substituteMap)
    }
    
    func getSynonym(for term: String) -> String? {
        return super.getSubstitute(for: term)
    }

}
