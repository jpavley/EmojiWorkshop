//
//  SimpleTagger.swift
//  Emoji Spy
//
//  Created by John Pavley on 1/15/18.
//  Copyright © 2018 Epic Loot. All rights reserved.
//

import Foundation

class SimpleTagger: SimpleSubstituter {
    
    init(tagMap: [Int: String]) {
        
        var subMap = [String: String]()
        
        for (key, val) in tagMap {
            subMap["\(key)"] = val
        }
        
        super.init(substituteMap: subMap)
    }
    
    
    override init?(sourceFileName: String = "CustomTags") {
        super.init(sourceFileName: sourceFileName)
    }
    
    func getTags(for indexNumber: Int) -> [String]? {
        let term = "\(indexNumber)"
        return super.getSubstitutes(for: term)
    }
}
