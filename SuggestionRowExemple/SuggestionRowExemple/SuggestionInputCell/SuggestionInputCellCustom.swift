//
//  SuggestionInputCellCustom.swift
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

protocol SuggestionCellContentViewDelegate: class {
    func suggestionCellContentViewBecomeFirstRersponder(_ suggestionCellContentView: SuggestionCellContentView)
}

class SuggestionCellContentView: UIView {
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var textField: UITextField!
    weak var firstResponderDelegate: SuggestionCellContentViewDelegate?
}

open class SuggestionCellCustom<T, TableViewCell: UITableViewCell>: SuggestionTableCell<T, TableViewCell> where TableViewCell: EurekaSuggestionTableViewCell, TableViewCell.S == T {
    var bsContentView: SuggestionCellContentView?
    
    fileprivate var suggsetionRowCustom: SuggestionHasCustomContentView? { return row as? SuggestionHasCustomContentView }

    open override func setup() {
        bsContentView = suggsetionRowCustom?.viewProvider?.makeView()
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

extension SuggestionCellCustom: SuggestionCellContentViewDelegate {
    func suggestionCellContentViewBecomeFirstRersponder(_ suggestionCellContentView: SuggestionCellContentView) {
        cellBecomeFirstResponder(withDirection: .down)
    }
}

protocol SuggestionHasCustomContentView: class {
    var viewProvider: SuggestionContentViewProvider? { get set }
}

open class _SuggestionRowCustom<Cell: CellType> : _SuggestionRow<Cell>, SuggestionHasCustomContentView, NoValueDisplayTextConformance where Cell: BaseCell, Cell: TextFieldCell, Cell.Value: SuggestionValue {
    open var noValueDisplayText: String? = nil
    var viewProvider: SuggestionContentViewProvider?
    
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

public final class SuggestionRowCustom<T: SuggestionValue>: _SuggestionRowCustom<SuggestionCellCustom<T, SuggestionTableViewCell<T>>>, RowType {

    required public init(tag: String?) {
        super.init(tag: tag)
    }
}
