//
//  EmojiViewController.swift
//  EmojiWorkshop
//
//  Created by John Pavley on 12/9/17.
//  Copyright © 2017 Epic Loot. All rights reserved.
//

import UIKit

// MARK:- Enumerations

/// UserMode is main state machine of the app's UX. The app starts in browse. Touching the searchbar
/// activates textSearchingNoResults. Typeing text that results in finding one or more emoji
/// activates textSearching. Clearing the searchbar text or editing the text so that no emoji is
/// found reactivates textSearchingNoResults. Touching the cancel button reactivates browse mode.
/// Upon cancel the current searchbar text is saved. Touching the seachbar from browse restores the
/// saved searchbar text.
enum UserMode: Int {
    /// Initial mode, **searchbar is not active**, **no text in searchbar**, cancel button disabled,
    /// keyboard hidden, **0 emoji found**, clear button not visible.
    case browsing = 0
    /// > 0 emoji found, **search is active**, **text in searchbar**, cancel button enabled, keyboard
    /// visible or hidden, **seachbar text results in finding 1 or more emoji**, clear button
    /// visible, saved and restored if there text in the searchbar.
    case textSearching = 1
    /// **Searchbar is active**, **no text in searchbar**, cancel button enabled, keyboard visible,
    /// **0 emoji found**, initial mode with searchbar is activated, searchbar text does not
    /// result in finding any emoji, clear button not visible.
    case textSearchingNoResults = 2
}

// MARK:- Shared color scheme

let emojiYellowUIColor = UIColor(named: "ThemeColor")

// MARK:- UIViewController

class EmojiViewController: UIViewController {
    
    // MARK: Static Constants
    
    struct Identifiers {
        static let emojiGlyphCell = "EmojiGlyphCell"
        static let smallEmojiCell = "SmallEmojiTableCell"
        static let suggestSearchCell = "SuggestSearchCell"
        static let emojiSectionHeader = "EmojiSectionHeader"
        static let emojiTest5 = "emoji-test-5.0"
    }
    
    // MARK:- Properties
    
    var emojiCollection: EmojiCollection?
    var localPasteboard = ""
    var userMode = UserMode.browsing
    var searchbarText = ""
    var selectedIndexPath: IndexPath?
    
    // MARK:- Outlets
    
    @IBOutlet weak var glyphTableView: UITableView!
    @IBOutlet weak var emojiSearchbar: UISearchBar!
    @IBOutlet weak var clipboardItem: UIBarButtonItem!
    @IBOutlet weak var deleteItem: UIBarButtonItem!
    @IBOutlet weak var shareItem: UIBarButtonItem!
    
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
        enableToolbarButtons()
    }
    
    // MARK:- Notification functions
    
    @objc func updateToolbar() {
        if let selectedIndexPath = selectedIndexPath, let selectedGlyph = getSelectedEmojiGlyph(for: selectedIndexPath)?.glyph {
            if clipboardItem.title!.count < 12 {
                localPasteboard += "\(selectedGlyph)"
                clipboardItem.title = localPasteboard
            }
        }
        enableToolbarButtons()
    }
    
    @objc func enableCancelButton() {
        let cancelButton = emojiSearchbar.value(forKey: "cancelButton") as! UIButton
        cancelButton.isEnabled = true
    }
    
    @objc func disableCancelButton() {
        let cancelButton = emojiSearchbar.value(forKey: "cancelButton") as! UIButton
        cancelButton.isEnabled = false
    }


    
    // MARK:- Utility functions
    
    fileprivate func nothingToPaste() -> Bool {
        return localPasteboard.count < 1
    }
    
    fileprivate func updateUserMode(newMode: UserMode) {
        
        userMode = newMode

        switch userMode {
            
        case .browsing:
            hideKeyboard()
            disableCancelButton()
            
        case .textSearching:
            showKeyboard()
            enableCancelButton()

            
        case .textSearchingNoResults:
            showKeyboard()
            enableCancelButton()
        }
        
        reloadTable(from: "updateUserMode(newMode: \(newMode))")
    }
    
    fileprivate func hideKeyboard() {
        emojiSearchbar.resignFirstResponder()
    }
    
    fileprivate func showKeyboard() {
        emojiSearchbar.becomeFirstResponder()
    }

    
    fileprivate func getSelectedEmojiGlyph(for indexPath: IndexPath) -> EmojiGlyph? {
        guard let emojiCollection = emojiCollection else {
            return nil
        }
        
        switch userMode {
        case .textSearching:
            return emojiCollection.filteredEmojiGlyphs[indexPath.row]
        case .browsing, .textSearchingNoResults:
            return emojiCollection.emojiGlyphs.filter {$0.index == emojiCollection.glyphsIDsInSections[indexPath.section][indexPath.row]}.first!
        }
    }
    
    fileprivate func getSelectedSuggestion(for indexPath: IndexPath) -> TagAndCount? {
        guard let emojiCollection = emojiCollection else {
            return nil
        }
        
        return emojiCollection.filteredSearchSuggestions[indexPath.row]
    }

    
    fileprivate func enableToolbarButtons() {
        deleteItem.isEnabled = localPasteboard.count >= 1
        shareItem.isEnabled = localPasteboard.count >= 1
    }
    
    fileprivate func updateSmallCell(with emojiGlyph: EmojiGlyph) ->  SmallEmojiTableViewCell {
        let cell = glyphTableView.dequeueReusableCell(withIdentifier: Identifiers.smallEmojiCell) as! SmallEmojiTableViewCell
        
        cell.emojiLabel.text = emojiGlyph.glyph
        cell.descriptionLabel.text = emojiGlyph.description.capitalized
        cell.priorityLabel.text = "# \(emojiGlyph.index)"
        cell.tagLabel.text = emojiGlyph.tags.joined(separator: " ").capitalized.trimmingCharacters(in: .whitespaces)
        
        return cell
    }
    
    fileprivate func updateSuggestSearchCell(with suggestion: TagAndCount) ->  SuggestSearchCell {
        let cell = glyphTableView.dequeueReusableCell(withIdentifier: Identifiers.suggestSearchCell) as! SuggestSearchCell
        
        cell.label.text = "\(suggestion.key.capitalized) (\(suggestion.value))"
        return cell
    }

    
    fileprivate func getHeaderLabelText(for section: Int) -> String {
        guard let emojiCollection = emojiCollection else {
            return ""
        }
        
        switch userMode {
            
        case .textSearching:
            return "Found \(emojiCollection.filteredEmojiGlyphs.count) emoji"
            
        case .textSearchingNoResults:
            return "Found 0 emoji"
            
        case .browsing:
            return "\(emojiCollection.sectionNames[section]) (\(emojiCollection.glyphsIDsInSections[section].count))"
        }
    }
    
    fileprivate func setupTableView() {
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        glyphTableView.contentInset = insets
    }
    
    fileprivate func setupSectionHeader() {
        // section header setup
        let sectionNib = UINib(nibName: Identifiers.emojiSectionHeader, bundle: nil)
        glyphTableView.register(sectionNib, forHeaderFooterViewReuseIdentifier: Identifiers.emojiSectionHeader)
        glyphTableView.rowHeight = UITableViewAutomaticDimension
        glyphTableView.estimatedSectionHeaderHeight = 40
    }
    
    fileprivate func setupCellNib() {
        let cellNib = UINib(nibName: Identifiers.smallEmojiCell, bundle: nil)
        glyphTableView.register(cellNib, forCellReuseIdentifier: Identifiers.smallEmojiCell)
        glyphTableView.rowHeight = UITableViewAutomaticDimension
        glyphTableView.estimatedRowHeight = 300
    }
    
    fileprivate func setupSuggestCellNib() {
        let cellNib = UINib(nibName: Identifiers.suggestSearchCell, bundle: nil)
        glyphTableView.register(cellNib, forCellReuseIdentifier: Identifiers.suggestSearchCell)
        glyphTableView.rowHeight = UITableViewAutomaticDimension
        glyphTableView.estimatedRowHeight = 300
    }

    
    fileprivate func setupSearchbar() {
        updateUserMode(newMode: .browsing)
        searchbarText = ""
        emojiSearchbar.selectedScopeButtonIndex = EmojiScope.noFilter.rawValue
    }
    
    fileprivate func setupToolbar() {
        clipboardItem.title = ""
        localPasteboard = ""
        enableToolbarButtons()
    }
    
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateToolbar), name: NSNotification.Name(rawValue: "updateToolbar"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enableCancelButton), name: NSNotification.Name(rawValue: "enableCancelButton"), object: nil)
    }
    
    fileprivate func search() {
        guard let emojiCollection = emojiCollection else {
            return
        }
        
        if let foundEmoji = emojiCollection.searcher.searchTags(emojiGlyphs: emojiCollection.emojiGlyphs, searchString: emojiSearchbar.text!) {
            
            emojiCollection.filteredEmojiGlyphs = foundEmoji
            
            if emojiCollection.filteredEmojiGlyphs.isEmpty {
                
                updateUserMode(newMode: .textSearchingNoResults)
                
            } else {
                
                updateUserMode(newMode: .textSearching)
            }
        }
    }
    
    fileprivate func processSearchBarText() {
        if emojiSearchbar.text!.isEmpty {
            emojiCollection!.filteredEmojiGlyphs = [EmojiGlyph]()
            searchbarText = ""
            updateUserMode(newMode: .textSearchingNoResults)
        } else {
            searchbarText = emojiSearchbar.text!
            search()
        }
    }
    

    fileprivate func reloadTable(from: String) {
        // print("== reloadTable(from: \(from)")
        
        UIView.animate(withDuration: 0, animations: {
            self.glyphTableView.setContentOffset(CGPoint.zero, animated: false)
        }) { (finished) in
            self.glyphTableView.setContentOffset(CGPoint.zero, animated: false)
            self.glyphTableView.reloadData()
        }

    }
    
    fileprivate func updateFilteredSeachSuggestions(searchText: String) {
        if userMode == .textSearchingNoResults {
            emojiCollection!.filteredSearchSuggestions = emojiCollection!.searchSuggestions.filter({$0.key.starts(with: searchText.lowercased())})
        }
    }
        
    // MARK:- Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emojiCollection = EmojiCollection(sourceFileName: Identifiers.emojiTest5)
        
        setupTableView()
        setupSectionHeader()
        setupCellNib()
        setupSuggestCellNib()
        setupSearchbar()
        setupToolbar()
        setupNotifications()
        
        updateUserMode(newMode: .browsing)

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
        processSearchBarText()
        updateFilteredSeachSuggestions(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hideKeyboard()
        enableCancelButton()

        processSearchBarText()
        
        // Here the userMode is not changing, however.
        // when the keyboard is hidden the cancel button
        // is disabled and we need to re-enable it.
        hideKeyboard()
        enableCancelButton()
        
        reloadTable(from: "searchBarSearchButtonClicked(\(searchBar.text!))")
    }

    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        updateUserMode(newMode: .browsing)
        
        searchbarText = searchBar.text!
        searchBar.text = ""
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
//        if searchbarText.isEmpty {
//
//            updateUserMode(newMode: .textSearchingNoResults)
//
//        } else {
//
//            updateUserMode(newMode: .textSearching)
//        }
        
        searchBar.text = searchbarText
        processSearchBarText()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        // TODO: do something
    }
}

// MARK:- UITableViewDelegate, UITableViewDataSource extention


extension EmojiViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        hideKeyboard()
      
        switch userMode {
        
        case .textSearching, .textSearchingNoResults:
            enableCancelButton()

        case .browsing:
            disableCancelButton()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            
            let detailViewController = segue.destination as! EmojiDetailViewController
            let indexPath = sender as! IndexPath
            detailViewController.selectedEmojiGlyph = getSelectedEmojiGlyph(for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Save the indexPath so that if the user wants to copy the selected emoji
        // to the toolbar we can find it later
        selectedIndexPath = indexPath
        
        switch userMode {
            
        case .browsing:
            
            hideKeyboard()
            performSegue(withIdentifier: "ShowDetail", sender: indexPath)
            
        case .textSearching:
            
            hideKeyboard()
            enableCancelButton()
            performSegue(withIdentifier: "ShowDetail", sender: indexPath)

        case .textSearchingNoResults:
            
            if let suggestion = getSelectedSuggestion(for: indexPath) {
                searchbarText = suggestion.key
                emojiSearchbar.text = suggestion.key
                search()
                hideKeyboard()
                enableCancelButton()
                reloadTable(from: "tableView(didSelectRowAt) getSelectedSuggestion(for: \(indexPath.row), \(searchbarText))")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let emojiCollection = emojiCollection else {
            return UITableViewCell()
        }
        
        switch userMode {
            
        case .browsing:
            
            let emojiGlyph = emojiCollection.emojiGlyphs.filter {$0.index == emojiCollection.glyphsIDsInSections[indexPath.section][indexPath.row]}.first!
            return updateSmallCell(with: emojiGlyph)

        case .textSearching:
            
            // if UITableView asks for an emoji we don't have return a blank cell
            if emojiCollection.filteredEmojiGlyphs.count - 1 < indexPath.row {
                return UITableViewCell()
            }
            
            let emojiGlyph = emojiCollection.filteredEmojiGlyphs[indexPath.row]
            return updateSmallCell(with: emojiGlyph)

        case .textSearchingNoResults:
            
            // if UITableView asks for a suggestion we don't have return a blank cell
            if emojiCollection.filteredSearchSuggestions.count - 1 < indexPath.row {
                return UITableViewCell()
            }
            
            let searchSuggestion = emojiCollection.filteredSearchSuggestions[indexPath.row]
            return updateSuggestSearchCell(with: searchSuggestion)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let emojiCollection = emojiCollection else {
            print("emojiCollection in nil in numberOfSections()")
            return 0
        }
        
        switch userMode {
            
        case .browsing:
            
            return emojiCollection.sectionNames.count
            
        case .textSearching, .textSearchingNoResults:
            
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: Identifiers.emojiSectionHeader)
        let header = cell as! EmojiSectionHeader
        header.titleLabel.text = getHeaderLabelText(for: section)
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let emojiCollection = emojiCollection {
            
            switch userMode {
                
            case .browsing:
                return emojiCollection.glyphsIDsInSections[section].count
            
            case .textSearching:
                
                return emojiCollection.filteredEmojiGlyphs.count
            
            case .textSearchingNoResults:
                return emojiCollection.filteredSearchSuggestions.count
            }
            
        }

        return 0
    }
}

