//
//  EmojiSearchTests.swift
//  EmojiWorkshopTests
//
//  Created by John Pavley on 12/16/17.
//  Copyright © 2017 Epic Loot. All rights reserved.
//

import XCTest

class EmojiSearchTests: XCTestCase {
    
    struct EmojiSearchResults {
        let query: String
        let foundCount: Int
        let firstID: Int // -1 means no ID
        let lastID: Int
    }
    
    var emojiSearchResultsList = [EmojiSearchResults]()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // Search string cases         -> Found First Last
        // "C"                         -> 0
        // "Ca"                        -> 0
        // "Cat"                       -> 11    127   2122
        // "Cat "                      -> 11    127   2122
        // "House garden"              -> 1     2395
        // "House !garden"             -> 2     2392  2394
        // "!man !woman !person !face" -> 1580  26    3495
        // "Cat !face !n               -> 0
        // "!blue"                     -> 2617  23    3495
        
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
            EmojiSearchResults(query: "Cat face !smiling !pouting !grinning joy", foundCount: 1, firstID: 129, lastID: 129)
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
    
    func testEmojiSearchResultsList() {
        let testEmojiCollection = EmojiCollection(sourceFileName: "emoji-test-5.0")
        let testEmojiSearch = EmojiSearch()
        
        for i in 0..<emojiSearchResultsList.count {
            if let testSearchResults = testEmojiSearch.search(emojiGlyphs: testEmojiCollection.emojiGlyphs, filter: .byDescription, searchString: emojiSearchResultsList[i].query) {
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
        let testEmojiCollection = EmojiCollection(sourceFileName: "emoji-test-5.0")
        let testEmojiSearch = EmojiSearch()
        
        if let testSearchResults = testEmojiSearch.search(emojiGlyphs: testEmojiCollection.emojiGlyphs, filter: .noFilter, searchString: "") {
        
            XCTAssertTrue(testEmojiCollection.emojiGlyphs.count == testSearchResults.count)
            XCTAssertTrue(testEmojiCollection.emojiGlyphs.first!.priority == testSearchResults.first!.priority)
            XCTAssertTrue(testEmojiCollection.emojiGlyphs.last!.priority == testSearchResults.last!.priority)
        }
    }
    
    func testFilterEmojiByDescriptionSingleTerm() {
        let testEmojiCollection = EmojiCollection(sourceFileName: "emoji-test-5.0")
        let testEmojiSearch = EmojiSearch()
        let testSearchResults = testEmojiSearch.search(emojiGlyphs: testEmojiCollection.emojiGlyphs, filter: .byDescription, searchString: "Cat")
        
        XCTAssertNotNil(testSearchResults)
        XCTAssertEqual(testSearchResults!.count, 11)
        XCTAssertTrue(testSearchResults!.first!.priority == 127)
        XCTAssertTrue(testSearchResults!.last!.priority == 2122)
    }
    
    func testFilterEmojiByDescriptionMultipleTerms() {
        let testEmojiCollection = EmojiCollection(sourceFileName: "emoji-test-5.0")
        let testEmojiSearch = EmojiSearch()
        
        let testSearchResults = testEmojiSearch.search(emojiGlyphs: testEmojiCollection.emojiGlyphs, filter: .byDescription, searchString: "Book house")
        
        XCTAssertNotNil(testSearchResults)
        XCTAssertEqual(testSearchResults!.count, 0)
    }
    
    func testFilterEmojiByDescriptionWithEmptyExclusion() {
        let testEmojiCollection = EmojiCollection(sourceFileName: "emoji-test-5.0")
        let testEmojiSearch = EmojiSearch()
        
        let testSearchResults = testEmojiSearch.search(emojiGlyphs: testEmojiCollection.emojiGlyphs, filter: .byDescription, searchString: "Cat !")
        
        XCTAssertNotNil(testSearchResults)
        XCTAssertEqual(testSearchResults!.count, 11)
        XCTAssertTrue(testSearchResults!.first!.priority == 127)
        XCTAssertTrue(testSearchResults!.last!.priority == 2122)
    }
    
    func testFilterEmojiByDescriptionWithExclusion() {
        let testEmojiCollection = EmojiCollection(sourceFileName: "emoji-test-5.0")
        let testEmojiSearch = EmojiSearch()
        
        let testSearchResults = testEmojiSearch.search(emojiGlyphs: testEmojiCollection.emojiGlyphs, filter: .byDescription, searchString: "Book !blue")
        
        XCTAssertNotNil(testSearchResults)
        XCTAssertEqual(testSearchResults!.count, 4)
        XCTAssertTrue(testSearchResults!.first!.priority == 2782)
        XCTAssertTrue(testSearchResults!.last!.priority == 2786)
        XCTAssertFalse(testSearchResults![3].priority == 2785)
    }
    
    func testFilterEmojiByDescriptionOnlyExclusion() {
        let testEmojiCollection = EmojiCollection(sourceFileName: "emoji-test-5.0")
        let testEmojiSearch = EmojiSearch()
        
        let testSearchResults = testEmojiSearch.search(emojiGlyphs: testEmojiCollection.emojiGlyphs, filter: .byDescription, searchString: "!blue")
        
        XCTAssertNotNil(testSearchResults)
        XCTAssertEqual(testSearchResults!.count, 2617, "failed query: !blue")
    }
    
    func testFilterEmojiByDescriptionRemoveColons() {
        let testEmojiCollection = EmojiCollection(sourceFileName: "emoji-test-5.0")
        let testEmojiSearch = EmojiSearch()
        
        let testSearchResults = testEmojiSearch.search(emojiGlyphs: testEmojiCollection.emojiGlyphs, filter: .byDescription, searchString: "baby")
        
        XCTAssertNotNil(testSearchResults)
        XCTAssertEqual(testSearchResults!.count, 16)
        XCTAssertTrue(testSearchResults![1].priority == 142)
    }
    
    func testFilterEmojiByDescriptionWithMultipleExclusion() {
        let testEmojiCollection = EmojiCollection(sourceFileName: "emoji-test-5.0")
        let testEmojiSearch = EmojiSearch()
        
        let testSearchResults = testEmojiSearch.search(emojiGlyphs: testEmojiCollection.emojiGlyphs, filter: .byDescription, searchString: "Cat !kissing !joy !crying !grinning")
        
        XCTAssertNotNil(testSearchResults)
        XCTAssertEqual(testSearchResults!.count, 6)
        XCTAssertTrue(testSearchResults!.first!.priority == 130)
        XCTAssertTrue(testSearchResults!.last!.priority == 2122)
        XCTAssertTrue(testSearchResults![3].priority == 135)
    }
    
    func testFilterEmojiByDescriptionWithSingleCharacterAtEnd() {
        let testEmojiCollection = EmojiCollection(sourceFileName: "emoji-test-5.0")
        let testEmojiSearch = EmojiSearch()
        
        let testSearchResults = testEmojiSearch.search(emojiGlyphs: testEmojiCollection.emojiGlyphs, filter: .byDescription, searchString: "Cat !face n")
        
        XCTAssertNotNil(testSearchResults)
        XCTAssertEqual(testSearchResults!.count, 2505, "failed query: Cat !face n")
        XCTAssertEqual(testSearchResults!.count, 2505, "failed query: Cat n !face")
        XCTAssertEqual(testSearchResults!.count, 2505, "failed query: !face")
    }




}
