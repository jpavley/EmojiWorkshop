//
//  EmojiSearch.swift
//  EmojiWorkshop
//
//  Created by John Pavley on 12/16/17.
//  Copyright © 2017 Epic Loot. All rights reserved.
//

import Foundation

enum EmojiFilter {
    case noFilter, byTags
}

class EmojiSearch {
    
    let notSignal = "!"
    
    func search(emojiGlyphs: [EmojiGlyph], filter: EmojiFilter, searchString: String) -> [EmojiGlyph]? {
        switch filter {
        case .noFilter:
            return emojiGlyphs
        case .byTags:
            return searchByTags(emojiGlyphs: emojiGlyphs, filter: filter, searchString: searchString)
        }
    }
    
    fileprivate func searchByTags(emojiGlyphs: [EmojiGlyph], filter: EmojiFilter, searchString: String) -> [EmojiGlyph]? {
        
        // A search query is a sentance where each term narrows the results from left to right.
        // "Cat" returns all glyphs with "cat" in the description.
        // "Cat face" returns the subset of "cat" glyphs that also have "face" in the description.
        // "Cat face !smiling returns the subset of "cat" && "face" glyphs that don't have "smiling" in the decription
        // "Cat face !smiling kissing" returns the subset of "cat" && "face" && "kissing" but not "smiling" in the desciption
                
        if searchString.isEmpty {
            return nil
        }
        
        let searchTerms = searchTermsWithoutExclusedTermsFrom(searchString)
        
        if searchTerms.contains("") {
            return nil
        }
        
        var iterativeResults = emojiGlyphs
        for term in searchTerms {
            // print("== \(term) of \(searchTerms)")
            iterativeResults = iterativeResults.filter({ (glyph) -> Bool in
                let wordListSet: Set<String> = Set(glyph.tags)
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
            
            let excludedTerms = excludedTermsFrom(searchString)
            
            if excludedTerms.count == 1 && excludedTerms.first == "" {
                // Dont search on an empty exclusion
                return initialResultGlyphs
            }
            
            let finalResultGlyphs = initialResultGlyphs.filter({ (glyph) -> Bool in
                let wordListSet: Set<String> = Set(glyph.tags)
                let searchTermsSet = Set(excludedTerms)
                let intersectionSet = wordListSet.intersection(searchTermsSet)
                return intersectionSet.isEmpty
            })
            
            return finalResultGlyphs
        }
        
        return initialResultGlyphs
    }
    
    fileprivate func searchTermsWithoutExclusedTermsFrom(_ searchString: String) -> [String] {
        let searchTerms = searchString.lowercased().components(separatedBy: " ").filter({ $0 != "" && $0[$0.startIndex] != "!" })
        let finalTerms = stemmedTermsFrom(searchTerms)
        return finalTerms
    }
    
    fileprivate func excludedTermsFrom(_ searchString: String) -> [String] {
        let excludedTerms = searchString.lowercased().components(separatedBy: " ").filter({ $0 != "" ? $0[$0.startIndex] == "!" : false })
        let cleanExcludedTerms = excludedTerms.map({ String($0.dropFirst()) })
        let finalExcludedTerms = stemmedTermsFrom(cleanExcludedTerms)
        return finalExcludedTerms
    }
}
