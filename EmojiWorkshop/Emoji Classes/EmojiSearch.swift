//
//  EmojiSearch.swift
//  EmojiWorkshop
//
//  Created by John Pavley on 12/16/17.
//  Copyright © 2017 Epic Loot. All rights reserved.
//

import Foundation

enum EmojiFilter {
    case noFilter, byDescription, byPriority, byGroupAndSubGroup, byImage
}

class EmojiSearch {
    
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
        
        return emojiGlyphs.filter({ (glyph) -> Bool in
            
            let wordList = glyph.description.lowercased().components(separatedBy: " ")
            let wordListSet:Set<String> = Set(wordList)
            
            let searchTerms = searchString.lowercased().components(separatedBy: " ")
            let searchTermsSet:Set<String> = Set(searchTerms)
            
            let intersectionSet = wordListSet.intersection(searchTermsSet)
            
            return intersectionSet.count > 0
        })
    }
}
