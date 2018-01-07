//
//  EmojiTools.swift
//  EmojiWorkshop
//
//  Created by John Pavley on 12/30/17.
//  Copyright © 2017 Epic Loot. All rights reserved.
//

import Foundation

typealias TagList = [String]

func printCVS(emojiGlyphs: [EmojiGlyph]) {
    print("priority, glyph, group, subgroup, tags")
    for emoji in emojiGlyphs {
        
        let tags = createMetadata(glyph: emoji)
        
        print("\(emoji.index),\(emoji.glyph),\(emoji.group),\(emoji.subgroup)", terminator: "")
        if tags.count != 0 {
            print(",", terminator: "")
            for tag in tags {
                print("\(tag)", terminator: "")
                if tag != tags.last! {
                    print(" ", terminator: "")
                }
            }
        }
        print("")
    }
}

func cleanWordList(glyph: EmojiGlyph) -> Set<String> {
    
    let wordList = glyph.description.lowercased().components(separatedBy: CharacterSet(charactersIn: " -"))
    let cleanWordList = wordList.map({$0.contains(":") ? String($0.dropLast()) : $0})
    let wordListSet = Set(cleanWordList) // conversion to set removes any dupes
    
    return wordListSet
}

fileprivate func removeJunkCharacters(from text: String) -> TagList {
    var cleanedWords = text.lowercased().components(separatedBy: CharacterSet(charactersIn: " -"))
    cleanedWords = cleanedWords.map({$0.contains(":") ? String($0.dropLast()) : $0})
    cleanedWords = cleanedWords.map({$0.contains(",") ? String($0.dropLast()) : $0})
    cleanedWords = cleanedWords.map({$0.contains("(") ? String($0.dropFirst()) : $0})
    cleanedWords = cleanedWords.map({$0.contains(")") ? String($0.dropLast()) : $0})
    cleanedWords = cleanedWords.map({$0.contains("“") ? String($0.dropFirst()) : $0})
    cleanedWords = cleanedWords.map({$0.contains("”") ? String($0.dropLast()) : $0})
    cleanedWords = cleanedWords.filter({$0 != "&"})
    return cleanedWords
}

func createMetadata(glyph: EmojiGlyph) -> [String] {
    
    let descriptionWords = removeJunkCharacters(from: glyph.description)
    let groupWords = removeJunkCharacters(from: glyph.group)
    let subgroupWords = removeJunkCharacters(from: glyph.subgroup)
    
    let rawTags = descriptionWords + groupWords + subgroupWords
    let stemmedTags = stemmedTermsFrom(rawTags)
    
    let tagSet = Set(stemmedTags) // de-dupe
    let tagList = Array(tagSet)
    let tagListSorted = tagList.sorted()
    
    return tagListSorted
}

func stemmedTermsFrom(_ terms: [String]) -> [String] {
    var stemedTerms = [String]()
    let simpleStemmer = SimpleStemmer()
    for term in terms {
        stemedTerms.append(simpleStemmer?.getStem(for: term) ?? term)
    }
    return stemedTerms
}

