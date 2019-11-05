//
//  ChatLabel.swift
//  ShareStory
//
//  Created by Tifo Audi Alif Putra on 02/11/19.
//  Copyright © 2019 BCC FILKOM. All rights reserved.
//

import UIKit

class ChatLabel: UILabel {
    
    var maxWidth: CGFloat = UIScreen.main.bounds.width / 2
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let width = min(size.width + 24, maxWidth)
        return CGSize(width: width, height: size.height + 16)
    }
}
