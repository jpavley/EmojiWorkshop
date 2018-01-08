//
//  EmojiDetailViewController.swift
//  Emoji Spy
//
//  Created by John Pavley on 1/7/18.
//  Copyright © 2018 Epic Loot. All rights reserved.
//

import UIKit

class EmojiDetailViewController: UIViewController {
    
    @IBOutlet weak var emojiIndexLabel: UILabel!
    @IBOutlet weak var emojiGlyphLabel: UILabel!
    @IBOutlet weak var emojiDescriptionLabel: UILabel!
    @IBOutlet weak var emojiTagsTextView: UITextView!
    
    var selectedEmojiGlyph: EmojiGlyph!
    
    
    // Mark:- Actions
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func copyToPasteboard(_ sender: Any) {
    }
    
    // Mark:- Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark:- Initalization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    // Mark:- Helpers
    
    func updateDetails() {
        guard let selectedEmojiGlyph = selectedEmojiGlyph else {
            return
        }
        
        emojiIndexLabel.text = "# \(selectedEmojiGlyph.index)"
        emojiGlyphLabel.text = selectedEmojiGlyph.glyph
        emojiDescriptionLabel.text = selectedEmojiGlyph.description
        
        var tagsString = ""
        
        for tag in selectedEmojiGlyph.tags {
            tagsString += "\(tag) "
        }
        
        emojiTagsTextView.text = tagsString
    }
    
    
}

// Mark:- Extentions

extension EmojiDetailViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        
        return EmojiDimmingPresentationController(presentedViewController: presented,
                                                  presenting: presenting)
    }
}
