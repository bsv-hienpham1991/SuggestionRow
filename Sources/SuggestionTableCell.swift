//
//  SuggestionTableCell.swift
//
//  Adapted from Mathias Claassen 4/14/16 by Hélène Martin 8/11/16
//
//

import Foundation
import UIKit
import Eureka

public protocol BaseSuggestionTableCellType: AnyObject {
    var suggestionViewYOffset: (() -> CGFloat)? { get set }
    var tableView: UITableView? { get set }
    var tableViewContainer: UIView? { get set }
}

open class SuggestionTableCell<T, TableViewCell: UITableViewCell>: SuggestionCell<T>, BaseSuggestionTableCellType, UITableViewDelegate, UITableViewDataSource where TableViewCell: EurekaSuggestionTableViewCell, TableViewCell.S == T {
    public var suggestionViewYOffset: (() -> CGFloat)?
    
    /// callback that can be used to customize the table cell.
    public var customizeTableViewCell: ((TableViewCell) -> Void)?
    
    public var tableView: UITableView?
    
    public var tableViewContainer: UIView?
    
    public var formContentInset: UIEdgeInsets?
    
    /**
     This property does not support UITableView.automaticDimension
     */
    public var suggestionTableViewCellHeight: ((_ indexPath: IndexPath) -> CGFloat)?

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
        tableViewContainer?.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
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
            var tableViewHeight: CGFloat = 0
            for i in 0..<maxSuggestionRowHeight {
                if let suggestionTableViewCellHeight = self.suggestionTableViewCellHeight {
                    tableViewHeight += suggestionTableViewCellHeight(IndexPath(row: i, section: 0))
                } else {
                    tableViewHeight += 44
                }
            }
            var tableViewFrame = CGRect(x: 0, y: frame.origin.y + frame.height, width: UIScreen.main.bounds.width, height: tableViewHeight)
            tableViewFrame.origin.y += (suggestionViewYOffset?() ?? 0)
            tableContainer.frame = tableViewFrame
                        
            // Adjust content inset to make sure suggestion list is available on screen
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
        
    open override func textFieldDidBeginEditing(_ textField: UITextField) {
        super.textFieldDidBeginEditing(textField)
        // Delay to wait until keyboard height is apply to content inset of form view controller
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(150)) {
            self.formContentInset = self.formViewController()?.tableView.contentInset
        }
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
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let suggestionTableViewCellHeight = suggestionTableViewCellHeight {
            return suggestionTableViewCellHeight(indexPath)
        } else {
            return 44
        }
    }
}
