//
//  EmojiDetailViewController.swift
//  Emoji Spy
//
//  Created by John Pavley on 1/7/18.
//  Copyright © 2018 Epic Loot. All rights reserved.
//

import UIKit

class EmojiDetailViewController: UIViewController {
    
    // Mark:- Actions
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Mark:- Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: Initalization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    
}

extension EmojiDetailViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        
        return EmojiDimmingPresentationController(presentedViewController: presented,
                                                  presenting: presenting)
    }
}
