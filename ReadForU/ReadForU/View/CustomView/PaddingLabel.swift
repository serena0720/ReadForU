//
//  PaddingLabel.swift
//  ReadForU
//
//  Created by Serena on 2023/10/14.
//

import UIKit

class PaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
        self.numberOfLines = 0
        self.adjustsFontSizeToFitWidth = true
        self.textAlignment = .center
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
}
