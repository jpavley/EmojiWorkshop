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

typealias TagAndCountsList = [(key: String, value: Int)]

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
    
    func getSuggestions(emojiGlyphs: [EmojiGlyph]) -> TagAndCountsList {
        
        var tagList = TagList()
        for emoji in emojiGlyphs {
            tagList += emoji.tags
        }
        
        /// The expression below is "simple but not easy"!
        /// What is does: takes the tagList array (just [String]), counts the frequency of each tag,
        ///               reduces it to a TagAndCountsList (an array of (key: String, val: Int) tuples,
        ///               and sorts it by frequency.
        /// How it does it: Let's start wth the last clause first! .sorted(by: {}) take two inputs and
        ///                 a comparison closure. Each input is a tuple with a key and a value. The
        ///                 closure turns true if the first value is greater than the second. Sorted(by:)
        ///                 gets its input from reduce.
        ///                 reduce(into:) is magic! it takes the TagList ([String]) as input and counts
        ///                 the occurance of each array element and returns the result as a dictionary
        ///                 ([String: Int]). The closer uses the default representation of inputs first
        ///                 and second as $0 and $1. For each element in the array it sets the value of
        ///                 it's entry in the dictionary to either 0 (the default) or +1.
        let tagsAndCountsList = tagList.reduce(into: [:]) { $0[$1, default: 0] += 1 }.sorted(by: { (first: (key: String, value: Int), second: (key: String, value: Int)) -> Bool in
            return first.value > second.value
        })
        
        for i in 0..<20 {
            print("\(tagsAndCountsList[i])")
        }
        
        return tagsAndCountsList
    }
    
}
