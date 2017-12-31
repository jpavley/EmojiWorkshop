//
//  SmallEmojiTableViewCell.swift
//  EmojiWorkshop
//
//  Created by John Pavley on 12/27/17.
//  Copyright © 2017 Epic Loot. All rights reserved.
//

import UIKit

class SmallEmojiTableViewCell: UITableViewCell {
    
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
