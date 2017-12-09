//
//  ViewController.swift
//  EmojiWorkshop
//
//  Created by John Pavley on 12/9/17.
//  Copyright © 2017 Epic Loot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let txtPath = Bundle.main.path(forResource: "emoji-test", ofType: "txt") {
            do {
                let emojiTestText = try String(contentsOfFile: txtPath, encoding: .utf8)
                let emojiTestLines = emojiTestText.split(separator: "\n")
                for line in emojiTestLines {
                    if let emojiGlyph = EmojiGlyph(textLine: String(line)) {
                        print(emojiGlyph)
                    }
                    
                }
            } catch {
                print("emoji-test.txt file not found")
            }
        }
        
//        let testGlyph = EmojiGlyph(textLine: "1F476                                      ; fully-qualified     # 👶 baby")
//        print(testGlyph!)
//
//        let testGlyph2 = EmojiGlyph(textLine: "1F601                                      ; fully-qualified     # 😁 beaming face with smiling eyes")
//        print(testGlyph2!)
//
//        let testGlyph3 = EmojiGlyph(textLine: "1F468 1F3FF 200D 1F3EB                     ; fully-qualified     # 👨🏿‍🏫 man teacher: dark skin tone")
//        print(testGlyph3!)
//
//        let testGlyph4 = EmojiGlyph(textLine: "# Emoji Keyboard/Display Test Data for UTR #51")
//        print(testGlyph4 ?? "failure")

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

