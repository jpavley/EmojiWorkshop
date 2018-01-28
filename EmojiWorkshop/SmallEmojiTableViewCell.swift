//
//  SmallEmojiTableViewCell.swift
//  EmojiWorkshop
//
//  Created by John Pavley on 12/27/17.
//  Copyright © 2017 Epic Loot. All rights reserved.
//

import UIKit

class SmallEmojiTableViewCell: UITableViewCell {
    
    @IBOutlet weak var emojiImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(named: "ThemeColorTranslucent")
        selectedBackgroundView = selectedView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
