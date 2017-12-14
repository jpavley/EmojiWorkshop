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
    @IBOutlet weak var clipboardItem: UIBarButtonItem!
    
    
    @IBAction func copyButtonTouched(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = clipboardItem.title!
    }
    
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
        navigationItem.hidesSearchBarWhenScrolling = false
        emojiGlyphTable.rowHeight = 66
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UISearchResultsUpdating {
    
    fileprivate func userIsFiltering() -> Bool {
        let searchBarIsEmpty = searchController.searchBar.text?.isEmpty ?? true
        let currentlyFiltering = !searchBarIsEmpty &&  searchController.isActive
        return currentlyFiltering
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let emojiCollection = emojiCollection {
            
            emojiCollection.filteredEmojiGlyphs = emojiCollection.emojiGlyphs.filter { $0.description.lowercased().contains(searchController.searchBar.text!.lowercased())}
        }
        emojiGlyphTable.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let emojiCollection = emojiCollection {
            
            if userIsFiltering() {
                let filteredEmojiGlyph = emojiCollection.filteredEmojiGlyphs[indexPath.row]
                clipboardItem.title = "\(filteredEmojiGlyph.glyph)"
            } else {
                let currentEmojiGlyph = emojiCollection.emojiGlyphs.filter {$0.priority == emojiCollection.glyphsIDsInSections[indexPath.section][indexPath.row]}.first!
                clipboardItem.title = "\(currentEmojiGlyph.glyph)"
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = emojiGlyphTable.dequeueReusableCell(withIdentifier: "EmojiGlyphCell") as! EmojiGlyphTableViewCell
        
        if let emojiCollection = emojiCollection {
            
            if userIsFiltering() {
                let filteredEmojiGlyph = emojiCollection.filteredEmojiGlyphs[indexPath.row]
                
                cell.emojiButton.setTitle(filteredEmojiGlyph.glyph, for: .normal)
                cell.descriptionLabel.text = filteredEmojiGlyph.description
                cell.priorityLabel.text = "Priority \(filteredEmojiGlyph.priority)"
            } else {
                
                let currentEmojiGlyph = emojiCollection.emojiGlyphs.filter {$0.priority == emojiCollection.glyphsIDsInSections[indexPath.section][indexPath.row]}.first!
                
                cell.emojiButton.setTitle(currentEmojiGlyph.glyph, for: .normal)
                cell.descriptionLabel.text = currentEmojiGlyph.description
                cell.priorityLabel.text = "# \(currentEmojiGlyph.priority)"
            }
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let emojiCollection = emojiCollection {
            
            if userIsFiltering() {
                return 1
            } else {
                return emojiCollection.sections.count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let emojiCollection = emojiCollection {
            
            if userIsFiltering() {
                return emojiCollection.filteredEmojiGlyphs.count
            } else {
                return emojiCollection.glyphsIDsInSections[section].count
            }
        }

        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if let emojiCollection = emojiCollection {
            
            if userIsFiltering() {
                return "Found \(emojiCollection.filteredEmojiGlyphs.count) emoji"
            } else {
                return "\(emojiCollection.sections[section]) \(emojiCollection.glyphsIDsInSections[section].count)"
            }
        }

        return ""
    }
}

