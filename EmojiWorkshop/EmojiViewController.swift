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
    var searchBarText = ""
    var selectedIndexPath: IndexPath?
    
    // MARK:- Outlets
    
    @IBOutlet weak var emojiGlyphTable: UITableView!
    @IBOutlet weak var emojiSearchBar: UISearchBar!
    @IBOutlet weak var clipboardItem: UIBarButtonItem!
    
    // MARK:- Actions
    
    @IBAction func copyButtonTouched(_ sender: Any) {
        if nothingToPaste() {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [localPasteboard], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }
    
    @IBAction func clearButtonTouched(_ sender: UIBarButtonItem) {
        if nothingToPaste() {
            return
        }
        
        let indexEndOfText = localPasteboard.index(localPasteboard.endIndex, offsetBy: -1)
        localPasteboard = String(localPasteboard[..<indexEndOfText])
        clipboardItem.title = localPasteboard
    }
    
    // MARK:- Utility functions
    
    fileprivate func nothingToPaste() -> Bool {
        return localPasteboard.count < 1
    }
    
    fileprivate func updateUserMode(newMode: UserMode) {
        
        userMode = newMode
        emojiSearchBar.selectedScopeButtonIndex = userMode.rawValue

        switch userMode {
            
        case .browsing:
            emojiGlyphTable.allowsSelection = true
            emojiSearchBar.resignFirstResponder()

            
        case .textSearching:
            emojiGlyphTable.allowsSelection = true
            emojiSearchBar.becomeFirstResponder()
            
        }
    }
    
    // MARK:- Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        emojiCollection = EmojiCollection(sourceFileName: Identifiers.emojiTest5)
        
        // tableview setup
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        emojiGlyphTable.contentInset = insets
        
        // cell nib setup
        
        let cellNib = UINib(nibName: Identifiers.smallEmojiCell, bundle: nil)
        emojiGlyphTable.register(cellNib, forCellReuseIdentifier: Identifiers.smallEmojiCell)
        //emojiGlyphTable.rowHeight = 80
        emojiGlyphTable.rowHeight = UITableViewAutomaticDimension
        emojiGlyphTable.estimatedRowHeight = 300

        
        // searchbar setup
        updateUserMode(newMode: .browsing)
        searchBarText = ""
        
        // toolbar setup
        
        clipboardItem.title = ""
        localPasteboard = ""
        
        // Notification
        
        // allow detail view controller to add the selected emoji to the tool bar if the user touches copy
        NotificationCenter.default.addObserver(self, selector: #selector(updateToolbar), name: NSNotification.Name(rawValue: "updateToolbar"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enableCancelButton), name: NSNotification.Name(rawValue: "enableCancelButton"), object: nil)


        // diagnostics
        // printCVS(emojiGlyphs: emojiCollection!.emojiGlyphs)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK:- UISearchBarDelegate extension

extension EmojiViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchBarText = searchBar.text!
        
        if let emojiCollection = emojiCollection {
            
            let emojiSearch = EmojiSearch()
            if let foundEmoji = emojiSearch.search(emojiGlyphs: emojiCollection.emojiGlyphs,
                                                   filter: .byTags,
                                                   searchString: searchBar.text!) {
                
                emojiCollection.filteredEmojiGlyphs = foundEmoji
            }
        }
        
        emojiGlyphTable.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateUserMode(newMode: .browsing)
        searchBarText = searchBar.text!
        searchBar.text = ""
        emojiGlyphTable.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        updateUserMode(newMode: .textSearching)
        searchBar.text = searchBarText
        
        // print("The search text is: \(searchBar.text!)")
        
        if searchBar.text!.isEmpty {
            if let emojiCollection = emojiCollection {
                emojiCollection.filteredEmojiGlyphs = [EmojiGlyph]()
            }
        }
        
        emojiGlyphTable.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // print("The search text is: \(searchBar.text!)")
        
        searchBarText = searchBar.text!
        
        if searchBar.text!.isEmpty {
            
            updateUserMode(newMode: .browsing)
            
        } else {
            
            if let emojiCollection = emojiCollection {
                
                let emojiSearch = EmojiSearch()
                if let foundEmoji = emojiSearch.search(emojiGlyphs: emojiCollection.emojiGlyphs,
                                                       filter: .byTags,
                                                       searchString: searchBar.text!) {
                    
                    emojiCollection.filteredEmojiGlyphs = foundEmoji
                }
            }
        }
        
        emojiGlyphTable.reloadData()
    }
}

// MARK:- UITableViewDelegate, UITableViewDataSource extention


extension EmojiViewController: UITableViewDelegate, UITableViewDataSource {
    
    fileprivate func hideKeyboard() {
        emojiSearchBar.resignFirstResponder()
    }
    
    @objc func enableCancelButton() {
        if userMode == .textSearching {
            let cancelButton = emojiSearchBar.value(forKey: "cancelButton") as! UIButton
            cancelButton.isEnabled = true
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if userMode == .textSearching {
            
            // print("== scrollViewWillBeginDragging()")
            hideKeyboard()
            enableCancelButton()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let detailViewController = segue.destination as! EmojiDetailViewController
            let indexPath = sender as! IndexPath
            detailViewController.selectedEmojiGlyph = getSelectedEmojiGlyph(for: indexPath)
        }
    }
    
    fileprivate func getSelectedEmojiGlyph(for indexPath: IndexPath) -> EmojiGlyph? {
        
        guard let emojiCollection = emojiCollection else {
            return nil
        }
        
        if userMode == .textSearching {
            return emojiCollection.filteredEmojiGlyphs[indexPath.row]
        } else {
            return emojiCollection.emojiGlyphs.filter {$0.index == emojiCollection.glyphsIDsInSections[indexPath.section][indexPath.row]}.first!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Save the indexPath so that if the user wants to copy the selected emoji to the toolbar we can find it later
        selectedIndexPath = indexPath
        
        hideKeyboard()
        performSegue(withIdentifier: "ShowDetail", sender: indexPath)
    }
    
    // This function is only called by the detail view controller via a notification
    @objc func updateToolbar() {
        if let selectedIndexPath = selectedIndexPath, let selectedGlyph = getSelectedEmojiGlyph(for: selectedIndexPath)?.glyph {
            localPasteboard += "\(selectedGlyph)"
            clipboardItem.title = localPasteboard
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = emojiGlyphTable.dequeueReusableCell(withIdentifier: Identifiers.smallEmojiCell, for: indexPath) as! SmallEmojiTableViewCell
        
        if let emojiCollection = emojiCollection {
            
            if emojiCollection.filteredEmojiGlyphs.count > 0 && userMode == .textSearching {
                
                let filteredEmojiGlyph = emojiCollection.filteredEmojiGlyphs[indexPath.row]
                cell = updateSmallCell(with: filteredEmojiGlyph)
            } else {
                
                let currentEmojiGlyph = emojiCollection.emojiGlyphs.filter {$0.index == emojiCollection.glyphsIDsInSections[indexPath.section][indexPath.row]}.first!
                cell = updateSmallCell(with: currentEmojiGlyph)
            }
        }
        
        return cell
    }
        
    fileprivate func updateSmallCell(with emojiGlyph: EmojiGlyph) ->  SmallEmojiTableViewCell {
        let cell = emojiGlyphTable.dequeueReusableCell(withIdentifier: Identifiers.smallEmojiCell) as! SmallEmojiTableViewCell
        
        cell.emojiLabel.text = emojiGlyph.glyph
        cell.descriptionLabel.text = emojiGlyph.description.capitalized
        cell.priorityLabel.text = "# \(emojiGlyph.index)"
        cell.tagLabel.text = emojiGlyph.tags.joined(separator: " ").capitalized.trimmingCharacters(in: .whitespaces)
        
        return cell
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let emojiCollection = emojiCollection {
            
            if userMode == .textSearching {
                return 1
            } else {
                return emojiCollection.sectionNames.count
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
                return "\(emojiCollection.sectionNames[section]) \(emojiCollection.glyphsIDsInSections[section].count)"
            }
        }

        return ""
    }
}

