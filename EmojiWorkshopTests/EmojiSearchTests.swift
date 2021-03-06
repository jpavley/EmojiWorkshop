//
//  EmojiSearchTests.swift
//  EmojiWorkshopTests
//
//  Created by John Pavley on 12/16/17.
//  Copyright © 2017 Epic Loot. All rights reserved.
//

import XCTest

class EmojiSearchTests: XCTestCase {
    
    let totalEmojiFound = 2621
    let totalSectionsFound = 76
    let totalLinesProcessed = 3499
    let totalSuggestionsFound = 1634
    let firstIndexFound = 1
    let lastIndexFound = 2621
    
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
    
    var testSearchQueries = [EmojiSearchResults]()
    var testEmojiCollection : EmojiCollection?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        if let emojiCollection = EmojiCollection(sourceFileName: Identifiers.emojiTest5) {
            testEmojiCollection = emojiCollection
        }
        
        testSearchQueries = [
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
            EmojiSearchResults(query: "train", foundCount: 16, firstID: 1787, lastID: 1843), // synonymming: "train" = all types of trains (trams, railways, cable cars, train stations)
            EmojiSearchResults(query: "Halloween !tone", foundCount: 23, firstID: 85, lastID: 2150)
        ]
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEmojiSearchInstance() {
        let testEmojiSearch = EmojiSearch(stemmer: testEmojiCollection!.stemmer,
                                          synonymmer: testEmojiCollection!.synonymmer,
                                          tagger: testEmojiCollection!.tagger)
        XCTAssertNotNil(testEmojiSearch)
    }
    
    func testEmojiSearchResultsListByTags() {
        
        let testEmojiSearch = EmojiSearch(stemmer: testEmojiCollection!.stemmer,
                                          synonymmer: testEmojiCollection!.synonymmer,
                                          tagger: testEmojiCollection!.tagger)

        for i in 0..<testSearchQueries.count {
            
            if let testSearchResults = testEmojiSearch.searchTags(emojiGlyphs: testEmojiCollection!.emojiGlyphs, searchString: testSearchQueries[i].query) {
                
                XCTAssertEqual(testSearchResults.count, testSearchQueries[i].foundCount, "failed query: \(testSearchQueries[i].query)")
                
                if let firstID = testSearchResults.first {
                    XCTAssertEqual(firstID.index, testSearchQueries[i].firstID, "failed query: \(testSearchQueries[i].query)")
                }
                
                if let lastID = testSearchResults.last {
                    XCTAssertEqual(lastID.index, testSearchQueries[i].lastID,  "failed query: \(testSearchQueries[i].query)")
                }
            }
        }
    }
    
    func testSearchSiftNoFilter() {
        
        let testEmojiSearch = EmojiSearch(stemmer: testEmojiCollection!.stemmer,
                                          synonymmer: testEmojiCollection!.synonymmer,
                                          tagger: testEmojiCollection!.tagger)
        
        let testFilteredResults = testEmojiSearch.sift(emojiGlyphs: testEmojiCollection!.emojiGlyphs,
                                                       with: .noFilter)
        
        XCTAssertTrue(testFilteredResults.count == totalEmojiFound)
        XCTAssertTrue(testFilteredResults.first!.index == firstIndexFound)
        XCTAssertTrue(testFilteredResults.last!.index == lastIndexFound)
    }
    
    func testSearchSiftYellow() {
        
        let testEmojiSearch = EmojiSearch(stemmer: testEmojiCollection!.stemmer,
                                          synonymmer: testEmojiCollection!.synonymmer,
                                          tagger: testEmojiCollection!.tagger)
        
        let testFilteredResults = testEmojiSearch.sift(emojiGlyphs: testEmojiCollection!.emojiGlyphs,
                                                       with: .yellow)
        
        XCTAssertTrue(testFilteredResults.count == 344)
        XCTAssertTrue(testFilteredResults.first!.index == 1)
        XCTAssertTrue(testFilteredResults.last!.index == 1469)
    }
    
    func testSearchSiftRoles() {
        
        let testEmojiSearch = EmojiSearch(stemmer: testEmojiCollection!.stemmer,
                                          synonymmer: testEmojiCollection!.synonymmer,
                                          tagger: testEmojiCollection!.tagger)
        
        let testFilteredResults = testEmojiSearch.sift(emojiGlyphs: testEmojiCollection!.emojiGlyphs,
                                                       with: .roles)
        
        XCTAssertTrue(testFilteredResults.count == 362)
        XCTAssertTrue(testFilteredResults.first!.index == 77)
        XCTAssertTrue(testFilteredResults.last!.index == 521)
    }

    func testSearchSiftFantsy() {
        
        let testEmojiSearch = EmojiSearch(stemmer: testEmojiCollection!.stemmer,
                                          synonymmer: testEmojiCollection!.synonymmer,
                                          tagger: testEmojiCollection!.tagger)
        
        let testFilteredResults = testEmojiSearch.sift(emojiGlyphs: testEmojiCollection!.emojiGlyphs,
                                                       with: .fantasy)
        
        XCTAssertTrue(testFilteredResults.count == 128)
        XCTAssertTrue(testFilteredResults.first!.index == 85)
        XCTAssertTrue(testFilteredResults.last!.index == 1915)
    }
    
    func testSearchSiftNature() {
        
        let testEmojiSearch = EmojiSearch(stemmer: testEmojiCollection!.stemmer,
                                          synonymmer: testEmojiCollection!.synonymmer,
                                          tagger: testEmojiCollection!.tagger)
        
        let testFilteredResults = testEmojiSearch.sift(emojiGlyphs: testEmojiCollection!.emojiGlyphs,
                                                       with: .nature)
        
        XCTAssertTrue(testFilteredResults.count == 113)
        XCTAssertTrue(testFilteredResults.first!.index == 1508)
        XCTAssertTrue(testFilteredResults.last!.index == 1620)
    }

    
    func testSearchSuggestion() {
        let testEmojiSearch = EmojiSearch(stemmer: testEmojiCollection!.stemmer,
                                          synonymmer: testEmojiCollection!.synonymmer,
                                          tagger: testEmojiCollection!.tagger)
        
        let testSugestionResults = testEmojiSearch.getSuggestions(emojiGlyphs: testEmojiCollection!.emojiGlyphs)
        XCTAssertTrue(testSugestionResults.count == totalSuggestionsFound)
    }
}
