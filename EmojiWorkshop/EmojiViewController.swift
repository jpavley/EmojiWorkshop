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
    case textSearchingNoResults = 2
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
        static let suggestSearchCell = "SuggestSearchCell"
        static let emojiSectionHeader = "EmojiSectionHeader"
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
        if userMode == .textSearching && !emojiSearchBar.text!.isEmpty {
            let cancelButton = emojiSearchBar.value(forKey: "cancelButton") as! UIButton
            cancelButton.isEnabled = true
        }
    }

    
    // MARK:- Utility functions
    
    fileprivate func nothingToPaste() -> Bool {
        return localPasteboard.count < 1
    }
    
    fileprivate func updateUserMode(newMode: UserMode) {
        
        userMode = newMode
        emojiGlyphTable.allowsSelection = true

        switch userMode {
        case .browsing:
            emojiSearchBar.resignFirstResponder()
        case .textSearching:
            emojiSearchBar.becomeFirstResponder()
        case .textSearchingNoResults:
            emojiSearchBar.becomeFirstResponder()
        }
    }
    
    fileprivate func hideKeyboard() {
        emojiSearchBar.resignFirstResponder()
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
    
    fileprivate func getSelectedSuggtion(for indexPath: IndexPath) -> TagAndCount? {
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
        let cell = emojiGlyphTable.dequeueReusableCell(withIdentifier: Identifiers.smallEmojiCell) as! SmallEmojiTableViewCell
        
        cell.emojiLabel.text = emojiGlyph.glyph
        cell.descriptionLabel.text = emojiGlyph.description.capitalized
        cell.priorityLabel.text = "# \(emojiGlyph.index)"
        cell.tagLabel.text = emojiGlyph.tags.joined(separator: " ").capitalized.trimmingCharacters(in: .whitespaces)
        
        return cell
    }
    
    fileprivate func updateSuggestSearchCell(with suggestion: TagAndCount) ->  SuggestSearchCell {
        let cell = emojiGlyphTable.dequeueReusableCell(withIdentifier: Identifiers.suggestSearchCell) as! SuggestSearchCell
        
        cell.label.text = "\(suggestion.key.capitalized) (\(suggestion.value))"
        return cell
    }

    
    fileprivate func getHeaderLabelText(for section: Int) -> String {
        var headerLabelText = ""
        
        if let emojiCollection = emojiCollection {
            
            switch userMode {
            case .textSearching:
                headerLabelText = "Found \(emojiCollection.filteredEmojiGlyphs.count) emoji"
                
            case .textSearchingNoResults:
                headerLabelText = "Found 0 emoji"
                
            case .browsing:
                headerLabelText = "\(emojiCollection.sectionNames[section]) (\(emojiCollection.glyphsIDsInSections[section].count))"
                
            }
        }
        
        return headerLabelText
    }
    
    fileprivate func setupTableView() {
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        emojiGlyphTable.contentInset = insets
    }
    
    fileprivate func setupSectionHeader() {
        // section header setup
        let sectionNib = UINib(nibName: Identifiers.emojiSectionHeader, bundle: nil)
        emojiGlyphTable.register(sectionNib, forHeaderFooterViewReuseIdentifier: Identifiers.emojiSectionHeader)
        emojiGlyphTable.rowHeight = UITableViewAutomaticDimension
        emojiGlyphTable.estimatedSectionHeaderHeight = 40
    }
    
    fileprivate func setupCellNib() {
        let cellNib = UINib(nibName: Identifiers.smallEmojiCell, bundle: nil)
        emojiGlyphTable.register(cellNib, forCellReuseIdentifier: Identifiers.smallEmojiCell)
        emojiGlyphTable.rowHeight = UITableViewAutomaticDimension
        emojiGlyphTable.estimatedRowHeight = 300
    }
    
    fileprivate func setupSuggestCellNib() {
        let cellNib = UINib(nibName: Identifiers.suggestSearchCell, bundle: nil)
        emojiGlyphTable.register(cellNib, forCellReuseIdentifier: Identifiers.suggestSearchCell)
        emojiGlyphTable.rowHeight = UITableViewAutomaticDimension
        emojiGlyphTable.estimatedRowHeight = 300
    }

    
    fileprivate func setupSearchbar() {
        updateUserMode(newMode: .browsing)
        searchBarText = ""
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
        
        if let foundEmoji = emojiCollection.searcher.search(emojiGlyphs: emojiCollection.emojiGlyphs, filter: .byTags, searchString: emojiSearchBar.text!) {
            
            emojiCollection.filteredEmojiGlyphs = foundEmoji
            
            if emojiCollection.filteredEmojiGlyphs.count < 1 {
                userMode = .textSearchingNoResults
            } else {
                userMode = .textSearching
            }
        }
    }
    
    fileprivate func processSearchBarText() {
        if emojiSearchBar.text!.isEmpty {
            emojiCollection!.filteredEmojiGlyphs = [EmojiGlyph]()
            searchBarText = ""
            userMode = .textSearchingNoResults
        } else {
            searchBarText = emojiSearchBar.text!
            search()
        }
    }
    
    fileprivate func reloadTable() {
        UIView.animate(withDuration: 0, animations: {
            self.emojiGlyphTable.setContentOffset(CGPoint.zero, animated: false)
        }) { (finished) in
            self.emojiGlyphTable.reloadData()
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
        userMode = .browsing
        
        setupTableView()
        setupSectionHeader()
        setupCellNib()
        setupSuggestCellNib()
        setupSearchbar()
        setupToolbar()
        setupNotifications()

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
        reloadTable()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hideKeyboard()
        enableCancelButton()
    }

    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateUserMode(newMode: .browsing)
        searchBarText = searchBar.text!
        searchBar.text = ""
        reloadTable()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBarText.isEmpty {
            userMode = .textSearchingNoResults
        } else {
            updateUserMode(newMode: .textSearching)
        }
        searchBar.text = searchBarText
        reloadTable()
    }
}

// MARK:- UITableViewDelegate, UITableViewDataSource extention


extension EmojiViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        hideKeyboard()

        if userMode == .textSearching {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Save the indexPath so that if the user wants to copy the selected emoji
        // to the toolbar we can find it later
        selectedIndexPath = indexPath
        
        // click on search suggestion
        if userMode == .textSearchingNoResults {
            if let suggestion = getSelectedSuggtion(for: indexPath) {
                searchBarText = suggestion.key
                emojiSearchBar.text = suggestion.key
                search()
                hideKeyboard()
                enableCancelButton()
                reloadTable()
            }
            return
        }
        
        if userMode == .browsing || userMode == .textSearching {
            hideKeyboard()
            performSegue(withIdentifier: "ShowDetail", sender: indexPath)
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
            let emojiGlyph = emojiCollection.filteredEmojiGlyphs[indexPath.row]
            return updateSmallCell(with: emojiGlyph)

        case .textSearchingNoResults:
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
        case .textSearching:
            return 1
        case .textSearchingNoResults:
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

