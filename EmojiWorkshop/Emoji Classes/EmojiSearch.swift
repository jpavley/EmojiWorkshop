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
        default:
            return nil
        }
    }
    
    fileprivate func searchByDescription(emojiGlyphs: [EmojiGlyph], filter: EmojiFilter, searchString: String) -> [EmojiGlyph]? {
        
        if searchString.isEmpty || !searchString.contains(" ") {
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
    
    fileprivate func cleanWordList(glyph: EmojiGlyph) -> Set<String> {
        let wordList = glyph.description.lowercased().components(separatedBy: " ")
        let cleanWordList = wordList.map({$0.contains(":") ? String($0.dropLast()) : $0})
        let wordListSet = Set(cleanWordList)
        return wordListSet
    }
}
