//
//  ViewController.swift
//  EmojiWorkshop
//
//  Created by John Pavley on 12/9/17.
//  Copyright © 2017 Epic Loot. All rights reserved.
//

import UIKit

enum UserMode {
    case browsing, searching, discovering
}

class ViewController: UIViewController {
    
    var emojiCollection: EmojiCollection?
    let searchController = UISearchController(searchResultsController: nil)
    var localPasteboard = ""
    
    @IBOutlet weak var emojiGlyphTable: UITableView!
    @IBOutlet weak var clipboardItem: UIBarButtonItem!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    
    
    @IBAction func copyButtonTouched(_ sender: Any) {
        if nothingToPaste() {
            return
        }

        let pasteboard = UIPasteboard.general
        pasteboard.string = localPasteboard
        
        let alert = UIAlertController(title: "Copied", message: "\(localPasteboard)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dimiss", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func clearButtonTouched(_ sender: UIBarButtonItem) {
        if nothingToPaste() {
            return
        }
        
        let indexEndOfText = localPasteboard.index(localPasteboard.endIndex, offsetBy: -1)
        localPasteboard = String(localPasteboard[..<indexEndOfText])
        clipboardItem.title = localPasteboard
    }
    
    fileprivate func nothingToPaste() -> Bool {
        return localPasteboard.count < 1
    }
    
    fileprivate func updateHeader(mode: UserMode) {
        
        switch mode {
        case .browsing:
            var emojiCount = 0
            var sectionCount = 0
            
            if let emojiCollection = emojiCollection {
                emojiCount = emojiCollection.emojiGlyphs.count
                sectionCount = emojiCollection.sections.count
            }
            
            headerLabel.text = "Browsing \(emojiCount) emoji in \(sectionCount) sections"
            
        case .searching:
            
            headerLabel.text = "Searching..."
            
        case .discovering:
            ()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        emojiCollection = EmojiCollection(sourceFileName: "emoji-test-5.0")
        
        // Search Controller setup
        
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Emoji"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        emojiGlyphTable.rowHeight = 66
        
        // toolbar setup
        
        clipboardItem.title = ""
        localPasteboard = ""
        
        // header setup
        updateHeader(mode: .browsing)
        
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
        // print("== updateSearchResults()")

        if let emojiCollection = emojiCollection {
            
            let emojiSearch = EmojiSearch()
            if let foundEmoji = emojiSearch.search(emojiGlyphs: emojiCollection.emojiGlyphs, filter: .byDescription, searchString: searchController.searchBar.text!) {
                emojiCollection.filteredEmojiGlyphs = foundEmoji
            }
        }
        emojiGlyphTable.reloadData()
    }
    
}

extension ViewController: UISearchControllerDelegate {
    
    func didDismissSearchController(_ searchController: UISearchController) {
        // print("== didDismissSearchController()")
        updateHeader(mode: .browsing)
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        // print("== didPresentSearchController()")
        updateHeader(mode: .searching)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let emojiCollection = emojiCollection {
                        
            if userIsFiltering() {
                let filteredEmojiGlyph = emojiCollection.filteredEmojiGlyphs[indexPath.row]
                updateToolbar(with: filteredEmojiGlyph)
            } else {
                let currentEmojiGlyph = emojiCollection.emojiGlyphs.filter {$0.priority == emojiCollection.glyphsIDsInSections[indexPath.section][indexPath.row]}.first!
                updateToolbar(with: currentEmojiGlyph)
            }
        }
    }
    
    fileprivate func updateToolbar(with emojiGlyph: EmojiGlyph) {
        localPasteboard += "\(emojiGlyph.glyph)"
        clipboardItem.title = localPasteboard

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = emojiGlyphTable.dequeueReusableCell(withIdentifier: "EmojiGlyphCell") as! EmojiGlyphTableViewCell
        
        if let emojiCollection = emojiCollection {
            
            if userIsFiltering() {
                let filteredEmojiGlyph = emojiCollection.filteredEmojiGlyphs[indexPath.row]
                cell = updateCell(with: filteredEmojiGlyph)
            } else {
                let currentEmojiGlyph = emojiCollection.emojiGlyphs.filter {$0.priority == emojiCollection.glyphsIDsInSections[indexPath.section][indexPath.row]}.first!
                cell = updateCell(with: currentEmojiGlyph)
            }
        }
        
        return cell
    }
    
    fileprivate func updateCell(with emojiGlyph: EmojiGlyph) ->  EmojiGlyphTableViewCell {
        let cell = emojiGlyphTable.dequeueReusableCell(withIdentifier: "EmojiGlyphCell") as! EmojiGlyphTableViewCell
        
        cell.emojiButton.setTitle(emojiGlyph.glyph, for: .normal)
        cell.descriptionLabel.text = emojiGlyph.description
        cell.priorityLabel.text = "# \(emojiGlyph.priority)"
        
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

