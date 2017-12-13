//
//  ViewController.swift
//  EmojiWorkshop
//
//  Created by John Pavley on 12/9/17.
//  Copyright © 2017 Epic Loot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var emojiCollection: EmojiCollection?
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var emojiGlyphTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        emojiCollection = EmojiCollection(sourceFileName: "emoji-test-5.0")
        
        // Search Controller setup
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Emoji"
        navigationItem.searchController = searchController
        definesPresentationContext = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = emojiGlyphTable.dequeueReusableCell(withIdentifier: "EmojiGlyphCell") as! EmojiGlyphTableViewCell
        
        if let emojiCollection = emojiCollection {
            
            let currentEmojiGlyph = emojiCollection.emojiGlyphs.filter {$0.priority == emojiCollection.glyphsIDsInSections[indexPath.section][indexPath.row]}.first!
            
            cell.emojiLabel.text = currentEmojiGlyph.glyph
            cell.descriptionLabel.text = currentEmojiGlyph.description
            cell.priorityLabel.text = "Priority \(currentEmojiGlyph.priority)"

        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let emojiCollection = emojiCollection {
            return emojiCollection.sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let emojiCollection = emojiCollection {
            return emojiCollection.glyphsIDsInSections[section].count
        }

        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if let emojiCollection = emojiCollection {
            return emojiCollection.sections[section]
        }

        return ""
    }
}

