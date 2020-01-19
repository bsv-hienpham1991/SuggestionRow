//
//  SuggestionTableCell.swift
//
//  Adapted from Mathias Claassen 4/14/16 by Hélène Martin 8/11/16
//
//

import Foundation
import UIKit
import Eureka

open class SuggestionTableCell<T, TableViewCell: UITableViewCell>: SuggestionCell<T>, UITableViewDelegate, UITableViewDataSource where TableViewCell: EurekaSuggestionTableViewCell, TableViewCell.S == T {
    
    /// callback that can be used to customize the table cell.
    public var customizeTableViewCell: ((TableViewCell) -> Void)?
    
    public var tableView: UITableView?
    
    public var tableViewContainer: UIView?
    
    public var formContentInset: UIEdgeInsets?

    required public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func setup() {
        super.setup()
        if tableView == nil {
            tableView = UITableView(frame: CGRect.zero, style: .plain)
            
            if #available(iOS 13.0, *) {
                tableView?.backgroundColor = UIColor.systemBackground
            } else {
                tableView?.backgroundColor = UIColor.white
            }
            
            tableViewContainer = tableView
        }

        tableViewContainer?.isHidden = true
        tableViewContainer?.layer.zPosition = 1
        tableView?.register(TableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView?.tableFooterView = UIView(frame: CGRect.zero)
        tableView?.autoresizingMask = .flexibleHeight
        tableView?.delegate = self
        tableView?.dataSource = self
    }
    
    open func showTableView() {
        if let controller = formViewController() {
            if tableViewContainer?.superview == nil {
                controller.tableView.addSubview(tableViewContainer!)
            }
            tableViewContainer?.isHidden = false
            layoutTableView()
        }
    }
    
    func layoutTableView() {
        if let controller = formViewController(), let tableContainer = tableViewContainer {
            let frame = self.frame
            let maxSuggestionRowHeight = (row as? MaxSuggestionRows)?.maxSuggestionRows ?? 5
            let tableViewFrame = CGRect(x: 0, y: frame.origin.y + frame.height, width: contentView.frame.width, height: 44 * CGFloat(maxSuggestionRowHeight))
            tableContainer.frame = tableViewFrame
            
            if tableViewFrame.maxY > controller.tableView.contentSize.height && tableContainer.isHidden == false {
                var contentInset = formContentInset ?? UIEdgeInsets.zero
                contentInset.bottom += (tableViewFrame.maxY - controller.tableView.contentSize.height)
                controller.tableView.contentInset = contentInset
            }
        }
    }
    
    open func hideTableView() {
        tableViewContainer?.isHidden = true
    }
    
    open override func cellBecomeFirstResponder(withDirection: Direction) -> Bool {
        let firstResponder = super.cellBecomeFirstResponder(withDirection: withDirection)
        layoutTableView()
        return firstResponder
    }
    
    override func reload() {
        tableView?.reloadData()
    }
        
    open override func setSuggestions(_ string: String) {
        if let filterFunction = (row as? FilterFunctions)?.filterFunction {
            suggestions = filterFunction(string) as? [T]
            reload()
        }
        if let asyncFilterFunction = (row as? FilterFunctions)?.asyncFilterFunction {
            asyncFilterFunction(string, { (values) in
                self.suggestions = values as? [T]
                self.reload()
            })
        }
    }
    
    open override func textFieldDidChange(_ textField: UITextField) {
        super.textFieldDidChange(textField)
        if textField.text?.isEmpty == false {
            showTableView()
        }
    }

    open override func textFieldDidEndEditing(_ textField: UITextField) {
        super.textFieldDidEndEditing(textField)
        hideTableView()
    }
    
    //MARK: UITableViewDelegate and Datasource
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions?.count ?? 0
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! TableViewCell
        cell.parentCell = self
        cell.setUp()
        if let prediction = suggestions?[(indexPath as NSIndexPath).row] {
            cell.setupForValue(prediction)
        }
        customizeTableViewCell?(cell)
        return cell
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let prediction = suggestions?[(indexPath as NSIndexPath).row] {
            row.value = prediction
            _ = cellResignFirstResponder()
        }
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
