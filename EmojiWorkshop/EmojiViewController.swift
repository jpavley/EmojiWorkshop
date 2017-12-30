//
//  EmojiViewController.swift
//  EmojiWorkshop
//
//  Created by John Pavley on 12/9/17.
//  Copyright © 2017 Epic Loot. All rights reserved.
//

import UIKit

// MARK:- Enumerations

enum UserMode: Int {
    case browsing = 0
    case textSearching = 1
    case categorySearching = 2
    case numberSearching = 3
}

// MARK:- Shared color scheme

let emojiYellowRGBValues: [CGFloat] = [255/255, 208/255, 47/255]
let emojiYellowUIColor = UIColor(red: emojiYellowRGBValues[0], green: emojiYellowRGBValues[0], blue: emojiYellowRGBValues[0], alpha: 1.0)

// MARK:- UIViewController

class EmojiViewController: UIViewController {
    
    // MARK: Static Constants
    
    struct Identifiers {
        static let emojiGlyphCell = "EmojiGlyphCell"
        static let smallEmojiCell = "SmallEmojiTableCell"
        static let emojiTest5 = "emoji-test-5.0"
    }
    
    // MARK:- Properties
    
    var emojiCollection: EmojiCollection?
    var localPasteboard = ""
    var userMode = UserMode.browsing
    
    // MARK:- Outlets
    
    @IBOutlet weak var emojiGlyphTable: UITableView!
    @IBOutlet weak var emojiSearchBar: UISearchBar!
    @IBOutlet weak var clipboardItem: UIBarButtonItem!
    
    // MARK:- Actions
    
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
    
    // MARK:- Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        emojiCollection = EmojiCollection(sourceFileName: Identifiers.emojiTest5)
        
        // cell nib setup
        
        let cellNib = UINib(nibName: Identifiers.smallEmojiCell, bundle: nil)
        emojiGlyphTable.register(cellNib, forCellReuseIdentifier: Identifiers.smallEmojiCell)
        emojiGlyphTable.rowHeight = 66
        
        // searchbar setup
        userMode = .browsing
        emojiSearchBar.selectedScopeButtonIndex = userMode.rawValue
        
        // toolbar setup
        
        clipboardItem.title = ""
        localPasteboard = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK:- UISearchResultsUpdating extension

extension EmojiViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        // print("== updateSearchResults()")
    }
    
}

// MARK:- UISearchBarDelegate extension

extension EmojiViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("selectedScopeButtonIndexDidChange \(selectedScope)")
        
        switch selectedScope {
        case UserMode.browsing.rawValue:
            userMode = .browsing
            searchBar.resignFirstResponder()

            
        case UserMode.textSearching.rawValue:
            userMode = .textSearching
            searchBar.becomeFirstResponder()
            
        case UserMode.categorySearching.rawValue:
            userMode = .categorySearching
            searchBar.becomeFirstResponder()

        case UserMode.numberSearching.rawValue:
            userMode = .numberSearching
            searchBar.becomeFirstResponder()

        default:
            ()
        }
        emojiGlyphTable.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        userMode = .textSearching
        searchBar.selectedScopeButtonIndex = userMode.rawValue
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("The search text is: \(searchBar.text!)")
        
        if searchBar.text!.isEmpty {
            
            userMode = .browsing
            searchBar.selectedScopeButtonIndex = userMode.rawValue
        } else {
            
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

// MARK:- UITableViewDelegate, UITableViewDataSource extention


extension EmojiViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let emojiCollection = emojiCollection {
                        
            if userMode == .textSearching {
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
        clipboardItem.title = localPasteboard

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = emojiGlyphTable.dequeueReusableCell(withIdentifier: Identifiers.smallEmojiCell, for: indexPath) as! SmallEmojiTableViewCell
        
        if let emojiCollection = emojiCollection {
            
            if emojiCollection.filteredEmojiGlyphs.count > 0 && userMode == .textSearching {
                
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
            
            if userMode == .textSearching {
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
            
            if userMode == .textSearching {
                return emojiCollection.filteredEmojiGlyphs.count
            } else {
                return emojiCollection.glyphsIDsInSections[section].count
            }
        }

        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if let emojiCollection = emojiCollection {
            
            if userMode == .textSearching {
                return "Found \(emojiCollection.filteredEmojiGlyphs.count) emoji"
            } else {
                return "\(emojiCollection.sections[section]) \(emojiCollection.glyphsIDsInSections[section].count)"
            }
        }

        return ""
    }
}

