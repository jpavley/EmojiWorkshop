//
//  EmojiGlyphTableViewCell.swift
//  EmojiWorkshop
//
//  Created by John Pavley on 12/9/17.
//  Copyright © 2017 Epic Loot. All rights reserved.
//

import UIKit

class EmojiGlyphTableViewCell: UITableViewCell {
    
    @IBOutlet weak var emojiButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    
    @IBAction func emojiButtonTouched(_ sender: UIButton) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = sender.title(for: .normal)
        print(pasteboard.string!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
