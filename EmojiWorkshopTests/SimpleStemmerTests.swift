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
                   "hands": "hands",
                   "fingers": "finger",
                   "horns": "horn",
                   "children": "child",
                   "tech": "Technologist",
                   "tram": "train",
                   "metro": "train",
                   "rail": "train",
                   "monorail": "train",
                   "railway": "train",
                   "trollybus": "bus"]

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
        let terms = ["tram", "metro", "rail", "monorail", "railway"]
        let simpleStemmer = SimpleStemmer(stemMap: stemMap)
        
        for term in terms {
            XCTAssertTrue(simpleStemmer.getStem(for: term) == "train")
        }
    }
    
    func testStemmerSuccessChaseChange() {
        let terms = ["Tram", "metro", "Rail", "monorail", "RAILWAY"]
        let simpleStemmer = SimpleStemmer(stemMap: stemMap)
        
        for term in terms {
            XCTAssertTrue(simpleStemmer.getStem(for: term) == "train")
        }
    }
    
    func testStemmerFail() {
        let terms = ["xxx", "yyy", "zzz"]
        let simpleStemmer = SimpleStemmer(stemMap: stemMap)
        
        for term in terms {
            XCTAssertNil(simpleStemmer.getStem(for: term))
        }
    }
    
    func testStemmerFromFile() {
        let simpleStemmer = SimpleStemmer(sourceFileName: "EmojiStems")
        XCTAssertNotNil(simpleStemmer)
    }
    
    func testStemmerFromFileSuccess() {
        let simpleStemmer = SimpleStemmer(sourceFileName: "EmojiStems")
        XCTAssertTrue(simpleStemmer?.getStem(for: "eyes") == "eye")
    }
    
    func testStemmerFromFileSuccessCaseChange() {
        let simpleStemmer = SimpleStemmer(sourceFileName: "EmojiStems")
        XCTAssertTrue(simpleStemmer?.getStem(for: "Eyes") == "eye")
    }

    
}
