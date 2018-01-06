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
            EmojiSearchResults(query: "Cat", foundCount: 11, firstID: 127, lastID: 2122),
            EmojiSearchResults(query: "Cat ", foundCount: 11, firstID: 127, lastID: 2122),
            EmojiSearchResults(query: "Cat face", foundCount: 10, firstID: 127, lastID: 2121),
            EmojiSearchResults(query: "Cat face !smiling", foundCount: 8, firstID: 127, lastID: 2121),
            EmojiSearchResults(query: "Cat face !smiling !pouting", foundCount: 7, firstID: 127, lastID: 2121),
            EmojiSearchResults(query: "Cat face !smiling !pouting !grinning", foundCount: 6, firstID: 129, lastID: 2121),
            EmojiSearchResults(query: "Cat face !smiling !pouting !grinning joy", foundCount: 1, firstID: 129, lastID: 129),
            EmojiSearchResults(query: "Book house", foundCount: 0, firstID: -1, lastID: -1),
            EmojiSearchResults(query: "Cat !", foundCount: 11, firstID: 127, lastID: 2122), // "Cat !" == "Cat"
            EmojiSearchResults(query: "Book !Orange", foundCount: 16, firstID: 2781, lastID: 2798),
            EmojiSearchResults(query: "!blue", foundCount: 2616, firstID: 23, lastID: 3495),
            EmojiSearchResults(query: "Baby", foundCount: 16, firstID: 141, lastID: 2935), // "Baby" == "Baby:"
            EmojiSearchResults(query: "Cat !face n", foundCount: 2490, firstID: 141, lastID: 3495), // "Cat !face n" == "Cat n !face" == "!face"
            EmojiSearchResults(query: "Blood", foundCount: 4, firstID: 3150, lastID: 3165), // "Blood" == "(Blood"
            EmojiSearchResults(query: "Type", foundCount: 4, firstID: 3150, lastID: 3165),  // "Type" == "Type)
            EmojiSearchResults(query: "United Nations", foundCount: 0, firstID: -1, lastID: -1), // filter out the unsuported UN Flag
            EmojiSearchResults(query: "United", foundCount: 3, firstID: 3236, lastID: 3474),      // filter out the unsuported UN Flag
            EmojiSearchResults(query: "eye", foundCount: 13, firstID: 24, lastID: 2028), // stemming "eyes" == "eye"
            EmojiSearchResults(query: "eyes", foundCount: 13, firstID: 24, lastID: 2028),
            EmojiSearchResults(query: "man", foundCount: 386, firstID: 171, lastID: 3343), // stemming "men" == "man"
            EmojiSearchResults(query: "men", foundCount: 386, firstID: 171, lastID: 3343),
            EmojiSearchResults(query: "man bunny", foundCount: 1, firstID: 1253, lastID: 1253), // stemming "man bunny" == "men bunny"
            EmojiSearchResults(query: "mount", foundCount: 23, firstID: 1611, lastID: 2507),
            EmojiSearchResults(query: "star", foundCount: 9, firstID: 44, lastID: 3097),
            EmojiSearchResults(query: "application", foundCount: 1, firstID: 3185, lastID: 3185)
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
    
    func testEmojiSearchResultsListByDescription() {
        
        let testEmojiSearch = EmojiSearch()
        
        for i in 0..<emojiSearchResultsList.count {
            
            if let testSearchResults = testEmojiSearch.search(emojiGlyphs: testEmojiCollection!.emojiGlyphs,
                                                              filter: .byDescription,
                                                              searchString: emojiSearchResultsList[i].query) {
                
                XCTAssertEqual(testSearchResults.count, emojiSearchResultsList[i].foundCount, "failed query: \(emojiSearchResultsList[i].query)")
                
                if let firstID = testSearchResults.first {
                    XCTAssertEqual(firstID.priority, emojiSearchResultsList[i].firstID, "failed query: \(emojiSearchResultsList[i].query)")
                }
                
                if let lastID = testSearchResults.last {
                    XCTAssertEqual(lastID.priority, emojiSearchResultsList[i].lastID,  "failed query: \(emojiSearchResultsList[i].query)")
                }
            }
        }
    }
    
    func testFilterEmojiNoFilter() {
        
        let testEmojiSearch = EmojiSearch()
        
        if let testSearchResults = testEmojiSearch.search(emojiGlyphs: testEmojiCollection!.emojiGlyphs, filter: .noFilter, searchString: "") {
        
            XCTAssertTrue(testEmojiCollection!.emojiGlyphs.count == testSearchResults.count)
            XCTAssertTrue(testEmojiCollection!.emojiGlyphs.first!.priority == testSearchResults.first!.priority)
            XCTAssertTrue(testEmojiCollection!.emojiGlyphs.last!.priority == testSearchResults.last!.priority)
        }
    }
    
    func testFilterEmojiByPriority() {
        
        let testEmojiSearch = EmojiSearch()
        let testSearchResults = testEmojiSearch.search(emojiGlyphs: testEmojiCollection!.emojiGlyphs, filter: .byPriority, searchString: "")
        
        XCTAssertNil(testSearchResults)
    }
    
    func testFilterEmojiByGroupAndSubgroup() {
        
        let testEmojiSearch = EmojiSearch()
        let testSearchResults = testEmojiSearch.search(emojiGlyphs: testEmojiCollection!.emojiGlyphs, filter: .byGroupAndSubgroup, searchString: "")
        
        XCTAssertNil(testSearchResults)
    }
    
    func testFilterEmojiByImage() {
        
        let testEmojiSearch = EmojiSearch()
        let testSearchResults = testEmojiSearch.search(emojiGlyphs: testEmojiCollection!.emojiGlyphs, filter: .byImage, searchString: "")
        
        XCTAssertNil(testSearchResults)
    }
    
    func testFilterEmojiByCharacter() {
        
        let testEmojiSearch = EmojiSearch()
        let testSearchResults = testEmojiSearch.search(emojiGlyphs: testEmojiCollection!.emojiGlyphs, filter: .byCharacter, searchString: "")
        
        XCTAssertNil(testSearchResults)
    }
}
