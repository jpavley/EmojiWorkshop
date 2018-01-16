//
//  SimpleStemmerTests.swift
//  EmojiWorkshopTests
//
//  Created by John Pavley on 1/3/18.
//  Copyright © 2018 Epic Loot. All rights reserved.
//

import XCTest

class SimpleStemmerTests: XCTestCase {
    
    var stemMap = [String: String]()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        stemMap = ["eyes": "eye",
                   "men": "man",
                   "women": "woman",
                   "hands": "hand",
                   "fingers": "finger",
                   "horns": "horn",
                   "children": "child"
                   ]

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateStemmer() {
        let simpleStemmer = SimpleStemmer(stemMap: stemMap)
        XCTAssertNotNil(simpleStemmer)
    }
    
    func testStemmerSuccess() {
        let terms = ["eyes", "men", "women", "hands", "fingers", "horns", "children"]
        let results = ["eye", "man", "woman", "hand", "finger", "horn", "child"]
        let simpleStemmer = SimpleStemmer(stemMap: stemMap)
        
        for i in 0..<terms.count {
            print(terms[i], results[i])
            XCTAssertTrue(simpleStemmer.getStems(for: terms[i])?.first == results[i])
        }
    }
    
    func testStemmerSuccessChaseChange() {
        let terms = ["Eyes", "mEn", "womeN", "haNDs", "fINGers", "HornS", "CHILDREN"]
        let results = ["eye", "man", "woman", "hand", "finger", "horn", "child"]
        let simpleStemmer = SimpleStemmer(stemMap: stemMap)
        
        for i in 0..<terms.count {
            print(terms[i], results[i])
            XCTAssertTrue(simpleStemmer.getStems(for: terms[i])?.first == results[i])
        }
    }
    
    func testStemmerFail() {
        let terms = ["xxx", "yyy", "zzz"]
        let simpleStemmer = SimpleStemmer(stemMap: stemMap)
        
        for term in terms {
            XCTAssertNil(simpleStemmer.getStems(for: term))
        }
    }
    
    func testStemmerFromFile() {
        let simpleStemmer = SimpleStemmer(sourceFileName: "EmojiStems")
        XCTAssertNotNil(simpleStemmer)
    }
    
    func testStemmerFromFileSuccess() {
        let simpleStemmer = SimpleStemmer(sourceFileName: "EmojiStems")
        XCTAssertTrue(simpleStemmer?.getStems(for: "eyes")?.first == "eye")
    }
    
    func testStemmerFromFileSuccessCaseChange() {
        let simpleStemmer = SimpleStemmer(sourceFileName: "EmojiStems")
        XCTAssertTrue(simpleStemmer?.getStems(for: "Eyes")?.first == "eye")
    }
    
    func testStopWords() {
        let simpleStemmer = SimpleStemmer(sourceFileName: "EmojiStems")
        XCTAssertTrue(simpleStemmer?.getStems(for: "And")?.first == "")
    }

    
}
