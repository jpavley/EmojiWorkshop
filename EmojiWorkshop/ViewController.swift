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
                var group = ""
                var subgroup = ""
                for (i, line) in emojiTestLines.enumerated() {
                    
                    if line.contains("# group: ") {
                        group = String(line[line.index(line.startIndex, offsetBy: "# group: ".count)...])
                    }
                    
                    if line.contains("# subgroup: ") {
                        subgroup = String(line[line.index(line.startIndex, offsetBy: "# subgroup: ".count)...])
                    }

                    
                    if let emojiGlyph = EmojiGlyph(textLine: String(line), priority: i, group: group, subgroup: subgroup) {
                        print(emojiGlyph)
                    }
                }
            } catch {
                
                print("emoji-test.txt file not found")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

