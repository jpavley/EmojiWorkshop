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
    
    /// Emoji groups and subgroups are not well named and/or are overbroad.
    /// When creating tags from group and subgroup name hundreds of emoji
    /// are inproperly tagged. Smileys are also tagged people and people are
    /// are also tagged smileys. Plants are tagged animals. Foods are tagged
    /// drinks and drinks are tagged food. Places and Travel are also
    /// interchangably tagged.
    func tagAdjustment() {
        
    }
}
