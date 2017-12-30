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
    let andSignal = "&"
    let notSignal = "!"
    
    func search(emojiGlyphs: [EmojiGlyph], filter: EmojiFilter, searchString: String) -> [EmojiGlyph]? {
        switch filter {
        case .noFilter:
            return emojiGlyphs
        case .byDescription:
            return searchByDescription(emojiGlyphs: emojiGlyphs, filter: filter, searchString: searchString)
        case .byPriority:
            return nil
        case .byGroupAndSubgroup:
            return nil
        case .byImage:
            return nil
        case .byCharacter:
            return nil
        }
    }
    
    fileprivate func searchByDescription(emojiGlyphs: [EmojiGlyph], filter: EmojiFilter, searchString: String) -> [EmojiGlyph]? {
        
        // A search query is a sentance where each term narrows the results from left to right.
        // "Cat" returns all glyphs with "cat" in the description.
        // "Cat face" returns the subset of "cat" glyphs that also have "face" in the description.
        // "Cat face !smiling returns the subset of "cat" && "face" glyphs that don't have "smiling" in the decription
        // "Cat face !smiling kissing" returns the subset of "cat" && "face" && "kissing" but not "smiling" in the desciption
                
        if searchString.isEmpty {
            return nil
        }
        
        let searchTerms = searchString.lowercased().components(separatedBy: " ").filter({ $0 != "" && $0[$0.startIndex] != "!" })
        
        var iterativeResults = emojiGlyphs
        for term in searchTerms {
            // print("== \(term) of \(searchTerms)")
            iterativeResults = iterativeResults.filter({ (glyph) -> Bool in
                
                let wordListSet = cleanWordList(glyph: glyph)
                let searchTermsSet: Set<String> = Set([term])
                let intersectionSet = wordListSet.intersection(searchTermsSet)
                return !intersectionSet.isEmpty
            })
        }
        
        var initialResultGlyphs = iterativeResults
        
        if searchString.contains("!") {
            
            if initialResultGlyphs.isEmpty {
                // Find all emoji that don't match the search terms
                initialResultGlyphs = emojiGlyphs
            }
            
            let excludedTerms = searchString.lowercased().components(separatedBy: " ").filter({ $0 != "" ? $0[$0.startIndex] == "!" : false })
            
            if excludedTerms.count == 1 && excludedTerms.first == "!" {
                // Dont search on an empty exclusion
                return initialResultGlyphs
            }
            
            let cleanExcludedTerms = excludedTerms.map({ String($0.dropFirst()) })
            let finalResultGlyphs = initialResultGlyphs.filter({ (glyph) -> Bool in
                                
                let wordListSet = cleanWordList(glyph: glyph)
                let searchTermsSet = Set(cleanExcludedTerms)
                let intersectionSet = wordListSet.intersection(searchTermsSet)
                return intersectionSet.isEmpty
            })
            
            return finalResultGlyphs
        }
        
        return initialResultGlyphs
    }
}
