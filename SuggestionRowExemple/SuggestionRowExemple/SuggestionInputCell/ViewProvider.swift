//
//  PickerContentViewProvider.swift
//  koremana
//
//  Created by Hien Pham on 1/18/20.
//  Copyright © 2020 Bravesoft. All rights reserved.
//

import Foundation
import UIKit

struct ViewProvider<T> where T: UIView {

    /// Nibname of the cell that will be created.
    public private (set) var nibName: String?

    /// Bundle from which to get the nib file.
    public private (set) var bundle: Bundle!

    public init() {}

    public init(nibName: String, bundle: Bundle? = nil) {
        self.nibName = nibName
        self.bundle = bundle
    }

    func makeView() -> T {
        if let nibName = self.nibName {
            return bundle.loadNibNamed(nibName, owner: nil, options: nil)!.first as! T
        }
        return T()
    }
}
