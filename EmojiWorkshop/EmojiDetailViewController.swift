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
    @IBOutlet weak var emojiImageView: UIImageView!
    @IBOutlet weak var emojiGroupLabel: UILabel!
    @IBOutlet weak var emojiDescriptionLabel: UILabel!
    @IBOutlet weak var emojiTagsLabel: UILabel!
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    var selectedEmojiGlyph: EmojiGlyph!
    
    
    // Mark:- Actions
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func copyToToolbar(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateToolbar"), object: nil)
    }
    
    // Mark:- Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        formView.layer.cornerRadius = 12
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        popupView.addGestureRecognizer(gestureRecognizer)
        
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
        //emojiGlyphLabel.text = selectedEmojiGlyph.glyph
        emojiImageView.image = getEmojiImage(for: selectedEmojiGlyph.index)
        emojiGroupLabel.text = "\(selectedEmojiGlyph.group): \(selectedEmojiGlyph.subgroup)".capitalized
        emojiDescriptionLabel.text = selectedEmojiGlyph.description.capitalized
        
        emojiTagsLabel.text = selectedEmojiGlyph.tags.joined(separator: " ").capitalized.trimmingCharacters(in: .whitespaces)
    }
}

// TODO: Toy code, remove once we have a serious solution

fileprivate func getEmojiImage(for glyphID: Int) -> UIImage {
    if glyphID > 0 && glyphID < 10 {
        return UIImage(named: "dv-dark-emoji-\(glyphID)")!
    } else {
        return UIImage(named: "dv-dark-emoji-1")!

    }
}

// Mark:- Extentions

extension EmojiDetailViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        // print("presenting \(presenting?.description), presented \(presented.description)")
        
        return EmojiPresentationController(presentedViewController: presented,
                                                  presenting: presenting)
    }
}

extension EmojiDetailViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // return true to dismiss the detail view
        return touch.view === popupView
    }
}

