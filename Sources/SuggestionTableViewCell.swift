//
//  SuggestionTableViewCell.swift
//
//  Adapted from Mathias Claassen 4/14/16 by Hélène Martin 8/11/16
//
//

import Foundation
import Eureka

public protocol EurekaSuggestionTableViewCell {
    var parentCell: BaseCell? { get set }
    associatedtype S: SuggestionValue
    func setUp()
    func setupForValue(_ value: S)
}

/// Default cell for the table of the SuggestionTableCell
open class SuggestionTableViewCell<T: SuggestionValue>: UITableViewCell, EurekaSuggestionTableViewCell {
    public var parentCell: BaseCell?
    public typealias S = T
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        textLabel?.font = .systemFont(ofSize: 16)
        textLabel?.minimumScaleFactor = 0.8
        textLabel?.adjustsFontSizeToFitWidth = true
        if #available(iOS 13.0, *) {
            textLabel?.textColor = .label
            contentView.backgroundColor = .systemBackground
        } else {
            textLabel?.textColor = .black
            contentView.backgroundColor = .white
        }
        setUp()
    }
    
    open func setUp() {
        
    }
    
    open func setupForValue(_ value: T) {
        textLabel?.text = value.suggestionString
    }
}
