//
//  EmojiImageFinder.swift
//  Emoji Spy
//
//  Created by John Pavley on 1/27/18.
//  Copyright © 2018 Epic Loot. All rights reserved.
//

import Foundation

class EmojiImageFinder {
    
    var totalEmojiImages = 13
    
    // TODO: Toy code, remove once we have a serious solution
    
    func getEmojiImageName(for glyphID: Int) -> String {
        if glyphID > 0 && glyphID < totalEmojiImages + 1	 {
            return "dv-dark-emoji-\(glyphID)"
        } else {
            return "dv-dark-emoji-1"
        }
    }

}
