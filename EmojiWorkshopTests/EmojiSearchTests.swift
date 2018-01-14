//
//  EmojiSearchTests.swift
//  EmojiWorkshopTests
//
//  Created by John Pavley on 12/16/17.
//  Copyright © 2017 Epic Loot. All rights reserved.
//

import XCTest

class EmojiSearchTests: XCTestCase {
    
    struct Identifiers {
        static let emojiTest5 = "emoji-test-5.0"
        static let emojiTestFail = "emoji-test-fail"
    }
    
    struct EmojiSearchResults {
        let query: String
        let foundCount: Int
        let firstID: Int // -1 means no ID
        let lastID: Int
    }
    
    var emojiSearchResultsList = [EmojiSearchResults]()
    var testEmojiCollection : EmojiCollection?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        if let emojiCollection = EmojiCollection(sourceFileName: Identifiers.emojiTest5) {
            testEmojiCollection = emojiCollection
        }
        
        emojiSearchResultsList = [
            EmojiSearchResults(query: "", foundCount: 2622, firstID: 23, lastID: 3495),
            EmojiSearchResults(query: "C", foundCount: 0, firstID: -1, lastID: -1),
            EmojiSearchResults(query: "Ca", foundCount: 0, firstID: -1, lastID: -1),
            EmojiSearchResults(query: "Cat", foundCount: 11, firstID: 96, lastID: 1517),
            EmojiSearchResults(query: "Cat ", foundCount: 11, firstID: 96, lastID: 1517),
            EmojiSearchResults(query: "Cat face", foundCount: 10, firstID: 96, lastID: 1516),
            EmojiSearchResults(query: "Cat face !smiling", foundCount: 7, firstID: 96, lastID: 1516),
            EmojiSearchResults(query: "Cat face !smiling !pouting", foundCount: 6, firstID: 96, lastID: 1516),
            EmojiSearchResults(query: "Cat face !smiling !pouting !grinning", foundCount: 5, firstID: 98, lastID: 1516),
            EmojiSearchResults(query: "Cat face !smiling !pouting !grinning joy", foundCount: 1, firstID: 98, lastID: 98),
            EmojiSearchResults(query: "Book house", foundCount: 0, firstID: -1, lastID: -1),
            EmojiSearchResults(query: "Cat !", foundCount: 11, firstID: 96, lastID: 1517), // "Cat !" == "Cat"
            EmojiSearchResults(query: "Book !Orange", foundCount: 16, firstID: 2050, lastID: 2066),
            EmojiSearchResults(query: "!blue", foundCount: 2616, firstID: 1, lastID: 2621),
            EmojiSearchResults(query: "Baby", foundCount: 16, firstID: 108, lastID: 2159), // "Baby" == "Baby:"
            EmojiSearchResults(query: "Cat !face n", foundCount: 2490, firstID: 108, lastID: 2621), // "Cat !face n" == "Cat n !face" == "!face"
            EmojiSearchResults(query: "Blood", foundCount: 4, firstID: 2300, lastID: 2311), // "Blood" == "(Blood"
            EmojiSearchResults(query: "Type", foundCount: 4, firstID: 2300, lastID: 2311),  // "Type" == "Type)
            EmojiSearchResults(query: "United Nations", foundCount: 0, firstID: -1, lastID: -1), // filter out the unsuported UN Flag
            EmojiSearchResults(query: "United", foundCount: 3, firstID: 2364, lastID: 2601),      // filter out the unsuported UN Flag
            EmojiSearchResults(query: "eye", foundCount: 13, firstID: 2, lastID: 1440), // stemming "eyes" == "eye"
            EmojiSearchResults(query: "eyes", foundCount: 13, firstID: 2, lastID: 1440),
            EmojiSearchResults(query: "man", foundCount: 386, firstID: 138, lastID: 2471), // stemming "men" == "man"
            EmojiSearchResults(query: "men", foundCount: 386, firstID: 138, lastID: 2471),
            EmojiSearchResults(query: "man bunny", foundCount: 1, firstID: 883, lastID: 883), // stemming "man bunny" == "men bunny"
            EmojiSearchResults(query: "mount", foundCount: 23, firstID: 1100, lastID: 1842), // stemming "mount" == "mountain"
            EmojiSearchResults(query: "mountain", foundCount: 23, firstID: 1100, lastID: 1842),
            EmojiSearchResults(query: "star", foundCount: 9, firstID: 21, lastID: 2270), // stemming "star" == "stars"
            EmojiSearchResults(query: "stars", foundCount: 9, firstID: 21, lastID: 2270),
            EmojiSearchResults(query: "application", foundCount: 1, firstID: 2327, lastID: 2327),
            EmojiSearchResults(query: "and", foundCount: 0, firstID: -1, lastID: -1), // stop word search
            EmojiSearchResults(query: "bike", foundCount: 38, firstID: 1082, lastID: 2169), // activity stems
            EmojiSearchResults(query: "biking", foundCount: 38, firstID: 1082, lastID: 2169), 
            EmojiSearchResults(query: "bicycle", foundCount: 2, firstID: 1815, lastID: 2169),
            EmojiSearchResults(query: "train", foundCount: 16, firstID: 1787, lastID: 1843) // synonymming: "train" = all types of trains (trams, railways, cable cars, train stations)
        ]
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEmojiSearchInstance() {
        let testEmojiSearch = EmojiSearch()
        XCTAssertNotNil(testEmojiSearch)
    }
    
    func testEmojiSearchResultsListByTags() {
        
        let testEmojiSearch = EmojiSearch()
        
        for i in 0..<emojiSearchResultsList.count {
            
            if let testSearchResults = testEmojiSearch.search(emojiGlyphs: testEmojiCollection!.emojiGlyphs,
                                                              filter: .byTags,
                                                              searchString: emojiSearchResultsList[i].query) {
                
                XCTAssertEqual(testSearchResults.count, emojiSearchResultsList[i].foundCount, "failed query: \(emojiSearchResultsList[i].query)")
                
                if let firstID = testSearchResults.first {
                    XCTAssertEqual(firstID.index, emojiSearchResultsList[i].firstID, "failed query: \(emojiSearchResultsList[i].query)")
                }
                
                if let lastID = testSearchResults.last {
                    XCTAssertEqual(lastID.index, emojiSearchResultsList[i].lastID,  "failed query: \(emojiSearchResultsList[i].query)")
                }
            }
        }
    }
    
    func testFilterEmojiNoFilter() {
        
        let testEmojiSearch = EmojiSearch()
        
        if let testSearchResults = testEmojiSearch.search(emojiGlyphs: testEmojiCollection!.emojiGlyphs, filter: .noFilter, searchString: "") {
            
            XCTAssertTrue(testEmojiCollection!.emojiGlyphs.count == testSearchResults.count) // 2621 emoji as of Emoji Test File 5.0
            XCTAssertTrue(testEmojiCollection!.glyphsIDsInSections.count == 76) // 76 sections as of Emoji Test File 5.0
            XCTAssertTrue(testEmojiCollection!.emojiGlyphs.first!.index == testSearchResults.first!.index)
            XCTAssertTrue(testEmojiCollection!.emojiGlyphs.last!.index == testSearchResults.last!.index)
        }
    }
    
    func testSearchSuggestion() {
        let testEmojiSearch = EmojiSearch()
        let testSugestionResults = testEmojiSearch.getSuggestions(emojiGlyphs: testEmojiCollection!.emojiGlyphs)
        
        XCTAssertTrue(testSugestionResults.count != 0)
        XCTAssertTrue(testSugestionResults[0].key == "smileys" || testSugestionResults[0].key == "person")
        XCTAssertTrue(testSugestionResults[0].value == 1507)
    }
}
