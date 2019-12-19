//
//  Button.swift
//  DeliveryApp
//
//  Created by Khadija Daruwala on 19/12/19.
//  Copyright © 2019 Khadija Daruwala. All rights reserved.
//

import Foundation
import UIKit

//MARK: Button
@IBDesignable open class SubmitButton: UIButton {
    
    func setup() {
        self.backgroundColor = UIColor.darkGray
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        self.setTitleColor(UIColor.white, for: .normal)
        self.contentEdgeInsets = UIEdgeInsets(top: 9, left: 0, bottom: 9, right: 0)
        self.contentHorizontalAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}
