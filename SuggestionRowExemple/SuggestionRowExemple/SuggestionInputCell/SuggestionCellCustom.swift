//
//  SuggestionCellCustom.swift
//  SuggestionRowExemple
//
//  Created by Hien Pham on 1/19/20.
//  Copyright © 2020 Hien Pham. All rights reserved.
//

import Foundation
import UIKit
import Eureka
import SnapKit
import SuggestionRow

protocol SuggestionHasCustomContentView: class {
    var contentViewProvider: ViewProvider<SuggestionCellContentView>? { get set }
}

class SuggestionCellContentView: UIView {
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var textField: UITextField!
    weak var firstResponderDelegate: SuggestionCellContentViewDelegate?
}

open class SuggestionCellCustom<T, TableViewCell: UITableViewCell>: SuggestionTableCell<T, TableViewCell> where TableViewCell: EurekaSuggestionTableViewCell, TableViewCell.S == T {
    var bsContentView: SuggestionCellContentView?
    var bsTableContainer: SuggestionTableContainer?
    
    fileprivate var suggsetionRowCustom: SuggestionHasCustomContentView? { return row as? SuggestionHasCustomContentView }

    open override func setup() {
        bsContentView = suggsetionRowCustom?.contentViewProvider?.makeView()
        if let unwrapped = bsContentView {
            contentView.addSubview(unwrapped)
            unwrapped.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
        bsContentView?.firstResponderDelegate = self
                
        if bsContentView != nil {
            textField.snp.removeConstraints()
            textField.removeFromSuperview()
            textField = bsContentView?.textField
        }
        
        bsTableContainer = (row as? SuggestionHasCustomTableView)?.tableViewProvider?.makeView()
        if let unwrapped = bsTableContainer {
            tableView = unwrapped.tableView
            tableViewContainer = unwrapped
        }
                
        super.setup()
    }
    
    open override func customConstraints() {
        
    }
    
    open override func update() {
        super.update()
        titleLabel?.isHidden = true
        bsContentView?.titleLabel?.text = row.title
    }
}
