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
    
    guard
        let stemmer = SimpleStemmer(), let synonymmer = SimpleSynonymmer()
    else {
        return
    }
    
    print("priority, glyph, group, subgroup, tags")
    for emoji in emojiGlyphs {
        
        let tags = createMetadata(glyph: emoji, stemmer: stemmer, synonymmer: synonymmer)
        
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

func createMetadata(glyph: EmojiGlyph, stemmer: SimpleStemmer, synonymmer: SimpleSynonymmer) -> [String] {
    
    let descriptionWords = removeJunkCharacters(from: glyph.description)
    let groupWords = removeJunkCharacters(from: glyph.group)
    let subgroupWords = removeJunkCharacters(from: glyph.subgroup)
    
    let rawTags = descriptionWords + groupWords + subgroupWords
    let stemmedTags = stemmedTerms(from: rawTags, with: stemmer)
    let synonymmedTags = synonymmedTerms(from: stemmedTags, with: synonymmer)
    // TODO: Custom tags here
    
    let tagSet = Set(synonymmedTags) // de-dupe
    let tagList = Array(tagSet)
    let tagListSorted = tagList.sorted()
    
    return tagListSorted
}

func stemmedTerms(from terms: [String], with stemmer: SimpleStemmer) -> [String] {
    var stemedTerms = [String]()
    for term in terms {
        stemedTerms.append(stemmer.getStem(for: term) ?? term)
    }
    return stemedTerms
}

func synonymmedTerms(from terms: [String], with synonymmer: SimpleSynonymmer) -> [String] {
    var synonymmedTerms = terms
    for term in terms {
        synonymmedTerms.append(synonymmer.getSynonym(for: term) ?? term)
    }
    return synonymmedTerms
}

