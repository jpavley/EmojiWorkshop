//
//  ViewController.swift
//  EmojiWorkshop
//
//  Created by John Pavley on 12/9/17.
//  Copyright © 2017 Epic Loot. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var emojiCollection: EmojiCollection?
    
    @IBOutlet weak var emojiGlyphTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let emojiCollection = emojiCollection {
            return emojiCollection.emojiGlyphs.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = emojiGlyphTable.dequeueReusableCell(withIdentifier: "EmojiGlyphCell") as! EmojiGlyphTableViewCell
        
        if let emojiCollection = emojiCollection {
            let currentEmojiGlyph = emojiCollection.emojiGlyphs[indexPath.row]
            cell.emojiLabel.text = currentEmojiGlyph.glyph
            cell.descriptionLabel.text = currentEmojiGlyph.description
            cell.priorityLabel.text = "Priority \(currentEmojiGlyph.priority)"
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        emojiCollection = EmojiCollection(sourceFileName: "emoji-test-5.0")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

