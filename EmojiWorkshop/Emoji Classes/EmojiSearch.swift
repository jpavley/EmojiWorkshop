//
//  EmojiSearch.swift
//  EmojiWorkshop
//
//  Created by John Pavley on 12/16/17.
//  Copyright © 2017 Epic Loot. All rights reserved.
//

import Foundation

enum EmojiFilter {
    case noFilter, byDescription, byPriority, byGroupAndSubgroup, byImage, byCharacter
}

class EmojiSearch {
    
    let prioritySignal = "$"
    let groupAndSubgroupSignal = "@"
    let characterSignal = "."
    let notSignal = "!"
    
    func search(emojiGlyphs: [EmojiGlyph], filter: EmojiFilter, searchString: String) -> [EmojiGlyph]? {
        switch filter {
        case .noFilter:
            return emojiGlyphs
        case .byDescription:
            return searchByDescription(emojiGlyphs: emojiGlyphs, filter: filter, searchString: searchString)
        default:
            return nil
        }
    }
    
    fileprivate func searchByDescription(emojiGlyphs: [EmojiGlyph], filter: EmojiFilter, searchString: String) -> [EmojiGlyph]? {
        
        if searchString.isEmpty {
            return nil
        }
        
        let searchTerms = searchString.lowercased().components(separatedBy: " ").filter({ $0 != ""})
        
        var initialResultGlyphs = emojiGlyphs.filter({ (glyph) -> Bool in
            
            let wordList = glyph.description.lowercased().components(separatedBy: " ")
            // Remove ":" from emoji glyph descriptions so that "baby" and "baby:" are the same
            let cleanWordList = wordList.map({$0.contains(":") ? String($0.dropLast()) : $0})
            let wordListSet: Set = Set(cleanWordList)
            
            // TODO: Return AND results not EITHER/OR!
            //       Example: "cat eyes" returns any description with both cat and eyes in it
            //       currently "cat eyes" returns all descriptions that have either cat or eyes in it
            
            let searchTermsSet = Set(searchTerms)
            let intersectionSet = wordListSet.intersection(searchTermsSet)
            return !intersectionSet.isEmpty
        })
        
        if searchString.contains("!") {
            
            if initialResultGlyphs.isEmpty {
                // Find all emoji that don't match the search terms
                initialResultGlyphs = emojiGlyphs
            }
            
            let excludedTerms = searchTerms.filter({ $0[$0.startIndex] == "!"})
            let cleanExcludedTerms = excludedTerms.map({ String($0.dropFirst()) })
            
            let finalResultGlyphs = initialResultGlyphs.filter({ (glyph) -> Bool in
                
                let wordList = glyph.description.lowercased().components(separatedBy: " ")
                let cleanWordList = wordList.map({$0.contains(":") ? String($0.dropLast()) : $0})
                let wordListSet = Set(cleanWordList)
                
                let searchTermsSet = Set(cleanExcludedTerms)
                let intersectionSet = wordListSet.intersection(searchTermsSet)
                return intersectionSet.isEmpty
            })
            
            return finalResultGlyphs
        }
        
        return initialResultGlyphs
    }
}
