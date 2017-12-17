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
        
        if searchString.count == 0 {
            return nil
        }
        
        let searchTerms = searchString.lowercased().components(separatedBy: " ").filter({ $0 != ""})
        
        // TODO: Remove ":" and "-" from search terms
        
        var initialResultGlyphs = emojiGlyphs.filter({ (glyph) -> Bool in
            
            let wordList = glyph.description.lowercased().components(separatedBy: " ")
            let wordListSet:Set<String> = Set(wordList)
            
            // TODO: Return AND results not EITHER/OR!
            //       Example: "cat eyes" returns any description with both cat and eyes in it
            //       currently "cat eyes" returns all descriptions that have either cat or eyes in it
            
            let searchTermsSet:Set<String> = Set(searchTerms)
            let intersectionSet = wordListSet.intersection(searchTermsSet)
            return intersectionSet.count > 0
        })
        
        if searchString.contains("!") {
            
            if initialResultGlyphs.count == 0 {
                // Find all emoji that don't match the search terms
                initialResultGlyphs = emojiGlyphs
            }
            
            let excludedTerms = searchTerms.filter({ $0[$0.startIndex] == "!"})
            let cleanExcludedTerms = excludedTerms.map({ String($0.dropFirst()) })
            
            let finalResultGlyphs = initialResultGlyphs.filter({ (glyph) -> Bool in
                
                let wordList = glyph.description.lowercased().components(separatedBy: " ")
                let wordListSet:Set<String> = Set(wordList)
                
                let searchTermsSet:Set<String> = Set(cleanExcludedTerms)
                let intersectionSet = wordListSet.intersection(searchTermsSet)
                return intersectionSet.count == 0
            })
            
            return finalResultGlyphs
        }
        
        return initialResultGlyphs
    }
}
