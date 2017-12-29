//
//  EmojiViewController.swift
//  EmojiWorkshop
//
//  Created by John Pavley on 12/9/17.
//  Copyright © 2017 Epic Loot. All rights reserved.
//

import UIKit

enum UserMode {
    case browsing, searching
}

class EmojiViewController: UIViewController {
    
    struct Identifiers {
        static let emojiGlyphCell = "EmojiGlyphCell"
        static let smallEmojiCell = "SmallEmojiTableCell"
        static let emojiTest5 = "emoji-test-5.0"
    }
    
    var emojiCollection: EmojiCollection?
    var localPasteboard = ""
    var userMode = UserMode.browsing
    
    @IBOutlet weak var emojiGlyphTable: UITableView!
    @IBOutlet weak var emojiSearchBar: UISearchBar!
    
    @IBOutlet weak var clipboardItem: UIBarButtonItem!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        emojiCollection = EmojiCollection(sourceFileName: Identifiers.emojiTest5)
        
        // Cell Nib setup
        
        let cellNib = UINib(nibName: Identifiers.smallEmojiCell, bundle: nil)
        emojiGlyphTable.register(cellNib, forCellReuseIdentifier: Identifiers.smallEmojiCell)
        emojiGlyphTable.rowHeight = 66
        
        // searchbar setup
        emojiSearchBar.showsCancelButton = true
        emojiSearchBar.showsScopeBar = true
        emojiSearchBar.showsBookmarkButton = true
        emojiSearchBar.showsSearchResultsButton = true
        
        // toolbar setup
        
//        clipboardItem.title = ""
        localPasteboard = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension EmojiViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        // print("== updateSearchResults()")
    }
    
}

extension EmojiViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("The search text is: \(searchBar.text!)")
        
        if searchBar.text!.isEmpty {
            
            userMode = .browsing
        } else {
            
            userMode = .searching
            if let emojiCollection = emojiCollection {
                
                let emojiSearch = EmojiSearch()
                if let foundEmoji = emojiSearch.search(emojiGlyphs: emojiCollection.emojiGlyphs,
                                                       filter: .byDescription,
                                                       searchString: searchBar.text!) {
                    
                    emojiCollection.filteredEmojiGlyphs = foundEmoji
                }
            }
        }
        
        searchBar.resignFirstResponder()
        emojiGlyphTable.reloadData()
    }
    
}

extension EmojiViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let emojiCollection = emojiCollection {
                        
            if userMode == .searching {
                let filteredEmojiGlyph = emojiCollection.filteredEmojiGlyphs[indexPath.row]
                updateToolbar(with: filteredEmojiGlyph)
            } else {
                let currentEmojiGlyph = emojiCollection.emojiGlyphs.filter {$0.priority == emojiCollection.glyphsIDsInSections[indexPath.section][indexPath.row]}.first!
                updateToolbar(with: currentEmojiGlyph)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    fileprivate func updateToolbar(with emojiGlyph: EmojiGlyph) {
        localPasteboard += "\(emojiGlyph.glyph)"
        //clipboardItem.title = localPasteboard

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = emojiGlyphTable.dequeueReusableCell(withIdentifier: Identifiers.smallEmojiCell, for: indexPath) as! SmallEmojiTableViewCell
        
        if let emojiCollection = emojiCollection {
            
            if emojiCollection.filteredEmojiGlyphs.count > 0 && userMode == .searching {
                
                let filteredEmojiGlyph = emojiCollection.filteredEmojiGlyphs[indexPath.row]
                cell = updateSmallCell(with: filteredEmojiGlyph)
            } else {
                
                let currentEmojiGlyph = emojiCollection.emojiGlyphs.filter {$0.priority == emojiCollection.glyphsIDsInSections[indexPath.section][indexPath.row]}.first!
                cell = updateSmallCell(with: currentEmojiGlyph)
            }
        }
        
        return cell
    }
        
    fileprivate func updateSmallCell(with emojiGlyph: EmojiGlyph) ->  SmallEmojiTableViewCell {
        let cell = emojiGlyphTable.dequeueReusableCell(withIdentifier: Identifiers.smallEmojiCell) as! SmallEmojiTableViewCell
        
        cell.emojiLabel.text = emojiGlyph.glyph
        cell.descriptionLabel.text = emojiGlyph.description
        cell.priorityLabel.text = "# \(emojiGlyph.priority)"
        
        return cell
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let emojiCollection = emojiCollection {
            
            if userMode == .searching {
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
            
            if userMode == .searching {
                return emojiCollection.filteredEmojiGlyphs.count
            } else {
                return emojiCollection.glyphsIDsInSections[section].count
            }
        }

        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if let emojiCollection = emojiCollection {
            
            if userMode == .searching {
                return "Found \(emojiCollection.filteredEmojiGlyphs.count) emoji"
            } else {
                return "\(emojiCollection.sections[section]) \(emojiCollection.glyphsIDsInSections[section].count)"
            }
        }

        return ""
    }
}

