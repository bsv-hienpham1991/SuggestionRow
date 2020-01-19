//
//  ViewController.swift
//  SuggestionRowExemple
//
//  Created by Hien Pham on 1/18/20.
//  Copyright © 2020 Hien Pham. All rights reserved.
//

import UIKit
import Eureka
import SuggestionRow

class SuggestionExampleViewController: FormViewController {
    var contentInset: UIEdgeInsets = .zero

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let options = ["Apple", "Appetizer", "Around", "Addiction", "Anachronism", "Ant", "Author"]
        let users: [Scientist] = [Scientist(id: 1, firstName: "Albert", lastName: "Einstein"),
                             Scientist(id: 2, firstName: "Isaac", lastName: "Newton"),
                             Scientist(id: 3, firstName: "Galileo", lastName: "Galilei"),
                             Scientist(id: 4, firstName: "Marie", lastName: "Curie"),
                             Scientist(id: 5, firstName: "Louis", lastName: "Pasteur"),
                             Scientist(id: 6, firstName: "Michael", lastName: "Faraday"),
                             Scientist(id: 5, firstName: "Louis", lastName: "Pasteur"),
                             Scientist(id: 6, firstName: "Michael", lastName: "Faraday"),
                             Scientist(id: 7, firstName: "Michael", lastName: "Faraday"),
                             Scientist(id: 8, firstName: "Michael", lastName: "Faraday"),
                             Scientist(id: 9, firstName: "Michael", lastName: "Faraday"),
                             Scientist(id: 10, firstName: "Michael", lastName: "Faraday"),
                             Scientist(id: 11, firstName: "Michael", lastName: "Faraday"),
                             Scientist(id: 12, firstName: "Michael", lastName: "Faraday"),
                             Scientist(id: 13, firstName: "Michael", lastName: "Faraday"),
                             Scientist(id: 14, firstName: "Michael", lastName: "Faraday"),
                             Scientist(id: 15, firstName: "Michael", lastName: "Faraday")]

        form +++ Section("Input accessory view suggestions")
            <<< SuggestionAccessoryRow<String>() {
                $0.maxSuggestionRows = 10
                $0.filterFunction = { text in
                    options.filter({ $0.hasPrefix(text) })
                }
                $0.placeholder = "Enter text that starts with A..."
            }
        
            +++ Section("Table suggestions")
            <<< SuggestionRowCustom<Scientist>() {
                $0.maxSuggestionRows = 10
                $0.filterFunction = { text in
                    users.filter({ $0.firstName.lowercased().contains(text.lowercased()) })
                }
                $0.placeholder = "Search for a famous scientist"
                $0.viewProvider = SuggestionContentViewProvider(nibName: "SuggestionCellCustom", bundle: Bundle.main)
            }
            +++ Section("Table suggestions")
            <<< SuggestionTableRow<Scientist>() {
                $0.filterFunction = { text in
                    users.filter({ $0.firstName.lowercased().contains(text.lowercased()) })
                }
                $0.placeholder = "Search for a famous scientist"
            }
            +++ Section("Table suggestions")
            <<< SuggestionTableRow<Scientist>() {
                $0.filterFunction = { text in
                    users.filter({ $0.firstName.lowercased().contains(text.lowercased()) })
                }
                $0.placeholder = "Search for a famous scientist"
            }
            +++ Section("Table suggestions")
            <<< SuggestionTableRow<Scientist>() {
                $0.filterFunction = { text in
                    users.filter({ $0.firstName.lowercased().contains(text.lowercased()) })
                }
                $0.placeholder = "Search for a famous scientist"
            }
            +++ Section("Table suggestions")
            <<< SuggestionTableRow<Scientist>() {
                $0.filterFunction = { text in
                    users.filter({ $0.firstName.lowercased().contains(text.lowercased()) })
                }
                $0.placeholder = "Search for a famous scientist"
            }
            +++ Section("Table suggestions")
            <<< SuggestionTableRow<Scientist>() {
                $0.filterFunction = { text in
                    users.filter({ $0.firstName.lowercased().contains(text.lowercased()) })
                }
                $0.placeholder = "Search for a famous scientist"
            }
            +++ Section("Table suggestions")
            <<< SuggestionTableRow<Scientist>() {
                $0.filterFunction = { text in
                    users.filter({ $0.firstName.lowercased().contains(text.lowercased()) })
                }
                $0.placeholder = "Search for a famous scientist"
            }
            +++ Section("Table suggestions")
            <<< SuggestionTableRow<Scientist>() {
                $0.filterFunction = { text in
                    users.filter({ $0.firstName.lowercased().contains(text.lowercased()) })
                }
                $0.placeholder = "Search for a famous scientist"
            }
            +++ Section("Table suggestions")
            <<< SuggestionTableRow<Scientist>() {
                $0.filterFunction = { text in
                    users.filter({ $0.firstName.lowercased().contains(text.lowercased()) })
                }
                $0.placeholder = "Search for a famous scientist"
            }
            +++ Section("Table suggestions")
            <<< SuggestionTableRow<Scientist>() {
                $0.filterFunction = { text in
                    users.filter({ $0.firstName.lowercased().contains(text.lowercased()) })
                }
                $0.placeholder = "Search for a famous scientist"
        }
    }
    
    override func keyboardWillShow(_ notification: Notification) {
        super.keyboardWillShow(notification)
        guard let cell = tableView.findFirstResponder()?.formCell() else { return }
        contentInset = tableView.contentInset
        let suggestTableView: UITableView?
        if let row = cell.baseRow as? SuggestionTableRow<Scientist> {
            suggestTableView = row.cell.tableView
            row.cell.formContentInset = tableView.contentInset
        } else if let row = cell.baseRow as? MySuggestionTableRow<Scientist> {
            suggestTableView = row.cell.tableView
            row.cell.formContentInset = tableView.contentInset
        } else {
            suggestTableView = nil
        }

        if let suggestTableView = suggestTableView {
            if suggestTableView.frame.maxY > tableView.contentSize.height && suggestTableView.isHidden == false {
                var contentInset = tableView.contentInset
                contentInset.bottom += (suggestTableView.frame.maxY - tableView.contentSize.height)
                tableView.contentInset = contentInset
            }
        }
    }
    
    override func keyboardWillHide(_ notification: Notification) {
        super.keyboardWillHide(notification)
        contentInset = .zero
        tableView.contentInset = .zero
    }
    
    override func textInputDidEndEditing<T>(_ textInput: UITextInput, cell: Cell<T>) where T : Equatable {
        super.textInputDidEndEditing(textInput, cell: cell)
        tableView.contentInset = contentInset
    }
    
    override func textInputDidBeginEditing<T>(_ textInput: UITextInput, cell: Cell<T>) where T : Equatable {
        super.textInputDidBeginEditing(textInput, cell: cell)
        if let row = cell.baseRow as? MySuggestionTableRow<Scientist> {
            row.cell.formContentInset = contentInset
        } else if let row = cell.baseRow as? SuggestionTableRow<Scientist> {
            row.cell.formContentInset = contentInset
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let beginDragging: Bool
        if let cell = tableView.findFirstResponder()?.formCell(),
            (cell.baseRow is SuggestionTableRow<Scientist> ||
                cell.baseRow is MySuggestionTableRow<Scientist>) {
            beginDragging = false
        } else {
            beginDragging = true
        }
        
        if beginDragging == true {
            super.scrollViewWillBeginDragging(scrollView)
        }
    }
}


struct Scientist: SuggestionValue {
    var id: Int
    var firstName: String
    var lastName: String


    var suggestionString: String {
        return "\(firstName) \(lastName)"
    }

    init(id: Int, firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.id = id
    }

    init?(string stringValue: String) {
        return nil
    }
}

func == (lhs: Scientist, rhs: Scientist) -> Bool {
    return lhs.id == rhs.id
}

final class MySuggestionTableRow<T: SuggestionValue>: _SuggestionRow<MySuggestionTableCell<T, SuggestionTableViewCell<T>>>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

class MySuggestionTableCell<T, TableViewCell: UITableViewCell>: SuggestionTableCell<T, TableViewCell> where TableViewCell: EurekaSuggestionTableViewCell, TableViewCell.S == T {
}

open class MySuggestionTableViewCell<T: SuggestionValue>: SuggestionTableViewCell<T> {
}
